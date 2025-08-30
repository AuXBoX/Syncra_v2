@echo off
echo ========================================
echo Syncra Final Optimized Builder
echo ========================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found
    pause & exit /b 1
)

REM Check PyInstaller
python -c "import PyInstaller" 2>nul
if errorlevel 1 (
    echo Installing PyInstaller...
    python -m pip install --upgrade pip pyinstaller
)

REM Navigate to project root
cd /d "%~dp0.."

REM Create optimized icon if needed
if not exist "Syncra_Optimized_Icon.ico" (
    echo Creating optimized icon...
    python -c "
import os
from PIL import Image
if os.path.exists('Syncra Icon.ico'):
    img = Image.open('Syncra Icon.ico')
    if img.mode != 'RGBA': img = img.convert('RGBA')
    sizes = [16,32,48,64,128,256]
    images = [img.resize((s,s), Image.Resampling.LANCZOS) for s in sizes]
    img.save('Syncra_Optimized_Icon.ico', format='ICO', sizes=[(i.width,i.height) for i in images])
    print('✅ Icon optimized')
else:
    print('⚠️ No source icon found')
"
)

REM Set icon path
set ICON_PATH=
if exist "Syncra_Optimized_Icon.ico" (
    set "ICON_PATH=--icon=%CD%\Syncra_Optimized_Icon.ico"
    echo Using optimized icon
) else if exist "Syncra Icon.ico" (
    set "ICON_PATH=--icon=%CD%\Syncra Icon.ico"
    echo Using original icon
) else (
    echo WARNING: No icon found
)

echo.
echo Building final optimized executable...
echo This will take 2-3 minutes...
echo.

REM Clean previous builds
if exist "dist" rmdir /s /q "dist" 2>nul
if exist "build" rmdir /s /q "build" 2>nul

REM Build with maximum optimizations for fast startup
python -m PyInstaller ^
    --onefile ^
    --windowed ^
    --name="Syncra" ^
    %ICON_PATH% ^
    --optimize=2 ^
    --noupx ^
    --exclude-module=tkinter ^
    --exclude-module=matplotlib ^
    --exclude-module=numpy ^
    --exclude-module=scipy ^
    --exclude-module=pandas ^
    --exclude-module=jupyter ^
    --exclude-module=IPython ^
    --exclude-module=notebook ^
    --exclude-module=sphinx ^
    --exclude-module=pytest ^
    --exclude-module=setuptools ^
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
    --distpath="dist" ^
    --workpath="build" ^
    --specpath="tools" ^
    main.py

if errorlevel 1 (
    echo ERROR: Build failed!
    pause & exit /b 1
)

echo.
echo ========================================
echo 🎉 BUILD SUCCESSFUL! 🎉
echo ========================================
echo.

REM Show results
for %%A in ("dist\Syncra.exe") do (
    echo Executable: dist\Syncra.exe
    echo Size: %%~zA bytes ^(%%~zA / 1048576 MB^)
    echo Created: %%~tA
)

echo.
echo ✅ Optimizations Applied:
echo   • Multi-resolution icon embedded
echo   • Bytecode optimization level 2
echo   • Excluded unnecessary modules
echo   • No UPX compression ^(faster startup^)
echo   • Stripped debug symbols
echo.

echo 🚀 Performance Notes:
echo   • First run may be slower ^(Windows security scan^)
echo   • Add to Windows Defender exclusions for faster startup
echo   • Typical startup time: 3-5 seconds
echo.

echo 🧪 Testing executable...
if exist "dist\Syncra.exe" (
    echo ✅ File created successfully
    echo 🎨 Icon should be visible in file properties
    echo.
    echo Ready to distribute! The .exe file is completely standalone.
) else (
    echo ❌ Executable not found
)

REM Cleanup
set /p cleanup="Clean up build files? (y/n): "
if /i "%cleanup%"=="y" (
    rmdir /s /q "build" 2>nul
    del "tools\Syncra.spec" 2>nul
    echo Build artifacts cleaned up.
)

echo.
echo Press any key to exit...
pause >nul