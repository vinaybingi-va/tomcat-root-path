
FROM quay.vapo.va.gov/vapo_tst_images/ubi8

ARG TOMCAT_VERSION=9.0.45

RUN yum -y update && yum -y install initscripts && yum clean all

RUN yum install -y java-17-openjdk-devel wget && yum clean all
ENV JAVA_HOME=/usr/lib/jvm/jre

# Tomcat archive
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz --no-check-certificate && \
    mkdir -p /usr/local/tomcat

# Tomcat installation
RUN tar -zxvf apache-tomcat-$TOMCAT_VERSION.tar.gz --strip-components 1 -C /usr/local/tomcat
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$PATH:$CATALINA_HOME/bin/

RUN mkdir -p $CATALINA_HOME/conf/Catalina/localhost && touch $CATALINA_HOME/conf/Catalina/localhost/tomcat.xml

RUN echo "<Context path=\"/tomcat\" />" > $CATALINA_HOME/conf/Catalina/localhost/tomcat.xml

COPY /tomcat/tomcat.xml $CATALINA_HOME/conf/Catalina/localhost/

CMD ["catalina.sh" "run"]
