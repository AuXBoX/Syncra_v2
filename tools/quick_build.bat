@echo off
echo Quick Build - Syncra Executable
echo ================================

REM Navigate to project root
cd /d "%~dp0.."

REM Check if PyInstaller is available
python -c "import PyInstaller" >nul 2>&1
if errorlevel 1 (
    echo Installing PyInstaller...
    python -m pip install pyinstaller
)

REM Quick build with minimal options
python -m PyInstaller --onefile --windowed --name="Syncra" --icon="Syncra Icon.ico" main.py

if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo Quick build complete!
echo Executable: dist\Syncra.exe
echo.
pause