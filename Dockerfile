FROM alpine:latest

LABEL maintener="blair.kennedy@csaa.com"

ENV jdk="java-1.8-openjdk"
# Tomcat version to retrieve.
ENV tomcat="apache-tomcat-8.5.31"
ENV tomcat_url="http://mirror.olnevhost.net/pub/apache/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz"
ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"

RUN apk --update add openjdk8

# Retrieve tomcat
RUN wget $tomcat_url -S -P /tmp/ 

# Extract the tarball to /usr/local
RUN tar -zxvf /tmp/$tomcat.tar.gz -C /usr/local/ && mv /usr/local/$tomcat /usr/local/tomcat

####
#### Fixup tomcat for local development
####

# Allow IP addresses from 192.168.*.* to use Manager
# setup /usr/local/tomcat/webapps/manager/META-INF/context.xml
COPY config/manager/context.xml /usr/local/tomcat/webapps/manager/META-INF/

# setup tomcat-users.xml file to allow access to manager
COPY config/tomcat/tomcat-users.xml /usr/local/tomcat/conf/

# setup a wrapper to start tomat and to push catalina.out to stdout to keep the container running.
COPY config/tomcat/csaa_start.sh /usr/local/tomcat/bin/ 
RUN chmod +x /usr/local/tomcat/bin/csaa_start.sh

EXPOSE 8080

CMD ["/usr/local/tomcat/bin/csaa_start.sh"]