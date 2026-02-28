#!/usr/bin/env bash
set -e
: "${PORT:=10000}"
sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml
exec catalina.sh run