#!/usr/bin/env bash
set -e

: "${PORT:=10000}"

# 1) Set HTTP connector port to Render's PORT
sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml

# 2) Disable Tomcat shutdown port to avoid "Invalid shutdown command [HEAD / HTTP/1.1]"
# default: <Server port="8005" shutdown="SHUTDOWN">
sed -i 's/<Server port="8005" shutdown="SHUTDOWN">/<Server port="-1" shutdown="SHUTDOWN">/g' /usr/local/tomcat/conf/server.xml

# 3) Server-level Gemini key config: inject into web.xml context-param when env is provided
if [ -f /usr/local/tomcat/webapps/ROOT.war ] && [ ! -d /usr/local/tomcat/webapps/ROOT ]; then
  mkdir -p /usr/local/tomcat/webapps/ROOT
  (cd /usr/local/tomcat/webapps/ROOT && jar -xf ../ROOT.war)
fi

if [ -f /usr/local/tomcat/webapps/ROOT/WEB-INF/web.xml ]; then
  if [ -n "${GEMINI_API_KEY:-}" ]; then
    escaped_key=$(printf '%s' "$GEMINI_API_KEY" | sed 's/[&/]/\\&/g')
    sed -i "s|__GEMINI_API_KEY__|${escaped_key}|g" /usr/local/tomcat/webapps/ROOT/WEB-INF/web.xml
  else
    sed -i 's|__GEMINI_API_KEY__||g' /usr/local/tomcat/webapps/ROOT/WEB-INF/web.xml
  fi
fi

exec catalina.sh run
