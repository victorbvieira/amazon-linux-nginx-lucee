#!/bin/bash

echo "installing CommandBox"

#make request to server to generate context
curl --verbose http://127.0.0.1:8080/lucee/admin/web.cfm

#adionar repositorio commandbox
cp etc/commandbox/commandbox.repo /etc/yum.repos.d/commandbox.repo

# atualizar 
sudo yum update -y
sudo yum install commandbox -y
box install commandbox-cfconfig

if [[ "$ADMIN_PASSWORD" == "" ]]; then
	echo "No ADMIN_PASSWORD set, generating a random password and storing it here: /root/lucee-admin-password.txt"
	touch /root/lucee-admin-password.txt
	chown root:root /root/lucee-admin-password.txt
	chmod 700 /root/lucee-admin-password.txt
	openssl rand -base64 64 | tr -d '\n\/\+=' > /root/lucee-admin-password.txt
	export ADMIN_PASSWORD=`cat /root/lucee-admin-password.txt`
fi


box cfconfig set adminPassword=$ADMIN_PASSWORD to=/opt/lucee/config/server/lucee-server/ toFormat=luceeServer@5
box cfconfig set adminPasswordDefault=$ADMIN_PASSWORD to=/opt/lucee/config/server/lucee-server/ toFormat=luceeServer@5

#restart to apply changes
systemctl restart tomcat.service
