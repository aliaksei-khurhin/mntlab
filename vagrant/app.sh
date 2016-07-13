#!/bin/bash

yum install -y java
chkconfig httpd on
cd /etc
mkdir tomcat
cd tomcat
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz && tar -zxvf apache-tomcat-8.0.36.tar.gz
rm -f apache-tomcat-8.0.36.tar.gz
./apache-tomcat-8.0.36/bin/startup.sh
