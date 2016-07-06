FROM lsiobase/alpine
MAINTAINER sparklyballs


# environment settings
ENV CATALINA_HOME="/app/tomcat"
ARG TOMCAT_VERSION_MAJOR="8"
ARG TOMCAT_VERSION_FULL="8.5.3"

# install runtime packages
RUN \
 apk add --no-cache \
	openjdk8

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	tar && \

# install tomcat
mkdir -p /app/tomcat && \
  curl -o \
 /tmp/tomcat.tar.gz -L \
	https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz &&\
 tar xf /tmp/tomcat.tar.gz -C \
	/app/tomcat --strip-components=1 && \
 ln -s \
	/app/apache-tomcat-${TOMCAT_VERSION_FULL} /app/tomcat && \

# install libresonic
curl -o \
 /app/tomcat/webapps/libresonic.war -L \
	https://github.com/Libresonic/libresonic/releases/download/v6.0.1/libresonic-v6.0.1.war && \

# cleanup
 apk del \
	build-dependencies && \
 rm -rf \
	/tmp/*

# Configuration
ADD tomcat-users.xml /app/tomcat/conf/
RUN sed -i 's/52428800/5242880000/g' /app/tomcat/webapps/manager/WEB-INF/web.xml

# add local files
COPY root/ /
