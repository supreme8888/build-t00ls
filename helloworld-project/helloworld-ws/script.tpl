cat << EOF > script.sh
CHECKED_GIT_COMMIT=$(cat /usr/local/tomcat/webapps/helloworld-ws/index.html | grep SHA | awk '{print $NF}')
if [ "\${GIT_COMMIT}" -eq "\${CHECKED_GIT_COMMIT}" ]; then
  exit 0
else
  exit 1
fi
EOF