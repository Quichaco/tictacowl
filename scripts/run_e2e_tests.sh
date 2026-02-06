#!/bin/bash
# Run E2E integration tests with Firebase Emulator
# Usage: ./scripts/run_e2e_tests.sh

set -e

echo "Starting Firebase Emulator..."
cd apps/xoapp

# Start emulator in background
firebase emulators:start --only auth,firestore --project tictacowl &
EMULATOR_PID=$!

# Wait for emulator to be ready
echo "Waiting for emulator to start..."
for i in {1..30}; do
  if curl -s http://localhost:9099/ > /dev/null 2>&1; then
    echo "Emulator ready!"
    break
  fi
  sleep 2
done

# Run E2E tests
echo "Running E2E tests..."
flutter test integration_test/auth_e2e_test.dart
TEST_RESULT=$?

# Kill emulator
echo "Stopping Firebase Emulator..."
kill $EMULATOR_PID 2>/dev/null || true

cd ../..
exit $TEST_RESULT
