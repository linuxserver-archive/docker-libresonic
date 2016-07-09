FROM lsiobase/xenial
MAINTAINER sparklyballs

# copy prebuild files
COPY prebuilds/ /prebuilds/

# package version settings
ARG JETTY_VER="9.3.10.v20160621"
ARG LIBRE_VER="v6.1.beta1"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ARG JETTY_NAME=jetty-runner
ARG JETTY_SRC="/tmp/jetty"
ARG JETTY_URL="https://repo.maven.apache.org/maven2/org/eclipse/jetty"
ARG JETTY_WWW="${JETTY_URL}"/"${JETTY_NAME}"/"${JETTY_VER}"/"${JETTY_NAME}"-"{$JETTY_VER}".jar
ARG LIBRE_URL="https://github.com/Libresonic/libresonic/releases/download"
ARG LIBRE_WWW="${LIBRE_URL}"/"${LIBRE_VER}"/libresonic-"${LIBRE_VER}".war
ENV LIBRE_HOME="/app/libresonic"
ENV LIBRE_SETTINGS="/config"

# install packages
RUN \
 apt-get update && \
 apt-get install -y \
	--no-install-recommends \
	ffmpeg \
	flac \
	lame \
	openjdk-8-jdk && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# install jetty-runner
RUN \
 mkdir -p \
	"${JETTY_SRC}" && \
 cp /prebuilds/* "${JETTY_SRC}"/ && \
 curl -o \
 "${JETTY_SRC}"/"$JETTY_NAME-$JETTY_VER".jar -L \
	"${JETTY_WWW}" && \
 cd "${JETTY_SRC}" && \
 install -m644 -D "$JETTY_NAME-$JETTY_VER.jar" \
	"/usr/share/java/$JETTY_NAME.jar" || return 1 && \
 install -m755 -D $JETTY_NAME "/usr/bin/$JETTY_NAME" && \
 rm -rf \
	/tmp/*

# install libresonic
RUN \
  mkdir -p \
	"${LIBRE_HOME}" && \
 curl -o \
 "${LIBRE_HOME}"/libresonic.war -L \
	"${LIBRE_WWW}"

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4040
VOLUME /config /media /music /playlists /podcasts
