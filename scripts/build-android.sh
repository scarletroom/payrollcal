#!/usr/bin/env bash
set -euo pipefail

echo "[build] Accepting Android SDK licenses (non-interactive)"
yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true

echo "[build] Preparing web assets into ./www"
rm -rf www
mkdir -p www
cp -R index.html manifest.json service-worker.js icons www/ || true

echo "[build] Installing Node deps"
npm install --silent

if [ ! -d android ]; then
  echo "[build] Initializing Capacitor and adding Android platform"
  npx cap init --appId=com.scarletroom.payrollcal --appName=PayrollCal --web-dir=www --npm-client=npm
  npx cap add android
fi

echo "[build] Copying web assets to native project"
npx cap copy android

echo "[build] Running Gradle assembleDebug (this downloads Gradle via wrapper)"
cd android
chmod +x gradlew || true
./gradlew assembleDebug -Pandroid.injected.testOnly=false

echo "[build] Locating APK and copying to /workspace/android-output"
mkdir -p /workspace/android-output
APK=$(find . -type f -name "*.apk" | head -n1)
if [ -z "$APK" ]; then
  echo "ERROR: APK not found"
  exit 2
fi
cp "$APK" /workspace/android-output/

echo "[build] APK copied to /workspace/android-output/$(basename $APK)"
