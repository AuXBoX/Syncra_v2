@echo off
echo ========================================
echo Syncra Optimized Executable Builder
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
    python -m pip install --upgrade pip
    python -m pip install pyinstaller
    if errorlevel 1 (
        echo ERROR: Failed to install PyInstaller
        pause
        exit /b 1
    )
) else (
    echo PyInstaller is already installed.
)

REM Navigate to project root
cd /d "%~dp0.."

REM Check if main.py exists
if not exist "main.py" (
    echo ERROR: main.py not found in project root
    pause
    exit /b 1
)

REM Prepare icon - use absolute path to avoid issues
set ICON_FILE=
if exist "Syncra_Optimized_Icon.ico" (
    echo Using optimized multi-resolution icon
    set ICON_FILE=%CD%\Syncra_Optimized_Icon.ico
) else if exist "Syncra_v2_Icon.ico" (
    echo Using Syncra v2 icon
    set ICON_FILE=%CD%\Syncra_v2_Icon.ico
) else if exist "Syncra Icon.ico" (
    echo Using original Syncra icon  
    set ICON_FILE=%CD%\Syncra Icon.ico
) else (
    echo WARNING: No icon file found
)

echo Building optimized standalone executable...
echo This may take several minutes...
echo.

REM Clean previous builds
if exist "dist" rmdir /s /q "dist" 2>nul
if exist "build" rmdir /s /q "build" 2>nul

REM Build with optimizations for faster startup
if defined ICON_FILE (
    python -m PyInstaller ^
        --onefile ^
        --windowed ^
        --name="Syncra" ^
        --icon="%ICON_FILE%" ^
        --optimize=2 ^
        --strip ^
        --noupx ^
        --exclude-module=tkinter ^
        --exclude-module=matplotlib ^
        --exclude-module=numpy ^
        --exclude-module=scipy ^
        --exclude-module=pandas ^
        --exclude-module=jupyter ^
        --exclude-module=IPython ^
        --exclude-module=notebook ^
        --hidden-import=PyQt5.QtCore ^
        --hidden-import=PyQt5.QtGui ^
        --hidden-import=PyQt5.QtWidgets ^
        --hidden-import=plexapi ^
        --hidden-import=spotipy ^
        --hidden-import=requests ^
        --hidden-import=fuzzywuzzy ^
        --hidden-import=pyotp ^
        --hidden-import=PIL ^
        --collect-submodules=PyQt5 ^
        --collect-submodules=plexapi ^
        --add-data="%CD%\syncra_v2_logo.svg;." ^
        --distpath="dist" ^
        --workpath="build" ^
        --specpath="tools" ^
        main.py
) else (
    python -m PyInstaller ^
        --onefile ^
        --windowed ^
        --name="Syncra" ^
        --optimize=2 ^
        --strip ^
        --noupx ^
        --exclude-module=tkinter ^
        --exclude-module=matplotlib ^
        --exclude-module=numpy ^
        --exclude-module=scipy ^
        --exclude-module=pandas ^
        --exclude-module=jupyter ^
        --exclude-module=IPython ^
        --exclude-module=notebook ^
        --hidden-import=PyQt5.QtCore ^
        --hidden-import=PyQt5.QtGui ^
        --hidden-import=PyQt5.QtWidgets ^
        --hidden-import=plexapi ^
        --hidden-import=spotipy ^
        --hidden-import=requests ^
        --hidden-import=fuzzywuzzy ^
        --hidden-import=pyotp ^
        --hidden-import=PIL ^
        --collect-submodules=PyQt5 ^
        --collect-submodules=plexapi ^
        --add-data="%CD%\syncra_v2_logo.svg;." ^
        --distpath="dist" ^
        --workpath="build" ^
        --specpath="tools" ^
        main.py
)

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Optimized Build Complete!
echo ========================================
echo.
echo Executable: dist\Syncra.exe
for %%A in ("dist\Syncra.exe") do echo Size: %%~zA bytes (%%~zA bytes / 1048576 = %%~zA MB)

echo.
echo Optimizations applied:
echo - Python bytecode optimization level 2
echo - Stripped debug symbols
echo - Excluded unnecessary modules (tkinter, matplotlib, etc.)
echo - Disabled UPX compression (faster startup)
echo - Used absolute icon path
echo.

REM Test the executable
echo Testing executable...
if exist "dist\Syncra.exe" (
    echo ✅ Executable created successfully
    echo.
    echo To test startup time, run: dist\Syncra.exe
) else (
    echo ❌ Executable not found
)

echo.
set /p cleanup="Clean up build files? (y/n): "
if /i "%cleanup%"=="y" (
    echo Cleaning up...
    rmdir /s /q "build" 2>nul
    del "tools\Syncra.spec" 2>nul
    echo Build artifacts cleaned up.
)

echo.
echo Press any key to exit...
pause >nul