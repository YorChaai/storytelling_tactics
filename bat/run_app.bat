@echo off
cd /d "%~dp0.."
echo ==========================================
echo STORYTELLER TACTICS - PILIH PLATFORM
echo ==========================================
echo 1. Windows (Desktop)
echo 2. Web (Browser Chrome)
echo 3. Android (Emulator/Device)
echo ==========================================
set "platform="
set /p platform="Masukkan pilihan Anda (1/2/3): "

if "%platform%"=="1" goto RUN_WIN
if "%platform%"=="2" goto RUN_WEB
if "%platform%"=="3" goto RUN_ANDROID
echo.
echo Pilihan tidak valid!
goto END

:RUN_WIN
echo.
echo Menjalankan di Windows...
call flutter run -d windows
goto END

:RUN_WEB
echo.
echo Menjalankan di Web...
call flutter run -d chrome
goto END

:RUN_ANDROID
echo.
echo Menjalankan di Android...
call flutter run
goto END

:END
echo.
pause
