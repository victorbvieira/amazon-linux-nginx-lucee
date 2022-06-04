#!/bin/bash

if [[ $skippin_system_update ]];then
	echo "Skipping system updade/upgrade"
else
	echo "Updating System"
	yum update -y
	echo "Upgrade System"
	yum upgrade -y
fi
