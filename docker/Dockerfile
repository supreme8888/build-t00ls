FROM tomcat:8.0-jre8

MAINTAINER irinabro85@gmail.com

ENV CATALINA_BASE /usr/local/tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV CATALINA_TMPDIR /usr/local/tomcat/temp
ENV JRE_HOME /usr
ENV CLASSPATH /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar

EXPOSE 8080

RUN apt update && apt install -y openjdk-8-jdk
COPY tomcat-users.xml /tmp/

RUN cp -pf /tmp/tomcat-users.xml /usr/local/tomcat/conf/
COPY helloworld-ws.war /usr/local/tomcat/webapps

ENV JAVA_OPTS="$JAVA_OPTS -Xms256m -Xmx512m -verbose:gc -XX:+PrintGCDetails -Xloggc:/tmp/gc.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/root"
CMD /usr/local/tomcat/bin/catalina.sh run
