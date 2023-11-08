#!/bin/bash
#Fred Dinkler IV
#GPLv3


#This script is part of my config management, so it will try to install the route53 gem, and if will try to install ruby gems to do so
#It will run apt and yum to try to get it. Feel free to gut those parts of the script and do it by hand.
#I also put the creds here and write to a config file, you don't have to do that for a one off.

#These lock files are used by a wrapper script to put this in a cron job
echo "${$}" > '/tmp/.myip_r53.lock'
date +%s >> '/tmp/.myip_r53.lock'

PATH="${PATH}:/usr/local/bin/:/usr/local/sbin/:/sbin/"

#Change these to your NS servers provided by AWS in your domain's specific route53 informaiton
MYNS=( ns-1.awsdns-1.com. ns-2.awsdns-2.co.uk. ns-3.awsdns-3.net. ns-4.awsdns-4.org. )
#Chagne these to an API credential that has update access to your Route53 domain
R53="---\naccess_key: AAAAAAAAAAAAAAAAAAAA\nsecret_key: BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\napi: '2011-05-05'\nendpoint: https://route53.amazonaws.com/\ndefault_ttl: '3600'\n"
#Chane this to your domain
DOM='domain.com'

#This script can be found at https://github.com/fabianonline/matrix.sh or if you have some other chat server with API access (Slack, HipChat?) you can write a similar script and drop it here, or don't it'll just throw some errors when it tries
MATRIX=( '/usr/local/bin/matrix.sh' '--send' '--room=!RRRRRRRRRRRRRRRRRR:chat.domain' )

NAME="$( hostname | cut -d . -f 1 )"
MYNAME="${NAME}.${DOM}."
MYENAME="${NAME}-ext.${DOM}."
DEPS=( 'ip' 'route' 'grep' 'awk' 'gem' 'isip.sh' 'hostname' 'cut' 'dig' )

if command -v curl &>> /dev/null; then
        FETCH=( 'curl' '-s' '-k' )
elif command -v wget &>> /dev/null; then
        FETCH=( 'wget' '-q' '-O' '-' )
else
	echo "Unable to find HTTP utility" >&2
	exit 1
fi

if ! command -v isip.sh &>> /dev/null; then
	echo "isip.sh utility needed, get it at https://github.com/sidusnare/sss, put it in your path" >&2
	exit 1
fi

for cmd in "${DEPS[@]}";do
	if ! command -v "${cmd}" &>> /dev/null; then
		echo "Unable to find ${cmd}, please isntall it or check paths" >&2
		exit 1
	fi
done

