# payrollcal

Containerized Android build
---------------------------

To build an Android APK inside a Docker container (the container installs Android SDK command-line tools and Node):

1. Build the container image (may download several hundred MBs):

```bash
docker build -t payrollcal-android .
```

2. Run the container and execute the build script. This mounts an output directory on the host to collect the APK:

```bash
# create output dir on host
mkdir -p android-output
# run the build (this may take several minutes)
docker run --rm -v "$PWD":/workspace -v "$PWD"/android-output:/workspace/android-output payrollcal-android \
  /bin/bash -lc "scripts/build-android.sh"
```

3. After completion, the debug APK will be in `android-output/` on the host.

Notes:
- Building requires downloading Android SDK/platforms/build-tools and Gradle — expect several minutes and a few GB of downloads on first run.
- For production builds (release), you'll need to configure signing in the Android Gradle config and set appropriate build commands.
# payrollcal