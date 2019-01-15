FROM alpine:3.8 as buildstage

# environment variables
ENV TERM=xterm
ARG LIBRESONIC_RELEASE

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache  \
	bash \
	git \
	maven \
	openjdk8 \
	curl && \
 echo "**** Get Source ****" && \
 if [ -z ${LIBRESONIC_RELEASE+x} ]; then \
	LIBRESONIC_RELEASE=$(curl -sX GET "https://api.github.com/repos/Libresonic/libresonic/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p /usr/src/libresonic && \
 curl -o \
	/tmp/libresonic.tar.gz -L \
	"https://github.com/Libresonic/libresonic/archive/${LIBRESONIC_RELEASE}.tar.gz" && \
 tar xf \
 /tmp/libresonic.tar.gz -C \
	/usr/src/libresonic/ --strip-components=1 && \
 cd /usr/src/libresonic && \
 echo "**** build war file ****" && \
 mvn -q package

# Main Container
FROM lsiobase/java:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# environment settings
ENV LIBRE_HOME="/app/libresonic" \
LIBRE_SETTINGS="/config"

# copy war file
COPY --from=buildstage /usr/src/libresonic/libresonic-main/target/libresonic.war /app/libresonic/

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4040
VOLUME /config /media /music /playlists /podcasts
