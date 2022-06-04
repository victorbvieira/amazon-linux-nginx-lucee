#!/bin/bash
web_root="/web"

sudo yum install yum-utils -y

cp etc/nginx/nginx.repo /etc/yum.repos.d/nginx.repo

sudo yum install nginx -y

#verifica versao no ngunx
echo nginx -v

echo "Adding lucee nginx configuration files"
cp etc/nginx/lucee-global.conf /etc/nginx/conf.d/lucee-global.conf
cp etc/nginx/lucee.conf /etc/nginx/lucee.conf
cp etc/nginx/lucee-proxy.conf /etc/nginx/lucee-proxy.conf

echo "Configuring modcfml shared secret in nginx"

shared_secret=`cat /opt/lucee/modcfml-shared-key.txt`

sed -i "s/SHARED-KEY-HERE/$shared_secret/g" /etc/nginx/lucee-proxy.conf

web_root="/web"

echo "Creating web root and default sites here: " $web_root

#deu erro na criação dos diretorios, ja existiam

mkdir $web_root
mkdir $web_root/default
mkdir $web_root/default/wwwroot
mkdir $web_root/example.com
mkdir $web_root/example.com/wwwroot

echo "Creating a default index.html"

#ja tem o arquivo tb
echo "<!doctype html><html><body><h1>Hello</h1></body></html>" > $web_root/default/wwwroot/index.html

#add user tomcat to www-data group so it can read files
#usermod -aG www-data tomcat

usermod -aG nginx tomcat

#set the web directory permissions

#chown -R root:www-data $web_root

chown -R root:nginx  $web_root
chmod -R 750 $web_root


echo "Adding Default and Example Site to nginx"
cp etc/nginx/default.conf /etc/nginx/conf.d/default.conf
cp etc/nginx/example.com.conf /etc/nginx/conf.d/example.com.conf

service nginx restart
