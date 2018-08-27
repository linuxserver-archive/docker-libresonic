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
COPY package/ /app/libresonic/

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4040
VOLUME /config /media /music /playlists /podcasts
