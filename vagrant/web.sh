#!/bin/bash

yum install -y httpd
chkconfig httpd on
yum install -y autoconf
yum install -y libtool
yum install -y httpd-devel
cd ~
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.41-src.tar.gz && tar -zxvf tomcat-connectors-1.2.41-src.tar.gz
rm -f tomcat-connectors-1.2.41-src.tar.gz
cd tomcat-connectors-1.2.41-src/native/
./buildconf.sh && ./configure --with-apxs=/usr/sbin/apxs
make
cp apache-2.0/mod_jk.so /etc/httpd/modules/mod_jk.so
cd ~ && rm -rf tomcat-connectors-1.2.41-src
cp /vagrant/sources/httpd.conf /etc/httpd/conf/httpd.conf
cp /vagrant/sources/workers.properties /etc/httpd/conf/workers.properties
service httpd start
