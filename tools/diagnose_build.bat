@echo off
echo ========================================
echo Syncra Build Environment Diagnostics
echo ========================================
echo.

REM Check Python installation
echo 1. Checking Python installation...
python --version 2>nul
if errorlevel 1 (
    echo ❌ Python is not installed or not in PATH
    echo Please install Python from https://python.org
    echo Make sure to check "Add Python to PATH" during installation
    goto :end
) else (
    echo ✅ Python is installed
)

REM Check pip
echo.
echo 2. Checking pip...
python -m pip --version 2>nul
if errorlevel 1 (
    echo ❌ pip is not available
    echo Try reinstalling Python with pip included
    goto :end
) else (
    echo ✅ pip is available
)

REM Check PyInstaller
echo.
echo 3. Checking PyInstaller...
python -c "import PyInstaller; print('PyInstaller version:', PyInstaller.__version__)" 2>nul
if errorlevel 1 (
    echo ❌ PyInstaller is not installed
    echo Installing PyInstaller now...
    python -m pip install pyinstaller
    if errorlevel 1 (
        echo ❌ Failed to install PyInstaller
        echo Try running: python -m pip install --user pyinstaller
        goto :end
    ) else (
        echo ✅ PyInstaller installed successfully
    )
) else (
    echo ✅ PyInstaller is installed
)

REM Check PyInstaller command access
echo.
echo 4. Checking PyInstaller command access...
python -m PyInstaller --version 2>nul
if errorlevel 1 (
    echo ❌ PyInstaller command not accessible
    echo This is unusual - PyInstaller is installed but can't be run
    goto :end
) else (
    echo ✅ PyInstaller command is accessible
)

REM Check project structure
echo.
echo 5. Checking project structure...
cd /d "%~dp0.."
if not exist "main.py" (
    echo ❌ main.py not found in project root
    echo Make sure you're running this from the tools folder
    goto :end
) else (
    echo ✅ main.py found
)

if not exist "requirements.txt" (
    echo ⚠️  requirements.txt not found
    echo This is optional but recommended
) else (
    echo ✅ requirements.txt found
)

if not exist "Syncra Icon.ico" (
    echo ⚠️  Syncra Icon.ico not found
    echo Build will work but without icon
) else (
    echo ✅ Syncra Icon.ico found
)

REM Check dependencies
echo.
echo 6. Checking Python dependencies...
set DEPS=PyQt5 plexapi spotipy fuzzywuzzy requests

for %%d in (%DEPS%) do (
    python -c "import %%d" 2>nul
    if errorlevel 1 (
        echo ❌ %%d not installed
        set MISSING_DEPS=1
    ) else (
        echo ✅ %%d installed
    )
)

if defined MISSING_DEPS (
    echo.
    echo Some dependencies are missing. Installing...
    python -m pip install -r requirements.txt
)

REM Test basic PyInstaller functionality
echo.
echo 7. Testing PyInstaller with simple script...
echo print("Hello World") > test_script.py
python -m PyInstaller --onefile --distpath=test_dist test_script.py >nul 2>&1
if errorlevel 1 (
    echo ❌ PyInstaller test failed
    echo There may be an issue with your PyInstaller installation
) else (
    echo ✅ PyInstaller test successful
    rmdir /s /q test_dist 2>nul
    rmdir /s /q build 2>nul
    del test_script.spec 2>nul
)
del test_script.py 2>nul

echo.
echo ========================================
echo Diagnostics Complete
echo ========================================
echo.
echo If all checks passed, try running build_exe.bat again.
echo If issues persist, try:
echo 1. python -m pip install --upgrade pyinstaller
echo 2. python -m pip install --user pyinstaller
echo 3. Restart your command prompt
echo.

:end
pause