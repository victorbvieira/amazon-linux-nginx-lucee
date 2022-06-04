#!/bin/bash

#echo "Installing Java 11 openjdk by amazon-linux-extras"
amazon-linux-extras install java-openjdk11

echo "Installing Tomcat 9"

#Config
tomcat9_url="https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.63/bin/apache-tomcat-9.0.63.tar.gz"
tomcat9_tar_gz="apache-tomcat-9.0.63.tar.gz"
tomcat9_dir="apache-tomcat-9.0.63"

wget $tomcat9_url -P /tmp
tar -xvf /tmp/$tomcat9_tar_gz
mv $tomcat9_dir /usr/local/tomcat9

# criar o usuario do tomcat
useradd -r tomcat
chown -R tomcat:tomcat /usr/local/tomcat9

# configurar variavel de ambiente CATALINA_HOME
echo "export CATALINA_HOME="/usr/local/tomcat9"" >> ~/.bashrc
source ~/.bashrc

cp etc/systemd/system/tomcat.service /etc/systemd/system/tomcat.service
chown -R tomcat:tomcat /usr/local/tomcat9


echo "enable and start tomcat"
echo "Reload tomcat service"
sudo systemctl daemon-reload

echo "Restart/Start tomcat service"
sudo systemctl start tomcat

echo "Check tomcat service status"
systemctl status tomcat.service


echo "Stopping Tomcat"
echo date
sudo systemctl stop tomcat

echo "Configuring Tomcat"

mkdir /backup
mkdir /backup/usr
mkdir /backup/usr/local
mkdir /backup/usr/local/tomcat9
mkdir /backup/usr/local/default

#backup default tomcat web.xml
cp /usr/local/tomcat9/conf/web.xml /backup/usr/local/tomcat9/web.xml-orig-backup
#copy nosso web.xml para tomcat directory
# TODO verificar se o arquivo web.xml esta atualizado ou se pode ser melhorado
cp etc/tomcat9/web.xml /usr/local/tomcat9/conf/

#backup default server.xml
cp /usr/local/tomcat9/conf/server.xml /backup/usr/local/tomcat9/server.xml-orig-backup
cp etc/tomcat9/server.xml /usr/local/tomcat9/conf/

#backup default catalina.properties
cp /usr/local/tomcat9/conf/catalina.properties /backup/usr/local/tomcat9/catalina.properties-orig-backup
cp etc/tomcat9/catalina.properties /usr/local/tomcat9/conf/

#jarName="mod_cfml-valve_v1.1.11.jar"
#echo "Installing mod_cfml Valve for Automatic Virtual Host Configuration ($jarName)"
#if [ -f "lib/$jarName" ]; then
#	  cp "lib/$jarName" /opt/lucee/current/
#  else
#	    curl --location -o "/opt/lucee/current/$jarName" "https://raw.githubusercontent.com/viviotech/mod_cfml/master/java/$jarName"
#fi
curl --location -o "/opt/lucee/current/mod_cfml-valve_v1.1.11.jar" "https://raw.githubusercontent.com/viviotech/mod_cfml/master/java/mod_cfml-valve_v1.1.11.jar"


if [ ! -f /opt/lucee/modcfml-shared-key.txt ]; then
	  echo "Generating Random Shared Secret..."
	    openssl rand -base64 42 >> /opt/lucee/modcfml-shared-key.txt
	      #clean out any base64 chars that might cause a problem
	        sed -i "s/[\/\+=]//g" /opt/lucee/modcfml-shared-key.txt
fi



shared_secret=$(cat /opt/lucee/modcfml-shared-key.txt)

#linha abaixo com erro
sed -i "s|SHARED-KEY-HERE|$shared_secret|g" /usr/local/tomcat9/conf/server.xml


echo "Setting Permissions on Lucee Folders"
mkdir /var/lib/tomcat9
mkdir /var/lib/tomcat9/lucee-server
chown -R tomcat:tomcat /var/lib/tomcat9/lucee-server
chmod -R 750 /var/lib/tomcat9/lucee-server
chown -R tomcat:tomcat /opt/lucee
chmod -R 750 /opt/lucee

echo "Setting JVM Max Heap Size to " $jvm_max_heap_size

#sed -i "s/-Xmx128m/-Xmx$JVM_MAX_HEAP_SIZE/g" /etc/default/tomcat9
#-Dlucee.base.dir=/opt/lucee/config/server/
echo "JAVA_OPTS=\"\${JAVA_OPTS} -Xmx$jvm_max_heap_size -Dlucee.base.dir=/opt/lucee/config/server/\"" >> /etc/default/tomcat9

echo "LUCEE_SERVER_DIR=\"/opt/lucee/config/server/\"" >> /etc/default/tomcat9
echo "LUCEE_BASE_DIR=\"/opt/lucee/config/server/\"" >> /etc/default/tomcat9

mkdir /etc/systemd/system/tomcat9.service.d/
echo "[Service]" > /etc/systemd/system/tomcat9.service.d/lucee.conf
echo "ReadWritePaths=/opt/lucee/" >> /etc/systemd/system/tomcat9.service.d/lucee.conf

systemctl daemon-reload && sleep 5









