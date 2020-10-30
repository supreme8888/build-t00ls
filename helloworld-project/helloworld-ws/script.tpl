if [ ${GIT_COMMIT} = $(cat /usr/local/tomcat/webapps/helloworld-ws/index.html | grep SHA | awk '{print $NF}') ]; then
  exit 0
else
  exit 1
fi