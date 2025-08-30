@echo off
echo ========================================
echo Syncra Standalone Executable Builder
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

REM Check if PyInstaller is installed
echo Checking PyInstaller installation...
python -c "import PyInstaller; print('PyInstaller version:', PyInstaller.__version__)" 2>nul
if errorlevel 1 (
    echo PyInstaller not found. Installing...
    echo This may take a few minutes...
    python -m pip install --upgrade pip
    python -m pip install pyinstaller
    if errorlevel 1 (
        echo ERROR: Failed to install PyInstaller
        echo Try running: python -m pip install pyinstaller
        pause
        exit /b 1
    )
    echo PyInstaller installed successfully!
) else (
    echo PyInstaller is already installed.
)

REM Verify PyInstaller is accessible
echo Verifying PyInstaller installation...
python -m PyInstaller --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: PyInstaller is installed but not accessible
    echo Try running the build with: python -m PyInstaller instead
    pause
    exit /b 1
)

REM Navigate to project root (parent directory)
cd /d "%~dp0.."

REM Check if main.py exists
if not exist "main.py" (
    echo ERROR: main.py not found in project root
    echo Make sure you're running this from the tools folder
    pause
    exit /b 1
)

REM Check for icon files and copy to tools directory for PyInstaller
set ICON_PARAM=
if exist "Syncra_v2_Icon.ico" (
    echo Using Syncra v2 icon
    copy "Syncra_v2_Icon.ico" "tools\" >nul
    set ICON_PARAM=--icon="Syncra_v2_Icon.ico"
) else if exist "Syncra Icon.ico" (
    echo Using original Syncra icon
    copy "Syncra Icon.ico" "tools\" >nul
    set ICON_PARAM=--icon="Syncra Icon.ico"
) else (
    echo WARNING: No icon file found, building without icon
)

echo Building standalone executable...
echo This may take several minutes...
echo.

REM Build the executable with all dependencies embedded
python -m PyInstaller ^
    --onefile ^
    --windowed ^
    --name="Syncra" ^
    %ICON_PARAM% ^
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
    --hidden-import=json ^
    --hidden-import=logging ^
    --hidden-import=threading ^
    --hidden-import=datetime ^
    --hidden-import=tempfile ^
    --hidden-import=os ^
    --hidden-import=sys ^
    --hidden-import=re ^
    --collect-all=PyQt5 ^
    --collect-all=plexapi ^
    --collect-all=spotipy ^
    --collect-all=fuzzywuzzy ^
    --collect-all=requests ^
    --distpath="dist" ^
    --workpath="build" ^
    --specpath="tools" ^
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
echo Build completed successfully!
echo ========================================
echo.
echo Executable location: dist\Syncra.exe
echo File size: 
for %%A in ("dist\Syncra.exe") do echo %%~zA bytes

echo.
echo The executable is completely standalone and includes:
echo - All Python dependencies
echo - PyQt5 GUI framework
echo - Plex API libraries
echo - Spotify/Deezer integration
echo - All required modules
echo.
echo You can distribute this single .exe file to any Windows computer
echo without requiring Python or any dependencies to be installed.
echo.

REM Clean up temporary icon files
if exist "tools\Syncra_v2_Icon.ico" del "tools\Syncra_v2_Icon.ico" 2>nul
if exist "tools\Syncra Icon.ico" del "tools\Syncra Icon.ico" 2>nul

REM Clean up build artifacts (optional)
set /p cleanup="Clean up build files? (y/n): "
if /i "%cleanup%"=="y" (
    echo Cleaning up build artifacts...
    rmdir /s /q "build" 2>nul
    del "tools\Syncra.spec" 2>nul
    echo Build artifacts cleaned up.
)

echo.
echo Press any key to exit...
pause >nul