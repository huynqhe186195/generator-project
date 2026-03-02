#!/usr/bin/env bash
set -e

: "${PORT:=10000}"

# 1) Set HTTP connector port to Render's PORT
sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml

# 2) Disable Tomcat shutdown port to avoid "Invalid shutdown command [HEAD / HTTP/1.1]"
# default: <Server port="8005" shutdown="SHUTDOWN">
sed -i 's/<Server port="8005" shutdown="SHUTDOWN">/<Server port="-1" shutdown="SHUTDOWN">/g' /usr/local/tomcat/conf/server.xml

exec catalina.sh run