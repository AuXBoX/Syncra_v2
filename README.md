# Syncra v2 - Advanced Plex Playlist Manager

🎵 **Professional-grade playlist management for Plex Media Server with intelligent streaming service integration**

## ✨ Key Features

### 🎛️ **Advanced Playlist Management**
- **Real-time search & filtering** within playlists
- **Drag-and-drop reordering** with precise track positioning
- **Bulk operations** - select multiple tracks for batch actions
- **Smart duplicate detection** and removal
- **Export to M3U** format for universal compatibility

### 🔄 **Intelligent Streaming Integration**
- **Auto-sync** from Spotify, Deezer, and Tidal playlists
- **Advanced track matching** with fuzzy string algorithms
- **Version-aware matching** - prefers remastered over live versions
- **Manual search fallback** for unmatched tracks
- **Featured artist handling** with smart normalization

### 🛠️ **Professional Tools**
- **Playlist merger** with conflict resolution
- **Backup & restore** entire playlist collections
- **Library analytics** and duplicate track finder
- **Batch playlist operations** for power users
- **Performance monitoring** with detailed logging

### ⚡ **Performance & Reliability**
- **Lightning-fast caching** system for instant loading
- **Multi-threaded operations** - no UI freezing
- **Robust error handling** with automatic retries
- **Cross-platform compatibility** (Windows, macOS, Linux)

## 🚀 Download & Installation

### Quick Start
1. **Download** the latest release for your platform
2. **Extract** the archive (no installation required!)
3. **Run** the executable and connect to your Plex server
4. **Start managing** your playlists like a pro!

