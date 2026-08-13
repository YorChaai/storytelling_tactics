@echo off
cd ..
echo ==========================================
echo PILIH PLATFORM UNTUK DIJALANKAN
echo ==========================================
echo 1. Windows (Desktop)
echo 2. Web (Browser Chrome)
echo 3. Android (Emulator/Device)
echo ==========================================
set /p platform="Masukkan pilihan Anda (1/2/3): "

if "%platform%"=="1" (
    echo.
    echo Menjalankan di Windows...
    flutter run -d windows
) else if "%platform%"=="2" (
    echo.
    echo Menjalankan di Web...
    flutter run -d chrome
) else if "%platform%"=="3" (
    echo.
    echo Menjalankan di Android...
    flutter run
) else (
    echo.
    echo Pilihan tidak valid!
)

pause
