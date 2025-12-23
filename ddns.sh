#!/bin/sh
#
#
# ต้องใช้คู่กับ get-ip.sh
# ต้องมี sh curl jq nsupdate
#

# IP Service
## https://ifconfig.me/ip
## https://ifconfig.co/ip
## https://icanhazip.com/
## https://myexternalip.com/raw
## https://utils.furnu.net/ip
## https://ifconfig.io/ip
## เลือกแบบ Combination
IPSRV_1="https://ifconfig.me/ip"
IPSRV_2="https://ifconfig.co/ip"
IPSRV_3="https://icanhazip.com/"
IPSRV_4="https://myexternalip.com/raw"
IPSRV_5="https://utils.furnu.net/ip"
IPSRV_6="https://ifconfig.io/ip"

## Enter "4" for IPv4, "6" for IPv6, or "all" if you want to use all.
# 4, 6, all
RECORD_TYPE="4"

# APEX ZONE
# example.net
ZONE="example.net"

# QNAME
# example.net, myhome.example.net
QNAME="myhome.example.net"

TTL="60"

# Name Server Host Name or IP Address
NS="ns1.example.net"

# TSIG KEY FILE (tsig-keygen -a hmac-sha512 LOLCAT)
TSIG_PATH="/FULL/PATH/TO/KEY/FILE"

## DiG Option "+tls-ca @1.1.1.1"
DIG_OPTION="+tls-ca @1.1.1.1"

# Discord webhook URL
# Leave blank if not used
DISCORD_URL=""
DISCORD_HOOKNAME="MyHome"

SLEEP_TIME="sleep 3"

################################################################################
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
	if [ "$RECORD_TYPE" = "4" ] || [ "$RECORD_TYPE" = "all" ] ;then
		IP4_OLD="$(dig $QNAME +short $DIG_OPTION -t A)"
		GET_ADDRESS_4_EXIT_CODE="$?"
		if [ "$GET_ADDRESS_4_EXIT_CODE" != "0" ] ; then
			echo "DiG Unable to get old address 4"
			if [ ! -z "$DISCORD_URL" ]; then
				curl \
				  -H "Content-Type: application/json" \
				  -d "$(jq -n --arg username $DISCORD_HOOKNAME --arg content "DiG Unable to get old address 4, DiG exit code $GET_ADDRESS_4_EXIT_CODE, Output message $IP4_OLD" '{"username": $username, "content": $content}')" \
				  $DISCORD_URL
				jq -n --arg username $DISCORD_HOOKNAME --arg content "DiG Unable to get old address 4, DiG exit code $GET_ADDRESS_4_EXIT_CODE, Output message $IP4_OLD" '{"username": $username, "content": $content}'
				exit 1
			fi
			exit 1
		fi
		if [ -z "$IP4_OLD" ]; then
			echo "Please add \"A\" record before use. (0.0.0.0)"
			exit 1
		fi
		echo "IP4 old $IP4_OLD"
	fi
	if [ "$RECORD_TYPE" = "6" ] || [ "$RECORD_TYPE" = "all" ] ;then
		IP6_OLD="$(dig $QNAME +short $DIG_OPTION -t AAAA)"
		GET_ADDRESS_6_EXIT_CODE="$?"
		if [ "$GET_ADDRESS_6_EXIT_CODE" != "0" ] ; then
			echo "DiG Unable to get old address 6"
			if [ ! -z "$DISCORD_URL" ]; then
				curl \
				  -H "Content-Type: application/json" \
				  -d "$(jq -n --arg username $DISCORD_HOOKNAME --arg content "DiG Unable to get old address 6, DiG exit code $GET_ADDRESS_6_EXIT_CODE, Output message $IP6_OLD" '{"username": $username, "content": $content}')" \
				  $DISCORD_URL
				jq -n --arg username $DISCORD_HOOKNAME --arg content "DiG Unable to get old address 6, DiG exit code $GET_ADDRESS_6_EXIT_CODE, Output message $IP6_OLD" '{"username": $username, "content": $content}'
				exit 1
			fi
			exit 1
		fi
		if [ -z "$IP6_OLD" ]; then
			echo "Please add \"AAAA\" record before use. (::1)"
			exit 1
		fi
		echo "IP6 old $IP6_OLD"
	fi	
}