### Latest Release
Get the latest version from the [Releases](https://github.com/AuXBoX/Syncrav2/releases) page:

- **🪟 Windows**: Single executable, ready to run
- **🍎 macOS**: Universal binary for Intel & Apple Silicon  
- **🐧 Linux**: AppImage format for maximum compatibility

*Syncra v2 brings enhanced UI with modern animated logos, improved performance, and better streaming service integration.*

## 📋 System Requirements

| Platform | Requirements | Status |
|----------|-------------|--------|
| **🪟 Windows** | Windows 10/11 (64-bit) | ✅ Fully Tested |
| **🍎 macOS** | macOS 10.14+ (Mojave or later) | ⚠️ Community Tested |
| **🐧 Linux** | Ubuntu 18.04+ or equivalent | ⚠️ Community Tested |

**All platforms require:**
- Plex Media Server with music library
- Network access to Plex server
- Internet connection for streaming service sync

## 🎯 Quick Start

1. **Connect to Plex**: Enter your server details in the Connection tab
2. **Fetch Playlists**: Click "Fetch Playlists" to load your collection
3. **Edit Playlists**: Double-click any playlist to open the advanced editor
4. **Sync from Streaming**: Paste Spotify/Deezer/Tidal URLs to auto-sync
5. **Explore Tools**: Check out the Tools & Utilities for advanced features

## 🔄 Streaming Service Integration

### Supported Services & Formats
- 🎵 **Spotify** - Playlists, albums, individual tracks
- 🎶 **Deezer** - Playlists, albums, individual tracks  
- 🎧 **Tidal** - Playlists, albums, individual tracks
- 📁 **M3U/M3U8** - Local and remote playlist files

### Auto-Sync Setup
1. Navigate to **Sync Manager** tab
2. Select target Plex playlist
3. Paste **streaming service URL**
4. Configure **sync schedule** (manual, hourly, daily)
5. **Enable auto-sync** for hands-free updates

### Smart Matching Technology
- **Fuzzy string matching** finds tracks even with slight differences
- **Version preference system** - prioritizes remastered over live versions
- **Featured artist normalization** - handles "feat." variations intelligently
- **Manual search fallback** - user control when auto-matching fails
- **Context-aware matching** - acoustic playlists prefer acoustic versions

## 🏗️ Development & Technical Details

### Architecture
- **Single-file application** - `main.py` contains the entire application
- **Multi-threaded design** - non-blocking UI with background operations
- **JSON-based configuration** - persistent settings and cache system
- **Modular API integration** - clean separation of streaming service logic

### Technology Stack
```
Python 3.11          # Core language
PyQt5 >= 5.15.0      # Desktop GUI framework
PlexAPI >= 4.13.0    # Plex Media Server integration
Spotipy >= 2.22.0    # Spotify API client
FuzzyWuzzy >= 0.18.0 # Intelligent string matching
Requests >= 2.28.0   # HTTP client with retry logic
```

### Building from Source
```bash
# Clone repository
git clone https://github.com/AuXBoX/Syncrav2.git
cd Syncrav2

# Install dependencies
pip install -r requirements.txt

# Run application
python main.py
```

### 🔨 Building Standalone Executables

Syncra includes professional build tools in the `tools/` folder for creating standalone executables:

#### Windows Build Tools
- **`build_exe.bat`** - Standard build (recommended for distribution)
- **`build_advanced.bat`** - Advanced options (debug, optimized, development builds)
- **`quick_build.bat`** - Fast build for testing

#### Usage
```batch
# Navigate to tools folder
cd tools

# Run standard build (recommended)
build_exe.bat

# Or use advanced build with options
build_advanced.bat
```

#### Features
- ✅ **Fully standalone** - no Python installation required
- ✅ **All dependencies embedded** - PyQt5, PlexAPI, Spotipy, etc.
- ✅ **Single executable file** - easy distribution
- ✅ **Automatic dependency detection** - handles all imports
- ✅ **Icon and version info** - professional appearance
- ✅ **Multiple build types** - standard, debug, optimized
- ✅ **Build validation** - automatic testing and size reporting

The generated executable can run on any Windows computer without requiring Python or any dependencies to be installed.

See `tools/README.md` for detailed build instructions and troubleshooting.

## 🎉 Recent Improvements

### v2.0.0 - Modern UI & Enhanced Branding
- 🎆 **New modern logos** with animated synchronization elements
- 🎨 **Enhanced UI design** with teal and green color scheme
- 🔄 **Rotating circular symbols** representing sync functionality
- 📱 **Multiple logo formats** for different use cases (icon, logo, banner)
- ✨ **SVG-based graphics** for crisp rendering at any size

### v2.1.0 - Enhanced Matching & Search
- 🔍 **Manual search dialog** with real-time search results
- 🎯 **Artist-only search** for short titles to improve accuracy
- 🎤 **Aggressive featured artist removal** and mismatch penalties
- ⭐ **Version preference system** - remastered tracks get priority
- 🎵 **Context-aware matching** - acoustic playlists prefer acoustic versions
- 🐛 **Comprehensive bug fixes** and performance optimizations

### Previous Updates
- 🔍 **Search & Filter** capabilities in playlist editor
- 🎯 **Set Position** feature for precise track placement
- 🔄 **Sort by Streaming Service** to match external playlist order
- 📁 **Enhanced M3U support** with better file path handling
- ✨ **Improved track matching** algorithms

## 🤝 Contributing

We welcome contributions! Here's how you can help:

- 🐛 **Report bugs** via GitHub Issues
- 💡 **Suggest features** for future releases  
- 🔧 **Submit pull requests** with improvements
- 📖 **Improve documentation** and examples
- 🧪 **Test on different platforms** (especially macOS/Linux)

### Development Guidelines
- Follow the **KISS principle** - keep solutions simple
- Maintain **single-file architecture** for easy distribution
- Add **comprehensive error handling** for robustness
- Include **progress indicators** for long-running operations

## 🔧 Troubleshooting

### Common Issues
- **Connection failed**: Verify Plex server URL and credentials
- **Tracks not matching**: Try manual search or check track metadata
- **Slow performance**: Clear playlist cache in Tools & Utilities
- **Sync errors**: Check internet connection and streaming service URLs

### Getting Help
- 📖 Check the [Wiki](https://github.com/AuXBoX/Syncrav2/wiki) for detailed guides
- 🐛 Report issues on [GitHub Issues](https://github.com/AuXBoX/Syncrav2/issues)
- 💬 Join discussions in [GitHub Discussions](https://github.com/AuXBoX/Syncrav2/discussions)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Show Your Support

If Syncra v2 makes managing your Plex playlists easier, please:
- ⭐ **Star this repository** to show your support
- 🔄 **Share with fellow Plex users** who need better playlist management
- 💝 **Contribute** improvements, bug reports, or feature suggestions
- 📢 **Spread the word** in Plex communities and forums

---

*Made with ❤️ for the Plex community*
