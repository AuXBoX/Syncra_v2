# Syncra - Complete Application Guide

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture & Design](#2-architecture--design)
3. [Core Features](#3-core-features)
4. [Track Matching System](#4-track-matching-system)
5. [User Interface](#5-user-interface)
6. [API Integrations](#6-api-integrations)
7. [Performance Optimizations](#7-performance-optimizations)
8. [Configuration & Data Management](#8-configuration--data-management)
9. [Threading & Background Operations](#9-threading--background-operations)
10. [Recent Improvements](#10-recent-improvements)
11. [Development Environment](#11-development-environment)
12. [Troubleshooting & Known Issues](#12-troubleshooting--known-issues)

---

## 1. Project Overview

### What is Syncra?

Syncra is a professional-grade desktop application designed to enhance playlist management for Plex Media Server with intelligent integration of streaming services like Spotify, Deezer, and Tidal. It bridges the gap between streaming services and personal media libraries.

### Core Problem Solved

- **Inefficient playlist management** in Plex Media Server
- **Lack of auto-sync capabilities** with external streaming services
- **Manual playlist updates** and poor duplicate detection
- **Limited cross-platform compatibility** and performance issues

### Target Users

- Plex users who want advanced tools to manage music playlists
- Users who want to synchronize playlists from streaming platforms to their local library
- Music enthusiasts with large digital collections

### Key Features Overview

- **Advanced Playlist Editor**: Drag-and-drop, filtering, bulk operations
- **Auto-Sync**: Import from Spotify, Deezer, and Tidal with smart matching
- **Playlist Tools**: Backup, restore, merge, and analytics
- **Performance**: Multi-threaded operations with caching and progress indicators
- **Cross-Platform**: Windows, macOS, Linux support

---

## 2. Architecture & Design

### System Architecture

```
┌─────────────────────────────────────────┐
│         UI Layer (PyQt5)                │
│  Connection | Playlists | Sync | Tools  │
└─────────────┬───────────────────────────┘
              │ Signals/Slots
┌─────────────▼───────────────────────────┐
│      Business Logic Layer               │
│  Track Matching | Config | Threading   │
└─────────────┬───────────────────────────┘
              │ Background Threads
┌─────────────▼───────────────────────────┐
│       API Integration Layer             │
│  PlexAPI | Spotify | Deezer | Tidal    │
└─────────────────────────────────────────┘
```

### Design Patterns

- **Single-File Architecture**: All code in `main.py` (9,400+ lines) for easy distribution
- **MVC Pattern**: GUI (View) + Business Logic (Controller) + Data (Model)
- **Observer Pattern**: PyQt5 signals/slots for event communication
- **Strategy Pattern**: Interchangeable streaming service clients
- **Thread-Safe Communication**: All UI updates via signals from main thread

### Technology Stack

**Core Technologies:**
- **Python 3.11**: Core language
- **PyQt5 (≥5.15.0)**: GUI framework
- **PlexAPI (≥4.13.0)**: Plex server integration
- **FuzzyWuzzy (≥0.18.0)**: String matching algorithms

**API Integrations:**
- **Spotipy (≥2.22.0)**: Spotify client
- **Requests (≥2.28.0)**: HTTP communication
- **deezer-python (≥5.8.0)**: Deezer API integration
- **pyotp (≥2.8.0)**: 2FA support

**Additional Libraries:**
- **Pillow (≥9.0.0)**: Image handling
- **python-Levenshtein**: Enhanced string matching performance

---

## 3. Core Features

### 3.1 Playlist Management

**Basic Operations:**
- Create, edit, and delete playlists
- Add/remove tracks with drag-and-drop
- Reorder tracks within playlists
- Search and filter playlist contents

**Advanced Features:**
- **Playlist Merging**: Combine multiple playlists with duplicate detection
- **Smart Duplicates**: Advanced duplicate detection across playlists
- **Playlist Analytics**: Track count, duration, artist distribution
- **Version Preferences**: Automatic preference for remastered versions

### 3.2 Streaming Service Integration

**Supported Services:**
- **Spotify**: Full playlist import with OAuth authentication
- **Deezer**: Public playlist import (no authentication required)
- **Tidal**: Playlist import with token-based authentication

**Import Process:**
1. User provides playlist URL
2. Service API fetches track metadata
3. Intelligent track matching against Plex library
4. User confirmation for ambiguous matches
5. Playlist creation in Plex

### 3.3 Track Matching Engine

**Matching Strategy:**
- **Artist-First Search**: Search by artist before title for efficiency
- **Fuzzy String Matching**: Uses FuzzyWuzzy for similarity scoring
- **Version Filtering**: Filters out unwanted versions (remixes, live, etc.)
- **Confidence Scoring**: 0-100% confidence with user confirmation thresholds

**Title Cleaning Features:**
- **Dash Removal**: Removes " - From Soundtrack" type content
- **Featured Artist Removal**: Removes "feat." and "ft." content
- **Version Normalization**: Standardizes remaster and version tags

### 3.4 Backup & Restore

**Backup Features:**
- **Complete Library Backup**: Export all playlists to M3U format
- **Selective Backup**: Choose specific playlists to backup
- **Timestamped Backups**: Automatic timestamps for organization
- **Cross-Platform Compatibility**: Standard M3U format

**Restore Features:**
- **Bulk Restore**: Import multiple M3U files at once
- **Smart Matching**: Recreate playlists with track matching
- **Progress Tracking**: Real-time progress for large operations

---

## 4. Track Matching System

### 4.1 Matching Algorithm Overview

The track matching system is the core of Syncra's functionality, responsible for finding corresponding tracks in a user's Plex library when importing from streaming services.

### 4.2 Title Cleaning Pipeline

**Step 1: Dash Removal**
```
"Accidentally In Love - From Shrek 2 Soundtrack" → "Accidentally In Love"
"Track Name - More Info (Remastered)" → "Track Name (Remastered)"
```

**Step 2: Featured Artist Removal**
```
"Song feat. Artist" → "Song"
"Track (ft. Someone)" → "Track"
```

**Step 3: Version Normalization**
```
"Song (2021 Remaster)" → standardized format
"Track [Deluxe Edition]" → standardized format
```

### 4.3 Short Title Optimization

For titles ≤4 characters (like "You", "Bad", "Run"), uses structured search:

1. **Artist Search**: Check if artist exists in library
2. **Artist Not Found**: User dialog → Skip Track or Manual Search
3. **Album Search**: Search for album within artist's discography
4. **Album Not Found**: Search title within all artist's songs
5. **Album Found**: Search track within specific album only

**Benefits:**
- Eliminates expensive library-wide searches
- Reduces API calls from 200+ to 2-5
- Improves accuracy by searching within artist scope

### 4.4 Version Filtering System

**Clean Source Tracks** (no version info):
- ✅ **Allowed**: Remastered, Stereo, Original, Radio Edit, Explicit
- ✅ **Available but Penalized**: Live (-5 points), Acoustic (-2 points)
- ❌ **Rejected**: Specific remixes (Extended Mix, Club Mix, Dance Mix)

**Source with Version Info**:
- **Live Matching**: Live sources only match live Plex tracks
- **Remix Compatibility**: Requires 85% similarity for remix matching
- **Consistent Versioning**: Major version types must match

### 4.5 Scoring System

**Title Similarity**: 70% weight using fuzzy string matching
**Artist Similarity**: 30% weight
**Confidence Thresholds**:
- **≥80%**: Auto-accept (high confidence)
- **60-79%**: User confirmation required
- **<60%**: Manual search triggered

**Preference Bonuses**:
- Remastered versions: +3.0 to +4.0 points
- Anniversary editions: +2.0 points
- Deluxe editions: +1.0 points
- Live versions: -5.0 points (penalty)

---

## 5. User Interface

### 5.1 Main Window Structure

**Navigation System:**
- **QStackedWidget** for multi-page interface
- **Dark Theme** with consistent styling
- **Responsive Layout** that adapts to window size

**Page Structure:**
```python
PAGES = {
    'CONNECTION': 0,    # Plex server setup
    'PLAYLISTS': 1,     # Playlist management  
    'SYNC_MANAGER': 2,  # Auto-sync configuration
    'TOOLS': 3          # Utilities and tools
}
```

### 5.2 Connection Page

**Plex Server Configuration:**
- Server IP and port input
- Authentication token management
- Connection testing and validation
- Library section selection

**Features:**
- Auto-detection of local Plex servers
- Token validation with server ping
- Error handling with clear feedback
- Remember connection settings

### 5.3 Playlist Management Page

**Main Interface:**
- **Playlist List**: Shows all available playlists with track counts
- **Track Editor**: Advanced playlist editing with drag-and-drop
- **Search/Filter**: Real-time filtering of playlists and tracks
- **Bulk Operations**: Select multiple items for batch operations

**Advanced Features:**
- **Real-time Track Counts**: Cached for performance
- **Large Playlist Handling**: Optimized for playlists with 1000+ tracks
- **Context Menus**: Right-click actions for quick operations
- **Keyboard Shortcuts**: Power user functionality

### 5.4 Sync Manager

**Streaming Service Integration:**
- **Service Selection**: Choose from Spotify, Deezer, Tidal
- **URL Input**: Paste playlist URLs for import
- **Authentication**: Service-specific auth handling
- **Progress Tracking**: Real-time import progress

**Import Configuration:**
- **Matching Thresholds**: Adjust confidence levels
- **Version Preferences**: Configure preferred track versions
- **Skip Options**: Bulk skip low-confidence matches

### 5.5 Tools Page

**Utility Functions:**
- **Backup Management**: Export playlists to M3U
- **Duplicate Detection**: Find and manage duplicate tracks
- **Playlist Analytics**: Statistics and insights
- **Cache Management**: Clear and optimize caches

---

## 6. API Integrations

### 6.1 Plex Media Server Integration

**PlexAPI Usage:**
```python
# Connection
self.plex_server = PlexServer(server_url, token)
library_section = self.plex_server.library.sectionByID(section_id)

# Playlist Operations
playlist = library_section.createPlaylist(title=name, items=tracks)
existing_playlist.addItems(new_tracks)
playlist.uploadPoster(image_data)

# Search Operations
artist_results = library_section.searchArtists(title=artist)
track_results = library_section.searchTracks(title=title)
```

**Key Features:**
- **Server Discovery**: Auto-detect local Plex servers
- **Token Authentication**: Secure API access
- **Library Management**: Full CRUD operations on playlists
- **Search Optimization**: Efficient querying with caching

### 6.2 Spotify Integration

**Authentication Method:**
- Uses `sp_dc` cookie extraction (no OAuth setup required)
- TOTP-based token generation for session management
- Anonymous access for public playlists

**Implementation:**
```python
class SpotifyAnonymousAuth:
    def authenticate_with_cookie(self, sp_dc_cookie):
        # Extract session token from cookie
        # Generate access token using TOTP
        # Return authenticated session
        
    def get_playlist_tracks(self, playlist_id):
        # Fetch all tracks with pagination
        # Return structured track data
```

### 6.3 Deezer Integration

**Public API Access:**
- No authentication required for public playlists
- Simple REST API calls
- JSON response parsing

```python
class DeezerClient:
    def get_playlist(self, playlist_id):
        response = self.session.get(f"{self.BASE_URL}playlist/{playlist_id}")
        return response.json()
```

### 6.4 Tidal Integration

**Token-Based Authentication:**
- User provides API token
- Direct API access to playlist data
- Handle rate limiting and errors

```python
class TidalClient:  
    def get_playlist_tracks(self, uuid):
        params = {'limit': 500, 'countryCode': 'US'}
        response = self.session.get(f"{self.BASE_URL}playlists/{uuid}/tracks", params=params)
        return response.json()
```

---

## 7. Performance Optimizations

### 7.1 Caching System

**Playlist Cache:**
```python
class PlaylistCache:
    def __init__(self):
        self.cache_data = {"playlists": {}, "last_updated": {}, "version": "1.0"}
    
    def get_track_count(self, playlist_id):
        # Return cached track count if available
    
    def set_playlist_data(self, playlist_id, track_count):
        # Cache track count with timestamp
```

**Benefits:**
- **Instant Loading**: Cached track counts load immediately
- **Reduced API Calls**: Avoid repeated Plex server queries
- **Persistent Storage**: JSON-based cache survives app restarts

### 7.2 Multi-Threading Architecture

**Background Thread Classes:**
- **FetchPlaylistsThread**: Load playlists from Plex server
- **LoadTrackCountThread**: Count tracks asynchronously  
- **PlaylistConverterThread**: Handle streaming service imports
- **BackupThread**: Export playlists for backup
- **FindDuplicatesThread**: Detect duplicate tracks

**Thread Communication:**
```python
class CustomThread(QThread):
    progress_update = pyqtSignal(int)
    result_ready = pyqtSignal(object)
    error_occurred = pyqtSignal(str)
    
    def run(self):
        # Background processing
        self.progress_update.emit(progress_percentage)
        self.result_ready.emit(results)
```

### 7.3 Short Title Search Optimization

**Problem**: Titles like "You" would cause 200+ API calls scanning entire library

**Solution**: Structured artist-first search
- Step 1: Check artist exists (1 API call)
- Step 2: Get artist's albums (1 API call)
- Step 3: Search within specific album (efficient)

**Results**: 98% reduction in API calls (200+ → 2-5)

**Implementation Details**: This optimization addresses a critical performance issue where searching for common short titles would trigger expensive library-wide searches. The structured approach ensures that:
- Artist existence is verified first (1 API call)
- If artist doesn't exist, user is immediately notified with options
- Album-specific searches are performed when possible
- Fallback to artist-wide search only when necessary
- No library-wide searches are performed for short titles

### 7.4 Large Playlist Handling

**Optimizations for 1000+ track playlists:**
- **Batch Processing**: Load tracks in chunks of 50
- **Progressive Loading**: Show progress during long operations
- **Memory Management**: Efficient object handling
- **UI Responsiveness**: Regular `processEvents()` calls

---

## 8. Configuration & Data Management

### 8.1 Configuration Files

**app_config.json** - Plex Connection Settings:
```json
{
    "plex_username": "user@example.com",
    "server_ip": "192.168.1.100", 
    "server_port": "32400",
    "token": "plex_access_token",
    "last_section": "music_library_id",
    "auto_backup": true,
    "backup_interval": 24
}
```

**sync_config.json** - Auto-Sync Settings:
```json
{
    "sync_playlists": {
        "playlist_id": {
            "name": "My Playlist",
            "source_url": "https://open.spotify.com/playlist/...",
            "last_sync": "2024-01-15T10:30:00",
            "auto_sync": true
        }
    },
    "auto_sync": false,
    "sync_interval": 60
}
```

**playlist_cache.json** - Performance Cache:
```json
{
    "playlists": {
        "playlist_id": {
            "track_count": 45,
            "cached_at": "2024-01-15T10:30:00"
        }
    },
    "version": "1.0"
}
```

### 8.2 Data Persistence

**Configuration Management:**
- **Automatic Loading**: Config loaded on startup
- **Real-time Saving**: Changes saved immediately
- **Default Fallbacks**: Graceful handling of missing configs
- **Validation**: Input validation with error handling

**Cache Management:**
- **Automatic Cleanup**: Remove stale cache entries
- **Size Management**: Prevent cache from growing too large
- **Integrity Checks**: Validate cache data before use

---

## 9. Threading & Background Operations

### 9.1 Thread Safety Model

**Main Thread Responsibilities:**
- UI rendering and event handling
- Configuration management
- User interaction and dialogs

**Background Thread Responsibilities:**
- API calls to Plex and streaming services
- Track matching and processing
- File I/O operations
- Long-running computations

**Communication Pattern:**
```python
# Thread emits signal
self.progress_update.emit("Processing...", 50)

# Main thread receives signal
thread.progress_update.connect(self.update_progress_bar)
```

### 9.2 User Response Handling

**Blocking Operations with User Input:**
```python
# Thread waits for user response
def wait_for_user_response(self):
    self.response_received.clear()
    self.response_received.wait()  # Block until response
    return self.user_response

# Main thread provides response
def set_user_response(self, response):
    self.user_response = response
    self.response_received.set()  # Unblock waiting thread
```

### 9.3 Progress Tracking

**Multi-Level Progress Indicators:**
- **Overall Progress**: Total import/export progress
- **Item Progress**: Individual track/playlist progress
- **Detailed Status**: Current operation description

**Progress Dialog Features:**
- **Real-time Updates**: Progress bars update smoothly
- **Cancellation Support**: Allow users to cancel long operations
- **Error Reporting**: Show errors without stopping entire operation

---

## 10. Recent Improvements

### 10.1 Artist Detection Enhancement

**Problem**: Tracks with non-existent artists would go through extensive search attempts

**Solution**: Early artist detection with user dialog
- Check artist existence before track search
- Show clear dialog when artist not found
- Options: Skip Track or Manual Search

**Benefits**:
- Faster processing for missing artists
- Clear user feedback
- Better control over import process

### 10.2 Dash Removal Feature

**Problem**: Titles like "Accidentally In Love - From Shrek 2 Soundtrack" failed to match

**Solution**: Intelligent dash removal in title cleaning
- Remove dash and everything after until brackets
- Preserve bracket content and apply normal rules
- Apply consistently throughout matching pipeline

**Examples**:
```
"Accidentally In Love - From Shrek 2 Soundtrack" → "Accidentally In Love"
"Track Name - More Info (Remastered)" → "Track Name (Remastered)"
```

**Latest Enhancement**: The dash removal feature now works consistently throughout the entire matching pipeline, including version filtering. Previously, dash removal was applied during search but not during version comparison, causing soundtrack content to be incorrectly rejected.

### 10.3 Short Title Search Optimization

**Problem**: Searching for "You" by "Candlebox" caused 200+ API calls

**Solution**: Structured search approach
1. Search for artist (1 call)
2. Check if artist exists → user dialog if not
3. Search for album within artist (1 call)
4. If album exists → search within album
5. If album doesn't exist → search within all artist songs

**Results**: 98% reduction in API calls, 90% faster processing

### 10.4 Version Filtering Improvements

**Enhanced Filtering Logic:**
- More permissive matching for common versions
- Context-aware acoustic/unplugged matching
- Better preference scoring for remastered versions
- Strict filtering for unwanted remixes

### 10.5 Soundtrack Content Support (Latest)

**Problem**: Soundtrack titles with dash notation were being rejected by version filtering

**Example Issue**: 
```
"Accidentally In Love - From 'Shrek 2' Soundtrack" → cleaned to "Accidentally In Love"
Plex track: "Accidentally In Love (From 'Shrek 2' Soundtrack)"
Result: Rejected due to version filtering inconsistency
```

**Solution Implemented**: Two-part fix for comprehensive soundtrack support

**Part 1 - Consistent Title Cleaning Application**:
```python
# Apply dash removal consistently throughout matching pipeline
dash_cleaned_source = self.clean_title_for_search(title)
if not self.is_acceptable_version_match(dash_cleaned_source, clean_plex_title):
    # Version filtering now uses fully cleaned source title
```

**Part 2 - Expanded Version Filtering for Soundtracks**:
```python
# Added soundtrack-related terms to allowed version types
allowed_when_source_clean = [
    'remaster', 'remastered', 'remastered version', 'remastered edition',
    'stereo', 'mono', 'original', 'album version', 'single version',
    'explicit', 'clean', 'radio edit', 'radio version',
    # NEW: Soundtrack and compilation variants
    'soundtrack', 'from', 'motion picture', 'movie', 'film',
    'ost', 'original soundtrack', 'original motion picture soundtrack'
]
```

**Benefits**:
- Soundtrack content now matches properly after dash removal
- Consistent title cleaning applied across entire matching pipeline
- Expanded support for movie/film soundtrack variations
- Maintains strict filtering for unwanted remix content

**Test Cases**:
- ✅ "Song - From Movie Soundtrack" → "Song" matches "Song (From Movie Soundtrack)"
- ✅ "Track - Original Motion Picture" → "Track" matches "Track (Original Motion Picture)"
- ✅ "Title - From Film" → "Title" matches "Title (From Film)"

---

## 11. Development Environment

### 11.1 Setup Instructions

**Prerequisites:**
- Python 3.11
- pip package manager
- Git

**Installation:**
```bash
# Clone repository
git clone https://github.com/AuXBoX/Syncrav2.git
cd Syncrav2

# Install dependencies
pip install -r requirements.txt

# Run application
python main.py
```

**Development Dependencies:**
```
PyQt5>=5.15.0
PlexAPI>=4.13.0
Spotipy>=2.22.0
FuzzyWuzzy>=0.18.0
python-Levenshtein>=0.12.0
Requests>=2.28.0
deezer-python>=5.8.0
pyotp>=2.8.0
Pillow>=9.0.0
```

### 11.2 Building Executables

**Using PyInstaller:**
```bash
# Install PyInstaller
pip install pyinstaller

# Build single-file executable
pyinstaller --onefile --windowed --icon="Syncra Icon.ico" main.py

# Output location
dist/main.exe  # Windows
dist/main     # macOS/Linux
```

**Distribution Formats:**
- **Windows**: Single .exe file
- **macOS**: Universal binary (.app bundle)
- **Linux**: AppImage format

### 11.3 Code Organization

**File Structure:**
```python
# Lines 1-200: Imports, Constants, Utilities
import sys, json, os, logging, pyotp
from PyQt5.QtWidgets import *
from plexapi.server import PlexServer

# Lines 201-600: Cache Management Classes
class PlaylistCache:
    # Cache functionality

# Lines 601-2000: Background Thread Classes
class LoadTrackCountThread(QThread):
class BackupThread(QThread):
class PlaylistConverterThread(QThread):

# Lines 2001-3500: Dialog Classes
class TrackMatchConfirmationDialog(QDialog):
class ManualSearchDialog(QDialog):

# Lines 3501-4500: API Client Classes
class SpotifyAnonymousAuth:
class DeezerClient:
class TidalClient:

# Lines 4501-6000: Core Matching Logic
class PlaylistConverterThread:
    def find_best_match(self):  # Main matching algorithm
    def clean_title_for_search(self):  # Title cleaning

# Lines 6001-9400: Main Application Window
class PlexPlaylistManager(QMainWindow):
    def setup_ui(self):  # Interface creation
    def connect_to_plex(self):  # Server connection

# Lines 9400+: Application Entry Point
if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = PlexPlaylistManager()
    sys.exit(app.exec_())
```

### 11.4 Key Implementation Patterns

**Error Handling:**
```python
try:
    # Risky operation
    result = api_call()
except Exception as e:
    logging.error(f"Operation failed: {str(e)}")
    # Graceful fallback
```

**Progress Reporting:**
```python
for i, item in enumerate(items):
    progress = int((i / len(items)) * 100)
    self.progress_update.emit(f"Processing {item}...", progress)
    # Process item
```

**Signal-Slot Communication:**
```python
# Define signals
class WorkerThread(QThread):
    result_ready = pyqtSignal(object)
    
# Connect in main thread
worker.result_ready.connect(self.handle_result)
```

---

## 12. Troubleshooting & Known Issues

### 12.1 Common Issues

**Connection Problems:**
- **Plex Server Not Found**: Check server IP, port, and network connectivity
- **Authentication Failed**: Verify Plex token is valid and has proper permissions
- **Library Not Accessible**: Ensure music library is properly configured

**Performance Issues:**
- **Slow Playlist Loading**: Clear cache and restart application
- **High Memory Usage**: Close and reopen for large operations
- **UI Freezing**: Background operations should prevent this; restart if occurs

**Matching Problems:**
- **No Matches Found**: Use manual search for difficult tracks
- **Wrong Matches**: Adjust confidence thresholds in settings
- **Missing Artists**: Check if artist exists in Plex library

### 12.2 Debugging

**Log File Location:**
- Windows: `%TEMP%\plex_playlist_manager.log`
- macOS/Linux: `/tmp/plex_playlist_manager.log`

**Debug Information:**
- All API calls are logged with timestamps
- Matching scores and decisions are recorded
- User actions and responses are tracked

**Enabling Verbose Logging:**
```python
logging.basicConfig(level=logging.DEBUG)
```

### 12.3 Known Limitations

**Platform Compatibility:**
- macOS and Linux versions are community-tested
- Some features may behave differently across platforms

**API Limitations:**
- Streaming service rate limits may cause delays
- Plex server performance affects response times
- Large libraries (10,000+ tracks) may have slower searches

**Matching Accuracy:**
- Complex track titles may require manual matching
- Different metadata standards between services
- Version mismatches for remastered/live tracks

### 12.4 Performance Recommendations

**For Large Libraries:**
- Enable caching for faster subsequent loads
- Use selective sync instead of full library imports
- Regular cache cleanup to maintain performance

**For Slow Networks:**
- Increase timeout values in configuration
- Use smaller batch sizes for operations
- Consider local Plex server for better performance

**For Short Title Searches:**
- The application automatically optimizes short title searches (≤4 characters)
- Manual search is available if structured search doesn't find the artist
- Consider using more specific search terms when possible

### 12.5 Recent Bug Fixes & Enhancements

**Short Title Performance Fix (Latest)**:
- **Issue**: Tracks like "You" by "Candlebox" caused 200+ API calls
- **Solution**: Implemented structured Artist → Album → Track search hierarchy
- **Result**: 98% reduction in API calls, 90% faster processing
- **User Impact**: Immediate feedback when artists don't exist, option to skip or manual search

**Dash Removal Consistency Fix (Latest)**:
- **Issue**: Soundtrack titles like "Song - From Movie" weren't matching consistently
- **Root Cause**: Title cleaning applied during search but not version filtering
- **Solution**: Applied dash removal consistently throughout entire matching pipeline
- **Enhancement**: Expanded version filtering to support soundtrack-related terms
- **Result**: Soundtrack content now matches properly after dash removal

**Title Cleanup Bug Fix (Latest)**:
- **Issue**: Titles ending with parentheses like "It's The End Of The World As We Know It (And I Feel Fine)" were having closing parentheses stripped
- **Root Cause**: Aggressive cleanup in `clean_title_for_search()` was removing all trailing punctuation including legitimate parentheses
- **Impact**: Version filtering incorrectly identified "And I Feel Fine" as version info instead of song title
- **Solution**: Modified cleanup logic to preserve matched parentheses/brackets that are part of legitimate song titles
- **Additional Fix**: Enhanced dash removal logic to properly handle bracket preservation according to title cleaning specification
- **Result**: Songs with parentheses in titles now match correctly
- **Status**: ✅ **RESOLVED** - R.E.M. tracks and similar titles with parentheses now match properly

**Version Filtering Enhancement (Latest)**:
- Added support for soundtrack-related version types
- Improved consistency between title cleaning and version comparison
- Enhanced matching for movie/film soundtrack variations
- Maintained strict filtering for unwanted remix content

---

## Conclusion

Syncra provides a comprehensive solution for Plex playlist management with intelligent streaming service integration. The application combines powerful matching algorithms, user-friendly interfaces, and robust performance optimizations to deliver a professional-grade tool for music library management.

The modular architecture allows for easy extension and maintenance, while the single-file design ensures simple distribution and deployment. With continued development focusing on user feedback and performance improvements, Syncra represents a significant enhancement to the Plex ecosystem.

### Recent Developments

The latest improvements focus on performance optimization and matching accuracy:

- **Short Title Optimization**: Eliminated performance bottlenecks for common short titles
- **Soundtrack Support**: Enhanced support for movie and TV soundtrack content
- **Matching Consistency**: Improved reliability of the track matching pipeline
- **User Experience**: Better feedback and control over the matching process

These enhancements ensure that Syncra continues to evolve as a robust and reliable tool for managing large music libraries with complex metadata requirements.

### Getting Started

1. **Setup**: Follow the installation instructions in Section 11.1
2. **Connect**: Configure your Plex server connection on the Connection page
3. **Import**: Use the Sync Manager to import playlists from streaming services
4. **Manage**: Use the advanced playlist editor for ongoing management
5. **Backup**: Regular backups ensure your playlists are preserved

For developers looking to contribute or extend the application, the complete codebase is contained in `main.py` with clear section organization and comprehensive documentation throughout.

### Latest Updates Summary

**Performance Improvements**:
- Short title search optimization (98% reduction in API calls)
- Structured search hierarchy for missing artists
- Enhanced caching and background processing

**Matching Enhancements**:
- Consistent dash removal throughout matching pipeline
- Expanded soundtrack content support
- Improved version filtering accuracy

**User Experience**:
- Clear feedback for missing artists
- Better control over matching process
- Enhanced progress tracking and error handling

These improvements make Syncra more efficient, accurate, and user-friendly while maintaining its comprehensive feature set for professional playlist management.