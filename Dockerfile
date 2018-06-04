FROM alpine:latest

LABEL maintener="blair.kennedy@csaa.com"

ENV jdk="java-1.8-openjdk"
# Tomcat version to retrieve.
ENV tomcat="apache-tomcat-9.0.8"
ENV tomcat_url="http://apache.mirrors.pair.com/tomcat/tomcat-9/v9.0.8/bin/apache-tomcat-9.0.8.tar.gz"
ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"

# Tools: Java JDK, Maven, and openssl
RUN apk --update add openjdk8 maven git openssl

# Retrieve tomcat runtime
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

# Add Nexus certificate to Java keystore
RUN openssl s_client -connect devnexus.tent.trt.csaa.pri:8443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /tmp/public.crt
RUN keytool -import -alias devnexus -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -file /tmp/public.crt && rm /tmp/public.crt 

EXPOSE 8080

CMD ["/usr/local/tomcat/bin/csaa_start.sh"]