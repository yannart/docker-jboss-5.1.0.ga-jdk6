The image is based on the official CentOS image "centos:6.7" and available in Docker Hub with the name "yannart/jboss-5.1.0.ga-jdk6".

* JBoss is installed in "/opt/jboss-5.1.0.GA with a symbolic link to /opt/jboss".
* Maven is installed in "/opt/maven".
* Oracle JDK 6 is installed using a rpm from Oracle.
* Git is installed with yum.

Default command runs JBoss bind to IP 0.0.0.0.

Ports 8080 and 8009 are exposed.

This image can be extended to download a project from Git and compile it with Maven, for example:
```
FROM yannart/jboss-5.1.0.ga-jdk6

# Name of the application
ENV APP_NAME myapp

# Version of the application
ENV APP_VERSION 0.0.1-SNAPSHOT

# Git repository
ENV APP_GIT_REPOSITORY https://mygiturl

# Binary name
ENV APP_BIN ${APP_NAME}-${APP_VERSION}.war

# Application installation folder
ENV APP_HOME /opt/jboss/server/default/deploy

RUN git clone ${APP_GIT_REPOSITORY} /tmp/${APP_NAME} \
&& cd /tmp/${APP_NAME} \
&& mvn clean package \
&& mv /tmp/${APP_NAME}/target/${APP_BIN} ${APP_HOME}/${APP_NAME}.war \
&& rm -rf /tmp/* \
&& echo ${APP_NAME} > ${APP_HOME}/VERSION \
&& echo ${APP_VERSION} >> ${APP_HOME}/VERSION \
&& echo ${APP_GIT_COMMIT} >> ${APP_HOME}/VERSION

# Run JBoss
CMD ["/opt/jboss/bin/run.sh", "-b", "0.0.0.0"]

EXPOSE 8080
```
