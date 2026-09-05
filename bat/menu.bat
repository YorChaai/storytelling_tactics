@echo off
cd /d "%~dp0.."
title Storyteller Tactics - Control Center

:MENU
cls
echo ========================================================
echo            STORYTELLER TACTICS - CONTROL CENTER
echo ========================================================
echo.
echo  --- [ JALANKAN APLIKASI / RUN ] ---
echo  [1] Jalankan di Windows Desktop (Rekomendasi)
echo  [2] Jalankan di Web (Google Chrome)
echo  [3] Pasang ke HP Android via USB (Mode Release / Mandiri)
echo.
echo  --- [ BUILD / RELEASE ] ---
echo  [4] Build Windows (.exe Release)
echo  [5] Build Android APK (.apk Release)
echo  [6] Build Web Production
echo  [7] Build SEMUA (Windows .exe + Android .apk)
echo.
echo  --- [ PERAWATAN DAN PENGEMBANGAN ] ---
echo  [8] Flutter Clean dan Pub Get (Atasi Error Cache / Build)
echo  [9] Cek Kode dan Jalankan Unit Test (Analyze dan Test)
echo  [10] Cek Daftar Perangkat Terdeteksi (Flutter Devices)
echo  [11] Git Push / Simpan Perubahan ke Repository
echo.
echo  [0] Keluar
echo ========================================================
set "opt="
set /p opt="Pilih menu [0-11]: "

if not defined opt goto MENU
if "%opt%"=="1" goto RUN_WIN
if "%opt%"=="2" goto RUN_WEB
if "%opt%"=="3" goto RUN_ANDROID
if "%opt%"=="4" goto BUILD_WIN
if "%opt%"=="5" goto BUILD_APK
if "%opt%"=="6" goto BUILD_WEB
if "%opt%"=="7" goto BUILD_ALL
if "%opt%"=="8" goto CLEAN_PUB
if "%opt%"=="9" goto ANALYZE_TEST
if "%opt%"=="10" goto CHECK_DEVICES
if "%opt%"=="11" goto GIT_UPDATE
if "%opt%"=="0" exit
goto MENU

:RUN_WIN
cls
echo ========================================================
echo       MENJALANKAN DI WINDOWS DESKTOP
echo ========================================================
echo.
call flutter run -d windows
echo.
pause
goto MENU

:RUN_WEB
cls
echo ========================================================
echo       MENJALANKAN DI GOOGLE CHROME (WEB)
echo ========================================================
echo.
call flutter run -d chrome
echo.
pause
goto MENU

:RUN_ANDROID
cls
echo ========================================================
echo       PASANG KE HP ANDROID (MODE RELEASE / MANDIRI)
echo ========================================================
echo.
echo [1/2] Mendeteksi perangkat Android yang terhubung...
echo --------------------------------------------------------
set "DEVICE_ID="
for /f "tokens=1" %%i in ('adb devices 2^>nul ^| findstr /r /c:"[a-zA-Z0-9].*device$"') do (
    set "DEVICE_ID=%%i"
)

if not defined DEVICE_ID goto RUN_ANDROID_AUTO

echo HP Terdeteksi: %DEVICE_ID%
echo --------------------------------------------------------
echo [2/2] Memasang dan menjalankan aplikasi ke %DEVICE_ID% (Mode Release)...
call flutter run --release -d %DEVICE_ID%
goto RUN_ANDROID_DONE

:RUN_ANDROID_AUTO
echo Tidak ada HP spesifik via ADB. Mencoba deteksi otomatis Flutter...
call flutter run --release -d android
goto RUN_ANDROID_DONE

:RUN_ANDROID_DONE
echo.
echo --------------------------------------------------------
echo Proses selesai.
echo --------------------------------------------------------
pause
goto MENU

:BUILD_WIN
cls
echo ========================================================
echo       MEMBANGUN APLIKASI WINDOWS (.exe)
echo ========================================================
echo.
call flutter build windows
echo.
echo File Windows (.exe) tersimpan di:
echo build\windows\x64\runner\Release\
echo.
pause
goto MENU

:BUILD_APK
cls
echo ========================================================
echo       MEMBANGUN FILE APK ANDROID (.apk)
echo ========================================================
echo.
call flutter build apk --release
echo.
echo File APK tersimpan di:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
pause
goto MENU

:BUILD_WEB
cls
echo ========================================================
echo       MEMBANGUN APLIKASI WEB
echo ========================================================
echo.
call flutter build web --release
echo.
echo File Web tersimpan di:
echo build\web\
echo.
pause
goto MENU

:BUILD_ALL
cls
echo ========================================================
echo       MEMBANGUN SEMUA (WINDOWS + ANDROID)
echo ========================================================
echo.
call "%~dp0build_all.bat"
goto MENU

:CLEAN_PUB
cls
echo ========================================================
echo       BERSIHKAN CACHE DAN DOWNLOAD DEPENDENCIES
echo ========================================================
echo.
echo [1/2] Membersihkan cache build (flutter clean)...
call flutter clean
echo.
echo [2/2] Mengunduh dependencies (flutter pub get)...
call flutter pub get
echo.
echo Selesai! Cache telah dibersihkan.
echo.
pause
goto MENU

:ANALYZE_TEST
cls
echo ========================================================
echo       CEK KODE (ANALYZE) DAN RUN UNIT TEST
echo ========================================================
echo.
echo [1/2] Menganalisis kode Dart (flutter analyze)...
call flutter analyze
echo.
echo [2/2] Menjalankan automated test (flutter test)...
call flutter test
echo.
pause
goto MENU

:CHECK_DEVICES
cls
echo ========================================================
echo       DAFTAR PERANGKAT TERDETEKSI
echo ========================================================
echo.
call flutter devices
echo.
pause
goto MENU

:GIT_UPDATE
cls
echo ========================================================
echo       UPDATE / PUSH KE GIT REPOSITORY
echo ========================================================
echo.
call "%~dp0git_update.bat"
goto MENU
