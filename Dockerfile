FROM indigodatacloud/mesos-master:latest

RUN locale-gen en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

# set default java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && add-apt-repository ppa:openjdk-r/ppa -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jre-headless wget && \
    dpkg --purge --force-depends ca-certificates-java && \ 
    apt-get install -y --no-install-recommends ca-certificates-java &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# workaround for bug on ubuntu 14.04 with openjdk-8-jre-headless
#RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN wget https://security.fi.infn.it/CA/mgt/INFN-CA-2015.pem && keytool -importcert -storepass changeit  -noprompt -trustcacerts -alias infn -file INFN-CA-2015.pem -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts

RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz && tar xfz spark-2.1.1-bin-hadoop2.7.tgz && rm spark-2.1.1-bin-hadoop2.7.tgz

RUN wget http://tarballs.openstack.org/sahara/dist/hadoop-openstack/master/hadoop-openstack-2.7.1.jar -P /spark-2.1.1-bin-hadoop2.7/jars/

WORKDIR /spark-2.1.1-bin-hadoop2.7
