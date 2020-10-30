FROM tomcat:8.0-alpine
COPY helloworld-ws.war /usr/local/tomcat/webapps/
COPY check.sh /tmp/
EXPOSE 8080
CMD ["catalina.sh", "run"]