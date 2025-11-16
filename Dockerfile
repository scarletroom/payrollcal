FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/sdk
ENV PATH=${PATH}:/sdk/cmdline-tools/latest/bin:/sdk/platform-tools:/workspace/node_modules/.bin

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates unzip zip git wget gnupg2 build-essential openjdk-17-jdk-headless \
    python3 python3-pip && rm -rf /var/lib/apt/lists/*

# Install Node 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs && npm --version

# Install Android command-line tools
RUN mkdir -p /tmp/sdk /sdk/cmdline-tools && cd /tmp/sdk \
  && curl -fSL "https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip" -o cmdline.zip \
  && unzip cmdline.zip -d /sdk/cmdline-tools \
  && mv /sdk/cmdline-tools/cmdline-tools /sdk/cmdline-tools/latest \
  && rm -rf /tmp/sdk

RUN yes | /sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true

RUN /sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "platforms;android-33" "build-tools;33.0.2" "cmdline-tools;latest"

WORKDIR /workspace

# Copy project files
COPY . /workspace

RUN npm install --silent || true

ENTRYPOINT ["/bin/bash"]
