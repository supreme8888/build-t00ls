#!/bin/sh
ourVer=${NBUILD}
Ver=$(cat /usr/local/tomcat/webapps/helloworld-ws/index.html | grep ver | awk -F "ver:" {'print $2'} | awk -F "<" {'print $1'} | sed '/^$/d')
if [ "$Ver" -eq "$ourVer" ]; then
  exit 0
else
  exit 1
fi
EOF
