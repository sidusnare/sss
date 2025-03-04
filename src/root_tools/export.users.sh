#!/bin/bash

mkdir /root/users.export

for i in *;do 
	if id $i; then 
		id "${i}" > "/root/users.export/${i}.pretty"
		id -u "${i}" > "/root/users.export/${i}.id"
		id -g "${i}" > "/root/users.export/${i}.group"
		id -G "${i}" > "/root/users.export/${i}.groups"
		getent shadow "${i}" > "/root/users.export/${i}.shadow"
		getent passwd "${i}" > "/root/users.export/${i}.passwd"
		echo "${i}" > "/root/users.export/list"
		if [ -e "/home/${i}/.ssh/authorized_keys" ]; then
			cp "/home/${i}/.ssh/authorized_keys" "/root/users.export/${i}.authorized_keys"
		fi
	fi;
done
for g in ` cat /root/users.export/*.group* | tr ' ' '\n' | sort -u`;do
	getent group "${g}" >> /root/users.export/group_list
done
