FROM lsiobase/alpine

COPY build.sh /build.sh

RUN \
apk add --no-cache --virtual=build-dependencies \
curl \
wget \
tar && \

/bin/bash /build.sh && \

apk del --purge \
build-dependencies

RUN \
 apk add --no-cache \
	ffmpeg \
	lame \
	flac
