FROM lsiobase/alpine
MAINTAINER sparklyballs

# environment settings
ARG LIBRE_URL="https://github.com/Libresonic/libresonic/releases/download"
ENV CATALINA_HOME="/app/libresonic"

# install runtime packages
RUN \
 apk add --no-cache \
	ffmpeg \
	flac \
	jetty-runner

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	tar && \

# install tomcat
 mkdir -p \
	"${CATALINA_HOME}" && \

# install libresonic
 LIBRE_VER=$(curl -sX GET  "https://api.github.com/repos/Libresonic/libresonic/releases/latest" | \
	awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o \
 "${CATALINA_HOME}"/libresonic.war -L \
	"${LIBRE_URL}"/"${LIBRE_VER}"/libresonic-"${LIBRE_VER}".war && \

# cleanup
 apk del \
	build-dependencies && \
 rm -rf \
	/tmp/*

# config
RUN \
 mkdir -p \
	/var/subsonic/transcode && \
 ln -s \
	/usr/bin/ffmpeg /var/subsonic/transcode/ && \
 ln -s \
	/usr/bin/flac /var/subsonic/transcode/ && \
 ln -s \
	/usr/bin/lame /var/subsonic/transcode/


# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config /music
