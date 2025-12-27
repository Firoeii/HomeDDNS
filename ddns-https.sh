#!/bin/bash
#
# Dynamic HTTPS Recordset
# ALPN H3,H2

## Enter "4" for IPv4, "6" for IPv6, or "all" if you want to use all.
# 4, 6, all
RECORD_TYPE="all"

# APEX ZONE
# example.net
ZONE=""

# QNAME
# example.net, myhome.example.net
QNAME=""

TTL="60"

# Name Server Host Name or IP Address
NS="ns1.example.com"

# TSIG KEY FILE (tsig-keygen -a hmac-sha512 LOLCAT)
TSIG_PATH="/home/nusara/Documents/_bind9/key"

## DiG Option "+tls-ca @1.1.1.1"
DIG_OPTION="+tls-ca @8.8.8.8"

######################################
get_ip_address() {

	if [ "$RECORD_TYPE" = "4" ] || [ "$RECORD_TYPE" = "all" ] ;then
		if ! IP4_NEW=$(cat /tmp/_host_address_4.txt);then
			echo "IP file on /tmp/_host_address_4.txt missing"
			exit 1
		fi
	fi
	if [ "$RECORD_TYPE" = "6" ] || [ "$RECORD_TYPE" = "all" ] ;then
		if ! IP6_NEW=$(cat /tmp/_host_address_6.txt);then
			echo "IP file on /tmp/_host_address_6.txt missing"
			exit 1
		fi
	fi

}

get_ip_address_old() {
	IP_HTTPS_OLD="$(dig $QNAME +short $DIG_OPTION -t HTTPS)"
	if [ ! "$?" = "0" ]; then
		echo "get_ip_address_old dig error!"
		exit 1
	fi
	if [ -z "$IP_HTTPS_OLD" ];then
		echo "get_ip_address_old string empty"
		echo "(First time setup? add dummy https 'example.com. 60 IN HTTPS 1 . alpn="h3,h2" ipv4hint=0.0.0.0 ipv6hint=::1')"
		exit 1
	fi
}

parse_old_https_record() {
	if [ "$RECORD_TYPE" = "4" ] || [ "$RECORD_TYPE" = "all" ]; then
		if [[ $IP_HTTPS_OLD =~ ipv4hint=([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) ]]; then
			IP4_OLD=${BASH_REMATCH[1]}
			echo "IPv4 Old: $IP4_OLD"
		fi
	fi

	if [ "$RECORD_TYPE" = "6" ] || [ "$RECORD_TYPE" = "all" ]; then
		if [[ $IP_HTTPS_OLD =~ ipv6hint=([0-9a-fA-F:]+) ]]; then
			IP6_OLD=${BASH_REMATCH[1]}
			echo "IPv6 Old: $IP6_OLD"
		fi
	fi
}

MAKE_CHANGE="0"
compare_ip_address() {
	# IP 4
	if [ "$RECORD_TYPE" = "4" ] || [ "$RECORD_TYPE" = "all" ]; then
		if [ ! "$IP4_NEW" = "$IP4_OLD" ];then
			MAKE_CHANGE="1"
		fi
	fi
	# IP 6
	if [ "$RECORD_TYPE" = "6" ] || [ "$RECORD_TYPE" = "all" ]; then
		if [ ! "$IP6_NEW" = "$IP6_OLD" ];then
			MAKE_CHANGE="1"
		fi
	fi
}

echo "Get current address..."
get_ip_address
echo "Get old address..."
get_ip_address_old

parse_old_https_record
echo "Old record: $IP_HTTPS_OLD"

compare_ip_address

echo "Change?: $MAKE_CHANGE"

if [ "$MAKE_CHANGE" = 1 ] && [ "$RECORD_TYPE" = "all" ];then
nsupdate -d -v -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME HTTPS
update add $QNAME $TTL HTTPS 1 . alpn="h3,h2" ipv4hint=$IP4_NEW ipv6hint=$IP6_NEW
send
EOF
fi
if [ "$MAKE_CHANGE" = 1 ] && [ "$RECORD_TYPE" = "4" ];then
nsupdate -d -v -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME HTTPS
update add $QNAME $TTL HTTPS 1 . alpn="h3,h2" ipv4hint=$IP4_NEW
send
EOF
fi
if [ "$MAKE_CHANGE" = 1 ] && [ "$RECORD_TYPE" = "6" ];then
nsupdate -d -v -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME HTTPS
update add $QNAME $TTL HTTPS 1 . alpn="h3,h2" ipv6hint=$IP6_NEW
send
EOF
fi
