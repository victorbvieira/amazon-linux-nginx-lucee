#!/bin/bash

jar_url="https://release.lucee.org/rest/update/provider/loader/$lucee_version"
if [[ $lucee_light ]];then
	jar_url="https://release.lucee.org/rest/update/provider/light/$lucee_version"
fi

jar_folder="lucee-$lucee_version"

echo "Installing Lucee $lucee_version"
mkdir /opt/lucee
mkdir /opt/lucee/config
mkdir /opt/lucee/config/server
mkdir /opt/lucee/config/web
mkdir /opt/lucee/$jar_folder

curl --location -o /opt/lucee/$jar_folder/lucee.jar $jar_url

if [ -f "/opt/lucee/$jar_folder/lucee.jar" ]; then
	echo "Download Complete"
else
	echo "Download of Lucee Failed Exiting..."
	exit 1
fi

ln -s /opt/lucee/$jar_folder /opt/lucee/current
