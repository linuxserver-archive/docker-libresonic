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

# add local files
COPY root/ /

# ports and volumes, for LIBRE_SETTINGS see top of dockerfile
EXPOSE 8080
VOLUME "${LIBRE_SETTINGS}" /podcasts /media /music