if ! command -v route53;then
	for g in /usr/local/lib64/ruby/gems/*;do
        	if [ -x "${g}/bin/route53" ];then
                	PATH="${PATH}:${g}/bin/"
       		 fi      
	done
fi

if ! command -v route53 &>> /dev/null; then
	"${MATRIX[@]}" "${NAME}:Installing Route53"
	if command -v gem; then
		if ! gem install route53; then
			apt install -y ruby-rubygems || yum install -y ruby rubygems ruby-devel
			if ! gem install route53; then
				"${MATRIX[@]}" "${NAME}:Unable to install route53, gem failure"
				echo "Unable to install route53, gem failure" >&2
				rm -f -v '/tmp/.myip_r53.lock'
				exit 1
			fi
		fi
	else
		"${MATRIX[@]}" "${NAME}:Unable to install route53, no gem"
		echo "Unable to install route53, gem failure" >&2
		rm -f -v '/tmp/.myip_r53.lock'
		exit 1
	fi
fi

if ! command -v route53;then
	for g in /usr/local/lib64/ruby/gems/*;do
        	if [ -x "${g}/bin/route53" ];then
                	PATH="${PATH}:${g}/bin/"
       		 fi      
	done
fi

for ns in "${MYNS[@]}";do
	edoip="$( dig +short A  "${MYENAME}" "@${ns}" )"
	if isip.sh "${edoip}"; then
		break
	fi
done

for ns in "${MYNS[@]}";do
	doip="$( dig +short A "${MYNAME}" "@${ns}" )"
	if isip.sh "${doip}"; then
		break
	fi
done

intdev="$(route -n | grep -E -v 'tun[0-9][0-9]*$|tap[0-9][0-9]*$ppp[0-9][0-9]*$' | grep -m 1 '^0\.0\.0\.0 ' | awk '{print($8)}')"
intip="$( ip addr show dev "${intdev}"  | grep -w inet | tr '/' ' ' | awk '{print($2)}' | head -n 1 )"
if ! isip.sh "${intip}"; then
	"${MATRIX[@]}" "${NAME}:Unable to parse running ip configuration"
	rm -f -v '/tmp/.myip_r53.lock'
	exit 1
fi

for server in checkip.amazonaws.com ifconfig.me icanhazip.com ipecho.net/plain ifconfig.co;do
	#trying to sanitize as much as possible here, but you know, getting data from a remote server in a bash script is a bit risky.
	#In my version of this, the first server in the list is my server with a PHP script that's just <?php echo $_SERVER['REMOTE_ADDR']; ?>
	#So the rest are just fallbacks for if my server is down or unreachable for whatever
	extip="$( "${FETCH[@]}" -4 "https://${server}" | tr ' ' '\n' | grep -m 1  -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' )"
	if isip.sh "${extip}"; then
		break
	fi
done

if [ ! -e "${HOME}/.route53.myip_r53" ]; then
	echo -e "${R53}" > "${HOME}/.route53.myip_r53"
	chmod 0700 "${HOME}/.route53.myip_r53"
fi

#IPv6 support is new and I'm not sure it's working very well
if ip addr | grep inet6 | grep -w global; then
	for server in icanhazip.com ifconfig.co; do
		ipv6="$( "${FETCH[@]}" -6 "${server}" )"
		if ip -6 addr show | grep "${ipv6}"; then
			break
		fi
	done
	for ns in "${MYNS[@]}";do
		edoipv6="$( dig +short AAAA  "${MYNAME}" "@${ns}" )"
		if [ -n "${edoipv6}" ]; then
			break
		fi
	done
	if [ "${edoipv6}" != "${ipv6}" ];then
		if ip -6 addr show | grep "${ipv6}"; then
			if [ -n "${edoipv6}" ]; then
				route53 --file "${HOME}/.route53.myip_r53" --zone "${DOM}" --change --name "${MYNAME}" --type AAAA --ttl 300 --values "${ipv6}"
			else
				route53 --file "${HOME}/.route53.myip_r53" --zone "${DOM}" --create --name "${MYNAME}" --type AAAA --ttl 300 --values "${ipv6}"
			fi
		fi
	fi
fi

if [ "${intip}"  != "${doip}" ]; then
	if isip.sh "${doip}"; then
		if route53 --file "${HOME}/.route53.myip_r53" --zone "${DOM}" --change --name "${MYNAME}" --type A --ttl 300 --values "${intip}";then
			"${MATRIX[@]}" "${NAME}:Changing ${MYNAME} to ${intip}"
			echo "Changing ${MYNAME} to ${intip}"
		else
			"${MATRIX[@]}" "${NAME}:Unable to change ${MYNAME} to ${intip}, rotue53 returned: ${?}"
			echo "Unable to change ${MYNAME} to ${intip}, rotue53 returned: ${?}"
		fi

	else
		if route53 --file "${HOME}/.route53.myip_r53" --zone "${DOM}" --create --name "${MYNAME}" --type A --ttl 300 --values "${intip}"; then
			"${MATRIX[@]}" "${NAME}:Created ${MYNAME} as ${intip}."
			echo "Created ${MYNAME} as ${intip}."
		else
			"${MATRIX[@]}" "${NAME}:Unable to create ${MYNAME} as ${intip}, rotue53 returned: ${?}"
			echo "Unable to create ${MYNAME} as ${intip}, rotue53 returned: ${?}"
		fi
	fi
fi

if [ "${extip}" != "${edoip}" ]; then
	if isip.sh "${edoip}";then
		if route53 --file "${HOME}/.route53.myip_r53" --zone "${DOM}" --change --name "${MYENAME}" --type A --ttl 300 --values "${extip}"; then
			"${MATRIX[@]}" "${NAME}:Changed ${MYENAME} to ${extip}"
			echo "Changed ${MYENAME} to ${extip}"
		else
			"${MATRIX[@]}" "${NAME}:Unable to change ${MYENAME} to ${extip} rotue53 returned: ${?}"
			echo "Unable to change ${MYENAME} to ${extip} rotue53 returned: ${?}"
		fi
	else
		if route53 --file "${HOME}/.route53.myip_r53" --zone "${DOM}" --create --name "${MYENAME}" --type A --ttl 300 --values "${extip}"; then
			"${MATRIX[@]}" "${NAME}:Created ${MYENAME} at ${extip} rotue53 returned: ${?}"
			echo "Created ${MYENAME} at ${extip} rotue53 returned: ${?}"
		else
			"${MATRIX[@]}" "${NAME}:Unable to create ${MYENAME} with ${extip}, rotue53 returned: ${?}"
			echo "Unable to create ${MYENAME} with ${extip}, rotue53 returned: ${?}"
		fi
	fi
fi

echo -e "Local settings\n\tIPv4: ${intip}\n\tIPv4 external: ${extip}\n\tIPv6: ${ipv6}\nDNS Values\n\tIPv4: ${doip}\n\tIPv4 external: ${edoip}\n\tIPv6: ${edoipv6}"
rm -f '/tmp/.myip_r53.lock'
