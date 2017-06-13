FROM indigodatacloud/mesos-master:latest

RUN locale-gen en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

# set default java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common python-setuptools && add-apt-repository ppa:openjdk-r/ppa -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jre-headless wget && \
    # workaround for bug on ubuntu 14.04 with openjdk-8-jre-headless
    # re-install ca-certificates-java
    dpkg --purge --force-depends ca-certificates-java && \ 
    apt-get install -y --no-install-recommends ca-certificates-java &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 



RUN wget https://security.fi.infn.it/CA/mgt/INFN-CA-2015.pem && keytool -importcert -storepass changeit  -noprompt -trustcacerts -alias infn -file INFN-CA-2015.pem -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts

RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz && \
    mkdir /spark && \
    tar xfz spark-2.1.1-bin-hadoop2.7.tgz -C /spark --strip-components 1 && \
    rm spark-2.1.1-bin-hadoop2.7.tgz

RUN wget http://tarballs.openstack.org/sahara/dist/hadoop-openstack/master/hadoop-openstack-2.7.1.jar -P /spark/jars/

RUN wget https://pypi.python.org/packages/94/ee/c662aec4082b759445ea0cc0a6b3f2213864ed6b74229c0f25c79bedc8b4/j2cli-0.3.0-0.tar.gz#md5=e33a7cc61962b7ecc1c740c64885c9fc && \
    tar xvfz j2cli-0.3.0-0.tar.gz && \
    rm j2cli-0.3.0-0.tar.gz && \
    cd j2cli-0.3.0-0 && python setup.py install

ENV SPARK_HOME /spark

COPY core-site.xml.j2 /spark/core-site.xml.j2
COPY spark-defaults.conf.j2 /spark/spark-defaults.conf.j2

COPY entrypoint.sh /spark/entrypoint.sh

RUN chmod 755 /spark/entrypoint.sh

WORKDIR /spark

ENTRYPOINT ["/spark/entrypoint.sh"]


