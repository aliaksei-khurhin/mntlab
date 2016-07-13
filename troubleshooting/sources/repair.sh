#!/bin/bash

#comment vhost section in main httpd.conf
sed -i '/^<VirtualHost/,+6 s/^/#/' /etc/httpd/conf/httpd.conf

#change mntlab:80 to *:80 in vhost/conf
sed -i 's/mntlab/*/g' /etc/httpd/conf.d/vhost.conf

#fix of wrong environmental variables for tomcat user
sed -i '/^if/,+2 s/^/#/' /home/tomcat/.bash_profile

#fixing tomcat logs directory ownership
chown tomcat:tomcat /opt/apache/tomcat/current/logs/

#set java version to x64 through alternatives
alternatives --config java <<< '1'

#fix workers.properties
sed -i 's/worker-jk@ppname/tomcat.worker/' /etc/httpd/conf.d/workers.properties
sed -i 's/192.168.56.100/192.168.56.10/' /etc/httpd/conf.d/workers.properties

service httpd restart && service tomcat start

#fix iptables immutable flag
service iptables stop && chattr -i /etc/sysconfig/iptables

#fix iptables rules
sed -i 's/RELATED/RELATED,ESTABLISHED/' /etc/sysconfig/iptables
#sed '10 i\
sed -i '10 i\-A INPUT -p tcp -m tcp --dport 80 -m comment --comment "#webserver" -j ACCEPT' /etc/sysconfig/iptables
sed -i '$ c\COMMIT' /etc/sysconfig/iptables
service iptables start

#set tomcat to start on machine boot
chkconfig tomcat on
