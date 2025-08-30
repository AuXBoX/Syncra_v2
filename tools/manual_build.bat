@echo off
echo ========================================
echo Syncra Manual Build (Step by Step)
echo ========================================
echo.
echo This script will show you each step of the build process
echo so you can identify where any issues occur.
echo.

REM Navigate to project root
cd /d "%~dp0.."

echo Step 1: Checking Python...
python --version
if errorlevel 1 (
    echo ERROR: Python not found
    pause
    exit /b 1
)

echo.
echo Step 2: Installing/Upgrading pip...
python -m pip install --upgrade pip

echo.
echo Step 3: Installing PyInstaller...
python -m pip install pyinstaller

echo.
echo Step 4: Verifying PyInstaller...
python -m PyInstaller --version

echo.
echo Step 5: Installing project dependencies...
python -m pip install -r requirements.txt

echo.
echo Step 6: Running PyInstaller build...
echo Command that will be executed:
echo python -m PyInstaller --onefile --windowed --name="Syncra" --icon="Syncra Icon.ico" main.py
echo.
pause

python -m PyInstaller ^
    --onefile ^
    --windowed ^
    --name="Syncra" ^
    --icon="Syncra Icon.ico" ^

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
    --collect-all=PyQt5 ^
    --collect-all=plexapi ^
    --collect-all=spotipy ^
    --collect-all=fuzzywuzzy ^
    --collect-all=requests ^
    main.py

if errorlevel 1 (
    echo.
    echo BUILD FAILED!
    echo Check the error messages above.
    echo.
    echo Common solutions:
    echo 1. Make sure all dependencies are installed: python -m pip install -r requirements.txt
    echo 2. Try updating PyInstaller: python -m pip install --upgrade pyinstaller
    echo 3. Check that you have enough disk space (need ~2GB free)
    echo 4. Try running as administrator
    echo.
) else (
    echo.
    echo BUILD SUCCESSFUL!
    echo Executable created at: dist\Syncra.exe
    echo.
    if exist "dist\Syncra.exe" (
        for %%A in ("dist\Syncra.exe") do echo File size: %%~zA bytes
    )
)

pause