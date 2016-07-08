FROM lsiobase/alpine
MAINTAINER sparklyballs

# environment settings
ARG LIBRE_VER="v6.1.beta1"
ARG LIBRE_WWW="https://github.com/Libresonic/libresonic/releases/download"
ENV LIBRE_HOME="/app/libresonic"
ENV LIBRE_SETTINGS="/config"

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	tar && \

# install libresonic
 mkdir -p \
	"${LIBRE_HOME}" && \
 curl -o \
 "${LIBRE_HOME}"/libresonic.war -L \
	"${LIBRE_WWW}"/"${LIBRE_VER}"/libresonic-"${LIBRE_VER}".war && \

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

# ports and volumes
EXPOSE 8080
VOLUME /config /media /music /playlists /podcasts
