@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Syncra Advanced Executable Builder
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python and try again
    pause
    exit /b 1
)

REM Display Python version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Using Python version: %PYTHON_VERSION%

REM Check if PyInstaller is installed
python -c "import PyInstaller" >nul 2>&1
if errorlevel 1 (
    echo PyInstaller not found. Installing...
    pip install pyinstaller
    if errorlevel 1 (
        echo ERROR: Failed to install PyInstaller
        pause
        exit /b 1
    )
)

REM Get PyInstaller version
for /f "tokens=2" %%i in ('pyinstaller --version 2^>^&1') do set PYINSTALLER_VERSION=%%i
echo Using PyInstaller version: %PYINSTALLER_VERSION%
echo.

REM Navigate to project root
cd /d "%~dp0.."

REM Check if main.py exists
if not exist "main.py" (
    echo ERROR: main.py not found in project root
    pause
    exit /b 1
)

REM Build options menu
echo Build Options:
echo 1. Standard build (recommended)
echo 2. Debug build (with console window)
echo 3. Optimized build (smaller size, longer build time)
echo 4. Development build (faster build, larger size)
echo.
set /p choice="Select build type (1-4): "

REM Set build parameters based on choice
if "%choice%"=="1" (
    set BUILD_TYPE=Standard
    set WINDOW_PARAM=--windowed
    set OPTIMIZE_PARAM=
    set DEBUG_PARAM=
) else if "%choice%"=="2" (
    set BUILD_TYPE=Debug
    set WINDOW_PARAM=--console
    set OPTIMIZE_PARAM=
    set DEBUG_PARAM=--debug=all
) else if "%choice%"=="3" (
    set BUILD_TYPE=Optimized
    set WINDOW_PARAM=--windowed
    set OPTIMIZE_PARAM=--strip --upx-dir=upx
    set DEBUG_PARAM=
) else if "%choice%"=="4" (
    set BUILD_TYPE=Development
    set WINDOW_PARAM=--windowed
    set OPTIMIZE_PARAM=--noconfirm
    set DEBUG_PARAM=
) else (
    echo Invalid choice, using standard build
    set BUILD_TYPE=Standard
    set WINDOW_PARAM=--windowed
    set OPTIMIZE_PARAM=
    set DEBUG_PARAM=
)

echo Selected: %BUILD_TYPE% build
echo.

REM Check for icon
if not exist "Syncra Icon.ico" (
    echo WARNING: Syncra Icon.ico not found, building without icon
    set ICON_PARAM=
) else (
    set ICON_PARAM=--icon="Syncra Icon.ico"
)

REM Create version info
echo Creating version info...
echo VSVersionInfo( > tools\version_info.txt
echo   ffi=FixedFileInfo( >> tools\version_info.txt
echo     filevers=(1,0,0,0), >> tools\version_info.txt
echo     prodvers=(1,0,0,0), >> tools\version_info.txt
echo     mask=0x3f, >> tools\version_info.txt
echo     flags=0x0, >> tools\version_info.txt
echo     OS=0x4, >> tools\version_info.txt
echo     fileType=0x1, >> tools\version_info.txt
echo     subtype=0x0, >> tools\version_info.txt
echo     date=(0, 0) >> tools\version_info.txt
echo   ), >> tools\version_info.txt
echo   kids=[ >> tools\version_info.txt
echo     StringFileInfo([ >> tools\version_info.txt
echo       StringTable('040904B0', [ >> tools\version_info.txt
echo         StringStruct('CompanyName', 'Syncra Project'), >> tools\version_info.txt
echo         StringStruct('FileDescription', 'Syncra - Advanced Plex Playlist Manager'), >> tools\version_info.txt
echo         StringStruct('FileVersion', '1.0.0.0'), >> tools\version_info.txt
echo         StringStruct('InternalName', 'Syncra'), >> tools\version_info.txt
echo         StringStruct('LegalCopyright', 'MIT License'), >> tools\version_info.txt
echo         StringStruct('OriginalFilename', 'Syncra.exe'), >> tools\version_info.txt
echo         StringStruct('ProductName', 'Syncra'), >> tools\version_info.txt
echo         StringStruct('ProductVersion', '1.0.0.0') >> tools\version_info.txt
echo       ]) >> tools\version_info.txt
echo     ]), >> tools\version_info.txt
echo     VarFileInfo([VarStruct('Translation', [1033, 1200])]) >> tools\version_info.txt
echo   ] >> tools\version_info.txt
echo ) >> tools\version_info.txt

