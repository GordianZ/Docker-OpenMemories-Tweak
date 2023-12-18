# SPDX-License-Identifier: MIT
ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION} AS builder

# Install prerequisites
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing \
    openjdk-8-jdk-headless \
    g++-arm-linux-gnueabi \
    sdkmanager \
    git \
    make \
    file \
    unzip

# Install gradle later to avoid openjdk-11-jre dependency
RUN apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing \
    gradle 

# Install SDK and NDK through sdkmanager
ARG NDK_VERSION=r11c
ARG SDK_VERSION=10
ARG BUILD_TOOLS_VERSION=26.0.2
RUN sdkmanager --install \
	"platforms;android-${SDK_VERSION}" \
	"ndk;${NDK_VERSION}" \
	"build-tools;${BUILD_TOOLS_VERSION}" \
	"platform-tools" \
	"emulator" \
	"tools"
RUN echo y | sdkmanager --licenses

# Set env var for gradle
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_NDK_HOME=/opt/android-sdk/ndk/${NDK_VERSION}

COPY build.sh /
RUN chmod +x /build.sh

WORKDIR /Code

ENTRYPOINT ["/build.sh"]
