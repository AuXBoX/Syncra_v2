# Technology Stack & Build System

## Core Technologies
- **Python 3.11** - Primary language
- **PyQt5** - Desktop GUI framework
- **PlexAPI** - Plex Media Server integration
- **Spotipy** - Spotify API integration
- **Deezer-python** - Deezer API integration
- **FuzzyWuzzy** - Fuzzy string matching for track identification
- **Requests** - HTTP client with retry logic
- **PyOTP** - Two-factor authentication support

## Key Dependencies
```
PyQt5>=5.15.0
plexapi>=4.13.0
requests>=2.28.0
spotipy>=2.22.0
fuzzywuzzy>=0.18.0
python-levenshtein>=0.20.0
pyotp>=2.8.0
deezer-python>=5.8.0
Pillow>=9.0.0
```

## Architecture Patterns
- **Threading**: Extensive use of QThread for non-blocking operations (playlist loading, track counting, backups)
- **Caching**: JSON-based playlist cache system for performance optimization
- **Configuration**: JSON config files for app settings and sync configurations
- **Error Handling**: Comprehensive logging with fallback mechanisms
- **UI/UX**: Modal dialogs with progress bars for long-running operations

## Common Commands
```bash
# Install dependencies
pip install -r requirements.txt

# Run application
python main.py

# Package for distribution (PyInstaller)
pyinstaller --onefile --windowed --icon="Syncra Icon.ico" main.py
```

## Build Notes
- Single-file executable distribution via PyInstaller
- Cross-platform support with platform-specific command handling
- Resource path handling for both development and packaged environments
- Temporary directory usage for logs to avoid permission issues