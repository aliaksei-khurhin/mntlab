#!/bin/bash

yum install -y unzip
yum install -y vim
yum install -y httpd
yum install -y java-1.6.0-openjdk.x86_64
cp /vagrant/vhost.conf /etc/httpd/conf.d/vhost.conf
service httpd start
chkconfig httpd on

useradd jboss
echo password|passwd jboss --stdin
mkdir /home/jboss/logs
mkdir /opt/jboss
mkdir /opt/java
cp /vagrant/jdk-6u45-linux-x64.bin /opt/java
cd /opt/java
./jdk-6u45-linux-x64.bin
rm -f /opt/java/jdk-6u45-linux-x64.bin
cp /vagrant/jboss-eap-5.1.2.zip /opt/jboss
cd /opt/jboss
unzip jboss-eap-5.1.2.zip
rm -f jboss-eap-5.1.2.zip
cp -r /opt/jboss/jboss-eap-5.1/jboss-as/server/all /home/jboss/custom
sed -i -e '$a\admin=admin' /home/jboss/custom/conf/props/jmx-console-users.properties
chown -R jboss:jboss /home/jboss/
chown -R jboss:jboss /opt/java
chown -R jboss:jboss /opt/jboss
sed -i -e '$a\JAVA_HOME=/opt/java/jdk1.6.0_45' /home/jboss/.bashrc
cp /vagrant/jboss /etc/init.d/
chmod +x /etc/init.d/jboss
service jboss start
chconfig jboss on