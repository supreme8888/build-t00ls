FROM tomcat:9.0
COPY helloworld-project/helloworld-ws/target/helloworld-ws.war /usr/local/tomcat/webapps/
