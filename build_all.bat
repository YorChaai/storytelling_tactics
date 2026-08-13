@echo off
echo ==========================================
echo MEMBANGUN APLIKASI WINDOWS (.exe)
echo ==========================================
flutter build windows
echo.

echo ==========================================
echo MEMBANGUN APLIKASI ANDROID (.apk)
echo ==========================================
flutter build apk --release
echo.

echo ==========================================
echo PROSES BUILD SELESAI!
echo ==========================================
echo File Windows (.exe) tersimpan di:
echo build\windows\x64\runner\Release\
echo.
echo File Android (.apk) tersimpan di:
echo build\app\outputs\flutter-apk\app-release.apk
echo ==========================================
pause
