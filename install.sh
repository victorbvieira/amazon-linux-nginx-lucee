#!/bin/bash

# configurações
if [[ "$lucee_version" == "" ]]; then
	export lucee_version="5.3.9.141"
fi

if [[ "$jvm_max_heap_size" == "" ]];then
	#define o tamanho da memoria reservada a JVM (Lucee)
	export jvm_max_heap_size="512m"
fi

#check root permission
if [ "$(whoami)" != "root" ];then
	echo "Sorry, you need to run this script using sudo or as root."
	exit 1
fi

function separador {
	echo " "
	echo "-------------------------------------------------"
	echo " "

}

#make sure scripts are runnable
chown -R root scripts/*.sh
chmod u+x scripts/*.sh


# iniciando instalação
separador
echo "Start ..."
separador

#update system
./scripts/100-amazon-linux-update.sh
separador

#download lucee
./scripts/200-lucee.sh
separador

#install tomcat
./scripts/300-tomcat.sh
separador

#install jvm
./scripts/400-jvm.sh
separador

#install nginx
./scripts/500-nginx.sh
separador

#Configure Lucee
./scripts/600-lucee-config.sh
separador

#echo "Lucee Version = $lucee_version"
#separador
#echo "JVM max heap size = $jvm_max_heap_size"
echo "Done!!!"
