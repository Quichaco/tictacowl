@echo off
REM Run E2E integration tests with Firebase Emulator
REM Usage: scripts\run_e2e_tests.bat

echo Starting Firebase Emulator...
cd apps\xoapp

REM Start emulator in background
start /B firebase emulators:start --only auth,firestore --project tictacowl > emulator.log 2>&1

REM Wait for emulator to be ready (check port 9099)
echo Waiting for emulator to start...
:waitloop
timeout /t 2 /nobreak > nul
netstat -an | findstr ":9099.*LISTENING" > nul
if errorlevel 1 goto waitloop
echo Emulator ready!

REM Run E2E tests
echo Running E2E tests...
flutter test integration_test/auth_e2e_test.dart
set TEST_RESULT=%errorlevel%

REM Kill emulator
echo Stopping Firebase Emulator...
taskkill /F /IM java.exe > nul 2>&1

REM Return test result
cd ..\..
exit /b %TEST_RESULT%
