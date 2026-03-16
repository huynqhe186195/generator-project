#!/usr/bin/env bash
set -e

: "${PORT:=10000}"
: "${GEMINI_MODEL:=gemini-2.5-flash}"

# 1) Set HTTP connector port to Render's PORT
sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml

# 2) Disable Tomcat shutdown port to avoid "Invalid shutdown command [HEAD / HTTP/1.1]"
# default: <Server port="8005" shutdown="SHUTDOWN">
sed -i 's/<Server port="8005" shutdown="SHUTDOWN">/<Server port="-1" shutdown="SHUTDOWN">/g' /usr/local/tomcat/conf/server.xml

# 3) Write sensitive Gemini config to application.properties at server-level
CONFIG_FILE="/usr/local/tomcat/conf/application.properties"
{
  echo "gemini.model=${GEMINI_MODEL}"
  echo "gemini.api.key=${GEMINI_API_KEY:-}"
} > "$CONFIG_FILE"

# ensure app can locate config file
export APP_CONFIG_FILE="$CONFIG_FILE"

exec catalina.sh run
