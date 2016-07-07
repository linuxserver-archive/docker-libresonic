FROM lsiobase/alpine
MAINTAINER sparklyballs

# environment settings
ARG LIBRE_URL="https://github.com/Libresonic/libresonic/releases/download"
ENV LIBRE_HOME="/app/libresonic"
ENV LIBRE_SETTINGS="/var/subsonic"

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	tar && \

# install libresonic
 LIBRE_VER=$(curl -sX GET  "https://api.github.com/repos/Libresonic/libresonic/releases/latest" | \
	awk '/tag_name/{print $4;exit}' FS='[""]') && \
 mkdir -p \
	"${LIBRE_HOME}" && \
 curl -o \
 "${LIBRE_HOME}"/libresonic.war -L \
	"${LIBRE_URL}"/"${LIBRE_VER}"/libresonic-"${LIBRE_VER}".war && \

# cleanup
 apk del \
	build-dependencies && \
 rm -rf \
	/tmp/*

# install runtime packages
RUN \
 apk add --no-cache \
	ffmpeg \
	flac \
	jetty-runner \
	lame

# config
RUN \
 mkdir -p \
	"${LIBRE_SETTINGS}"/transcode && \
 ln -s \
	/usr/bin/ffmpeg "${LIBRE_SETTINGS}"/transcode/ && \
 ln -s \
	/usr/bin/flac "${LIBRE_SETTINGS}"/transcode/ && \
 ln -s \
	/usr/bin/lame "${LIBRE_SETTINGS}"/transcode/


# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /var/subsonic /music /media

