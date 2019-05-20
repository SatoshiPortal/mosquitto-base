FROM alpine:3.8

# Ref.: https://github.com/eclipse/mosquitto/blob/master/docker/generic/Dockerfile

# A released dist version, like "1.2.3"
ARG VERSION="1.6.2"

RUN apk --no-cache add \
      build-base \
      libressl-dev \
      c-ares-dev \
      curl \
      util-linux-dev \
      libwebsockets-dev \
      libxslt \
      python2

# This build procedure is based on:
# https://github.com/alpinelinux/aports/blob/master/main/mosquitto/APKBUILD
#
# If this step fails, double check the version build-arg and make sure its
# a valid published tarball at https://mosquitto.org/files/source/
RUN mkdir -p /build /install && \
    curl -SL https://mosquitto.org/files/source/mosquitto-${VERSION}.tar.gz \
      | tar --strip=1 -xzC /build && \
    make -C /build \
      WITH_MEMORY_TRACKING=no \
      WITH_WEBSOCKETS=yes \
      WITH_SRV=no \
      WITH_TLS_PSK=no \
      WITH_ADNS=no \
      prefix=/usr \
      binary && \
    make -C /build \
      prefix=/usr \
      DESTDIR="/install" \
      install
