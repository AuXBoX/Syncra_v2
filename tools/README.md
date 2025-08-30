# Syncra Build Tools

This folder contains build scripts to create standalone executable files for Syncra.

## Build Scripts

### 1. `build_exe.bat` - Standard Build (Recommended)
The main build script that creates a fully standalone executable with all dependencies embedded.

**Features:**
- Automatic dependency detection and embedding
- Icon integration
- Error checking and validation
- Build artifact cleanup options
- Detailed build information

**Usage:**
```batch
cd tools
build_exe.bat
```

### 2. `build_advanced.bat` - Advanced Build Options
Provides multiple build configurations for different use cases.

**Build Types:**
- **Standard**: Recommended for distribution (windowed, optimized)
- **Debug**: Includes console window for debugging
- **Optimized**: Smaller file size with compression (requires UPX)
- **Development**: Faster build time for testing

**Features:**
- Version information embedding
- Multiple optimization levels
- Build testing options
- Comprehensive cleanup options

**Usage:**
```batch
cd tools
build_advanced.bat
```

### 3. `quick_build.bat` - Fast Build
Minimal build script for quick testing during development.

**Usage:**
```batch
cd tools
quick_build.bat
```

## Requirements

### System Requirements
- Windows 10 or later
- Python 3.7+ installed and in PATH
- At least 2GB free disk space for build process

### Python Dependencies
The build scripts will automatically install PyInstaller if not present:
```batch
pip install pyinstaller
```

### Optional Tools
- **UPX** (for optimized builds): Download from https://upx.github.io/
  - Extract to `tools/upx/` folder for automatic detection

## Build Output

All builds create:
- `dist/Syncra.exe` - The standalone executable
- `build/` - Temporary build files (can be deleted)
- `tools/Syncra.spec` - PyInstaller specification file

## Executable Features

The generated executable includes:
- ✅ Complete Python runtime (no Python installation required)
- ✅ PyQt5 GUI framework
- ✅ Plex Media Server integration (PlexAPI)
- ✅ Spotify API support (Spotipy)
- ✅ Deezer API support
- ✅ Fuzzy string matching (FuzzyWuzzy)
- ✅ All required dependencies
- ✅ Application icon and version info

## Distribution

The generated `Syncra.exe` file is completely portable and can be:
- Copied to any Windows computer
- Run without installing Python or dependencies
- Distributed as a single file
- Stored on USB drives or network shares

## Troubleshooting

### Common Issues

**"Python is not installed or not in PATH"**
- Install Python from https://python.org
- Make sure to check "Add Python to PATH" during installation

**"Build failed" errors**
- Check that all dependencies are installed: `pip install -r requirements.txt`
- Ensure you have sufficient disk space (2GB+)
- Try the quick_build.bat first to isolate issues

**Large executable size**
- Use the "Optimized" build type in build_advanced.bat
- Install UPX for compression
- Consider excluding unused modules (advanced users)

**Antivirus false positives**
- Some antivirus software may flag PyInstaller executables
- Add the dist/ folder to antivirus exclusions during build
- This is a known PyInstaller limitation, not a security issue

### Getting Help

If you encounter issues:
1. Try the quick_build.bat first
2. Check the console output for specific error messages
3. Ensure all dependencies are installed
4. Verify Python and PyInstaller versions are compatible

## Advanced Configuration

### Custom Icon
Replace `Syncra Icon.ico` in the project root with your custom icon.

### Version Information
Edit the version info in `build_advanced.bat` to customize:
- Company name
- File description
- Version numbers
- Copyright information

### Additional Dependencies
To include additional Python packages, add them to the build scripts:
```batch
--hidden-import=your_package_name
--collect-all=your_package_name
```

## Build Performance

**Typical build times:**
- Quick build: 2-3 minutes
- Standard build: 5-8 minutes  
- Optimized build: 10-15 minutes
- Debug build: 3-5 minutes

**Executable sizes:**
- Standard: ~80-120 MB
- Optimized (with UPX): ~40-60 MB
- Debug: ~100-150 MB