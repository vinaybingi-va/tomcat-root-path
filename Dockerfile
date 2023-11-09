
FROM quay.vapo.va.gov/vapo_tst_images/ubi8

ARG TOMCAT_VERSION=9.0.45

RUN yum -y update && yum -y install initscripts && yum clean all

RUN yum install -y wget && yum clean all

# Download and install java (amazon-corretto)
RUN wget https://corretto.aws/downloads/resources/11.0.17.8.1/java-11-amazon-corretto-devel-11.0.17.8-1.x86_64.rpm -P /tmp --no-check-certificate
RUN yum install -y /tmp/java-11-amazon-corretto-devel-11.0.17.8-1.x86_64.rpm

# Tomcat archive
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz --no-check-certificate && \
    mkdir -p /usr/local/tomcat

# Tomcat installation
RUN tar -zxvf apache-tomcat-$TOMCAT_VERSION.tar.gz --strip-components 1 -C /usr/local/tomcat
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$PATH:$CATALINA_HOME/bin

RUN rm apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN chmod -R 777 /usr/local/tomcat

RUN mkdir -p $CATALINA_HOME/conf/Catalina/localhost && touch $CATALINA_HOME/conf/Catalina/localhost/tomcat.xml

RUN echo "<Context path=\"/tomcat\" />" > $CATALINA_HOME/conf/Catalina/localhost/tomcat.xml

ENTRYPOINT ["catalina.sh", "run"]