compare_ip_address() {
	if [ "$RECORD_TYPE" = "6" ] && [ "$IP6_NEW" = "$IP6_OLD" ]; then
		echo "IP6 not change bye!"
		exit 0
	elif [ "$RECORD_TYPE" = "4" ] && [ "$IP4_NEW" = "$IP4_OLD" ]; then
		echo "IP4 not change bye!"
		exit 0
	elif [ "$RECORD_TYPE" = "all" ]; then
		if [ "$IP6_NEW" = "$IP6_OLD" ] && [ "$IP4_NEW" = "$IP4_OLD" ]; then
			echo "IP4 and IP6 not change bye!"
			exit 0
		else
			if [ "$IP6_NEW" = "$IP6_OLD" ]; then
				echo "IP6 not change!"
			fi
			if [ "$IP4_NEW" = "$IP4_OLD" ]; then
				echo "IP4 not change!"
			fi
		fi
	fi
}

update_rfc2136() {
	if [ "$RECORD_TYPE" = "4" ]; then
nsupdate -d -v -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME A
update add $QNAME $TTL A $IP4_NEW
send
EOF
NSUPDATE_EXIT_CODE=$?
		if [ ! -z "$DISCORD_URL" ]; then
			curl \
			  -H "Content-Type: application/json" \
			  -d "$(jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 4 FQDN $QNAME addr $IP4_OLD Change to $IP4_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}')" \
			  $DISCORD_URL
			jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 4 FQDN $QNAME addr $IP4_OLD Change to $IP4_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}'
			exit 0
		fi
	fi
	if [ "$RECORD_TYPE" = "6" ]; then
nsupdate -d -v -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME AAAA
update add $QNAME $TTL AAAA $IP6_NEW
send
EOF
NSUPDATE_EXIT_CODE=$?
		if [ ! -z "$DISCORD_URL" ]; then
			curl \
			  -H "Content-Type: application/json" \
			  -d "$(jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 6 FQDN $QNAME addr $IP6_OLD Change to $IP6_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}')" \
			  $DISCORD_URL
			jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 6 FQDN $QNAME addr $IP6_OLD Change to $IP6_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}'
			exit 0
		fi
	fi
	if [ "$RECORD_TYPE" = "all" ]; then
		if [ "$IP6_NEW" != "$IP6_OLD" ] && [ "$IP4_NEW" != "$IP4_OLD" ]; then
			echo "IP4 and IP6 Change..."
nsupdate -d -v -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME AAAA
update add $QNAME $TTL AAAA $IP6_NEW
update delete $QNAME A
update add $QNAME $TTL A $IP4_NEW
send
EOF
NSUPDATE_EXIT_CODE=$?
			if [ ! -z "$DISCORD_URL" ]; then
				curl \
				  -H "Content-Type: application/json" \
				  -d "$(jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 6 and 4 FQDN $QNAME addr 6 $IP6_OLD,4 $IP4_OLD Change to 6 $IP6_NEW, $IP4_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}')" \
				  $DISCORD_URL
				jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 6 and 4 FQDN $QNAME addr 6 $IP6_OLD,4 $IP4_OLD Change to 6 $IP6_NEW, $IP4_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}'
				exit 0
			fi
			:
		elif [ "$IP6_NEW" != "$IP6_OLD" ]; then
			echo "IP6 Change..."
nsupdate -d -v -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME AAAA
update add $QNAME $TTL AAAA $IP6_NEW
send
EOF
NSUPDATE_EXIT_CODE=$?
			if [ ! -z "$DISCORD_URL" ]; then
				curl \
				  -H "Content-Type: application/json" \
				  -d "$(jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 6 FQDN $QNAME addr $IP6_OLD Change to $IP6_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}')" \
				  $DISCORD_URL
				jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 6 FQDN $QNAME addr $IP6_OLD Change to $IP6_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}'
				exit 0
			fi
			:
		elif [ "$IP4_NEW" != "$IP4_OLD" ]; then
			echo "IP4 Change..."
nsupdate -d -v -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME A
update add $QNAME $TTL A $IP4_NEW
send
EOF
NSUPDATE_EXIT_CODE=$?
			if [ ! -z "$DISCORD_URL" ]; then
				curl \
				  -H "Content-Type: application/json" \
				  -d "$(jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 4 FQDN $QNAME addr $IP4_OLD Change to $IP4_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}')" \
				  $DISCORD_URL
				jq -n --arg username $DISCORD_HOOKNAME --arg content "RECORD_TYPE 4 FQDN $QNAME addr $IP4_OLD Change to $IP4_NEW update exit code is $NSUPDATE_EXIT_CODE" '{"username": $username, "content": $content}'
				exit 0
			fi
			:
		fi
	fi
}

get_ip_address
$SLEEP_TIME
get_ip_address_old
compare_ip_address
update_rfc2136
exit $NSUPDATE_EXIT_CODE
