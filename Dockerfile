FROM tomcat:8.0
COPY helloworld-project/helloworld-ws/target/helloworld-ws.war /usr/local/tomcat/webapps/
EXPOSE 8080
ENTRYPOINT ["catalina.sh", "run"]
