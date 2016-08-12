#!/bin/bash

yum install -y git
yum install -y unzip
yum install -y vim
yum install -y httpd
yum install -y java-1.8.0-openjdk-devel.x86_64
cp /vagrant/vhost.conf /etc/httpd/conf.d/vhost.conf
service httpd start && chkconfig httpd on

wget –no-check-certificate --no-cookies http://pkg.jenkins-ci.org/redhat/jenkins-1.658-1.1.noarch.rpm
rpm -ivh jenkins-1.658-1.1.noarch.rpm
rm -f jenkins-1.658-1.1.noarch.rpm
service jenkins start && chkconfig jenkins on

cd ~
wget http://ftp.byfly.by/pub/apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.zip
unzip apache-maven-3.3.9-bin.zip
rm -f apache-maven-3.3.9-bin.zip
mkdir /opt/maven
mv apache-maven-3.3.9 /opt/maven/
chown -R jenkins:jenkins /opt/maven/apache-maven-3.3.9

useradd nexus
echo password|passwd nexus --stdin
wget https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-2.13.0-01-bundle.zip
mkdir /opt/nexus
mv nexus-2.13.0-01-bundle.zip /opt/nexus
cd /opt/nexus
unzip nexus-2.13.0-01-bundle.zip
rm -f nexus-2.13.0-01-bundle.zip
chown -R nexus:nexus /opt/nexus
su - nexus -c 'cp /vagrant/nexus.properties /opt/nexus/nexus-2.13.0-01/conf/'
cp /vagrant/nexus /etc/init.d/nexus
chmod +x /etc/init.d/nexus
service nexus start && chkconfig nexus on

#jenkins job builder
yum install -y https://centos6.iuscommunity.org/ius-release.rpm
yum install -y python27 python27-devel python27-setuptools python27-pip
pip2.7 install -U argparse jenkins-job-builder
