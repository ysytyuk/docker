FROM davidcaste/alpine-tomcat:jdk8tomcat8

ENV MAVEN_VERSION="3.5.0" \
    M2_HOME=/usr/lib/mvn

COPY settings.xml /root/.m2/

RUN apk update && apk upgrade && \
    apk add git && \
    mkdir /opt/OMS && \
    git clone http://lv239@192.168.103.236/lv239/OMS.git /opt/OMS/ && \
    cd /tmp && \
    wget "http://apache.volia.net/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" && \
    tar -zxvf "apache-maven-$MAVEN_VERSION-bin.tar.gz" && \
    mv "apache-maven-$MAVEN_VERSION" "$M2_HOME" && \
    ln -s "$M2_HOME/bin/mvn" /usr/bin/mvn && \
    apk del wget && \
    rm -rf /tmp/* /var/cache/apk/* && \
    cd /opt/OMS && \
    mvn clean && \ 
    mvn install resources:testResources -D DBPATH=192.168.103.168:5432 -D DBNAME=_056_db -D DBUSER=db056 -D DBPASS=db056 -D DBNAMETEST=testdb -D DBUSERTEST=dbtest -D DBPASSTEST=dbtest && \
    rm -rf /opt/tomcat/webapps/* && \
    cp target/OMS.war /opt/tomcat/webapps/ && \
    apk del git && \
    rm -rf /opt/OMS && \
    rm -rf /root/.m2 && \
    rm -rf /tmp/* /var/cache/apk/*

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