echo Building %BUILD_TYPE% executable...
echo This may take several minutes depending on build type...
echo.

REM Build command
pyinstaller ^
    --onefile ^
    %WINDOW_PARAM% ^
    --name="Syncra" ^
    %ICON_PARAM% ^
    --version-file="tools\version_info.txt" ^
    --add-data="requirements.txt;." ^
    --hidden-import=PyQt5.QtSvg ^
    --hidden-import=PyQt5.QtWidgets ^
    --hidden-import=PyQt5.QtCore ^
    --hidden-import=PyQt5.QtGui ^
    --hidden-import=plexapi ^
    --hidden-import=spotipy ^
    --hidden-import=requests ^
    --hidden-import=fuzzywuzzy ^
    --hidden-import=pyotp ^
    --hidden-import=PIL ^
    --hidden-import=deezer ^
    --collect-all=PyQt5 ^
    --collect-all=plexapi ^
    --collect-all=spotipy ^
    --collect-all=fuzzywuzzy ^
    --collect-all=requests ^
    --distpath="dist" ^
    --workpath="build" ^
    --specpath="tools" ^
    %OPTIMIZE_PARAM% ^
    %DEBUG_PARAM% ^
    main.py

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    echo Check the output above for error details
    pause
    exit /b 1
)

echo.
echo ========================================
echo %BUILD_TYPE% Build Completed Successfully!
echo ========================================
echo.

REM Get file info
if exist "dist\Syncra.exe" (
    echo Executable: dist\Syncra.exe
    for %%A in ("dist\Syncra.exe") do (
        set /a size_mb=%%~zA/1024/1024
        echo File size: %%~zA bytes ^(!size_mb! MB^)
    )
    echo Build type: %BUILD_TYPE%
    echo Python version: %PYTHON_VERSION%
    echo PyInstaller version: %PYINSTALLER_VERSION%
) else (
    echo ERROR: Executable not found!
    exit /b 1
)

echo.
echo Features included:
echo ✓ Complete Python runtime
echo ✓ PyQt5 GUI framework  
echo ✓ Plex Media Server integration
echo ✓ Spotify API support
echo ✓ Deezer API support
echo ✓ Advanced fuzzy matching
echo ✓ All dependencies embedded
echo.
echo The executable is completely portable and can run on any Windows
echo computer without requiring Python or any dependencies.
echo.

REM Test the executable
set /p test="Test the executable now? (y/n): "
if /i "%test%"=="y" (
    echo Testing executable...
    start "" "dist\Syncra.exe"
    echo Executable launched. Check if it starts correctly.
    echo.
)

REM Cleanup options
echo Cleanup options:
echo 1. Keep all files (recommended for debugging)
echo 2. Clean build artifacts only
echo 3. Clean everything except executable
echo.
set /p cleanup="Select cleanup option (1-3): "

if "%cleanup%"=="2" (
    echo Cleaning build artifacts...
    rmdir /s /q "build" 2>nul
    echo Build artifacts cleaned.
) else if "%cleanup%"=="3" (
    echo Cleaning all temporary files...
    rmdir /s /q "build" 2>nul
    del "tools\Syncra.spec" 2>nul
    del "tools\version_info.txt" 2>nul
    echo All temporary files cleaned.
) else (
    echo Keeping all files for debugging.
)

echo.
echo Build complete! Press any key to exit...
pause >nul