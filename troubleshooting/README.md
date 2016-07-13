|| Issue | How to find | Time to find| How to fix | Time to fix |
| --- | --- | --- | --- | --- | --- |
|1|site does't work| curl -IL 192.168.56.10 returns code 302 & 503 either from VM and from host machine|~2 min|Checking  main httpd config and included vhost config using less command. Commenting  vhost entries in main config. Fixing  vhost section in vhost config to accept all connections to 80 port. Restarting httpd|10 min| 
|2|wrong environment variables on tomcat user| curl -IL 192.168.56.10 returns 503. Checking  jkmod log file: failed connection to backend. Attempt to run tomcat using 'service tomcat start'. Checking if tomcat is running by 'ps -ef\| grep tomcat' - tomcat is not running. Checking tomcat init script. Trying to execute 'su - tomcat -c "sh /opt/apache/tomcat//current/bin/startup.sh"'. Tomcat still doesn't start. Searching for 'setclasspath.sh' in startup.sh. Running 'echo $CATALINA_HOME' under user tomcat. Reviewing ~/\.bash_profile and ~/\.bashrc files. |20 min| Commenting strings, were $JAVA_HOME and $CATALINA_HOME are set. |2 min|
|3|tomcat logs dir ownership| Trying to start tomcat. Tomcat can't touch log file. |2 min| Checking logs directory ownership using 'chown tomcat:tomcat logs'. |2 min|
|4|wrong java version| Trying to run tomcat. Checking 'ps -ef \|grep tomcat'. Checking catalina.out. Checking java version by 'java -version'. Running 'uname -m' to check if OS is x64 or x86.|5 min|Changing java version via 'alternatives --config java' to x64 version (customer approval reauired). Tomcat works|1 min|
|5| mistakes in workers.properties| Still 503 responce from curl. Viewing vhost.conf file. Checking  jkmod.log: - no connection with backend. Checking workers.properties|5 min| Correcting mistakes in workers.properties: worker name mismatch and ip-address. Restarting httpd |5 min|
|6| iptables file immutable flag| Checking if iptables service is working by 'service iptables status'. Attempting to start service. Viewing flags on file using 'lsattr' command|1h| Removing immutable attribute by 'chattr -i /etc/sysconfig/iptables'|1 min|
|7| mistakes in iptables| viewing iptables file|1 h| Editing iptables file by adding 'ESTABLISHED' to work with opened connections and '-A INPUT -p tcp -m tcp --dport 80 -m comment --comment "#webserver" -j ACCEPT' to open 80 port.|15 min|
|8| setting tomcat to start on VM boot |||run 'chkconfig tomcat on'|1 min|

all logs and config views were performed with 'less' command

###Possible configuration improvments (customer approve required)
* server name config in main httpd config
* too many modules are connected to httpd
* backend errors shoud be intercepted by httpd
* tomcat can be binded to loopback ip


###Additional questions answers
1. There are 2 JAVA versions installed: jdk1.7.0_79  in x64 and i586 variants (alternatives --config java).
2. it was installed and configured manually (through alternatives)
3. According to config files of httpd and tomcat, log files are:
    * /etc/httpd/logs/error_log - main httpd error log
    * /etc/httpd/logs/access_log - main httpd access log
    * /var/log/httpd/error.log - error log for  virtualhost
    * /var/log/httpd/access.log - access log for  virtualhost
    * /var/log/httpd/modjk.log - mod_jk log
    * /opt/apache/tomcat/current/logs/localhost_access_log 
    * /opt/apache/tomcat/current/logs/catalina
    * /opt/apache/tomcat/current/logs/host_manager
    * /opt/apache/tomcat/current/logs/localhost
    * /opt/apache/tomcat/current/logs/manager
    * /opt/apache/tomcat/current/logs/catalina.out - main tomcat log
4. JAVA_HOME is an environment variable which contains path to /bin directory, which contains java binary files
5. Tomcat is installed to /opt/apache/tomcat/7.0.62/ directory. /opt/apache/tomcat/current/ is a link
6. CATALINA_HOME is an environment variable that contents  path to tomcat home directory.
7. httpd parent process is running from root user, because it needs to open sockets. Child processess are run by apache:apache user, it is configured in main apache config (/etc/httpd/conf/httpd.conf). Apache is run by tomcat:tomcat user, it's written in /etc/init.d/tomcat file.
8. * /etc/httpd/conf/httpd.conf - include directive, which points to conf.d directory
    * /etc/httpd/conf.d/vhost.conf - mod_jk configuration is written here
    * /etc/httpd/conf.d/workers.properties - workers configuration  is described in this file
    * /opt/apache/tomcat/conf/server.xml - main tomcat config, were port and IP bindings are written
9. This expression shows number of blocking processes  waiting for execution within certain time interval - 5, 10 and 15 minutes. In this case blocking process is process, waiting resources for execution.
