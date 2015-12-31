FROM centos:6.7

MAINTAINER yannart@gmail.com


# Update OS and install required packages
##########################################
RUN yum -y update \
&& yum -y install git tar unzip wget \
&& yum clean all
 

# Install JAVA Oracle JDK 6u45
##########################################
RUN cd /tmp \
&& wget --continue --no-check-certificate --header "Cookie: oraclelicense=a" -O jdk-linux-x64.rpm.bin "http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64-rpm.bin" \
&& sh jdk-linux-x64.rpm.bin \
&& rm -rf /tmp/*
ENV JAVA_HOME /usr/java/default


# Install JBoss 5.1.0.GA
##########################################
RUN wget -O jboss.zip http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA-jdk6.zip/download \
&& unzip jboss.zip \
&& mv jboss-5.1.0.GA /opt \
&& rm jboss.zip \
&& ln -s /opt/jboss-5.1.0.GA /opt/jboss \
&& cd /opt/jboss-5.1.0.GA/bin \
&& chmod +x *.sh
ENV JBOSS_HOME /opt/jboss


# Install Maven
##########################################
# Maven version. 3.2.5 is last version compatible with Java 6, see https://maven.apache.org/docs/history.html)
ENV MVN_VERSION 3.2.5
RUN cd /tmp \
&& wget http://www.eu.apache.org/dist/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz \
&& cd /opt \
&& tar -xzf /tmp/apache-maven-${MVN_VERSION}-bin.tar.gz \
&& mv apache-maven-${MVN_VERSION} maven \
&& ln -s /opt/maven/bin/mvn /usr/local/bin \
&& rm -rf /tmp/*
ENV M2_HOME /opt/maven


# Run JBoss
##########################################
CMD ["/opt/jboss/bin/run.sh", "-b", "0.0.0.0"]

EXPOSE 8080
EXPOSE 8009
