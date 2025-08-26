# Project Structure & Organization

## Root Directory Layout
```
syncra/
├── main.py                 # Main application entry point (single-file architecture)
├── requirements.txt        # Python dependencies
├── README.md              # Project documentation with screenshots
├── LICENSE                # MIT license
├── Syncra Icon.ico        # Application icon for packaging
├── .gitignore            # Git ignore patterns
├── .github/              # GitHub workflows and templates
└── .kiro/                # Kiro AI assistant configuration
    └── steering/         # AI guidance documents
```

## Single-File Architecture
The application follows a single-file architecture pattern where `main.py` contains:
- All GUI classes and dialogs
- Threading classes for async operations
- API integration logic
- Configuration management
- Caching system implementation

## Runtime Files (Generated)
These files are created at runtime and should not be committed:
- `app_config.json` - Application settings and Plex connection details
- `sync_config.json` - Playlist sync configurations and schedules
- `playlist_cache.json` - Cached playlist data for performance
- `plex_playlist_manager.log` - Application logs (in temp directory)

## Key Classes Organization
- **Main Application**: `QMainWindow` with tabbed interface
- **Threading Classes**: `*Thread` classes for non-blocking operations
- **Dialog Classes**: Modal dialogs for specific operations
- **Utility Classes**: `PlaylistCache` for caching, configuration helpers
- **API Integration**: Embedded within main classes (Plex, Spotify, Deezer, Tidal)

## Configuration Pattern
- JSON-based configuration files with default value initialization
- Automatic config file creation on first run
- Settings persistence across application sessions
- Separate configs for app settings vs sync settings

## Asset Management
- Icon file included for PyInstaller packaging
- Resource path helper function for dev vs packaged environments
- Screenshots stored in GitHub for README display