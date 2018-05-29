#!/bin/sh

# Custom Tomcat startup
# Uses default startup.sh and tails catalina.out so that docker container will remain running. 
#
set +x

/usr/local/tomcat/bin/startup.sh
sleep 5
tail -f /usr/local/tomcat/logs/catalina.out