#!/bin/sh
#
#
# เขียนเล่น ก๊อปวาง ก๊อปวาง มันจะโง่ ๆ หน่อย
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

## Enter "4" for IPv4, "6" for IPv6, or "both" if you want to use both.
# 4, 6, both
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

## CURL
CURL4="curl -s -4 --max-filesize 16 --connect-timeout 10 -m 10"
CURL6="curl -s -6 --max-filesize 40 --connect-timeout 10 -m 10"

SLEEP_TIME="sleep 3"

##########################
### Below do not edit. ###
##########################

## Get Random number
RANDOM_NUMBER=$(od -An -N2 -i /dev/urandom | awk '{print $1}')
## 
NUMBER_MOD=$(expr $RANDOM_NUMBER % 15)

# นับจำนวน URL ที่มี
ip_srv_count=0
for var in "$IPSRV_1" "$IPSRV_2" "$IPSRV_3" "$IPSRV_4" "$IPSRV_5" "$IPSRV_6"; do
	if [ -n "$var" ]; then
		ip_srv_count=$(expr $ip_srv_count + 1)
	fi
done
if [ "$ip_srv_count" != "6" ]; then
	echo "Please fill in the complete URL."
	exit 1
fi

get_ip_address() {
	# IP 4
	if [ "$RECORD_TYPE" = "4" ] || [ "$RECORD_TYPE" = "both" ]; then
		case "$NUMBER_MOD" in
			0)
				echo "4 Use $IPSRV_1"
				echo "4 Use $IPSRV_2"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_1)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_2)"
			;;
			1)
				echo "4 Use $IPSRV_1"
				echo "4 Use $IPSRV_3"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_1)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_3)"
			;;
			2)
				echo "4 Use $IPSRV_1"
				echo "4 Use $IPSRV_4"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_1)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_4)"
			;;
			3)
				echo "4 Use $IPSRV_1"
				echo "4 Use $IPSRV_5"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_1)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_5)"
			;;
			4)
				echo "4 Use $IPSRV_1"
				echo "4 Use $IPSRV_6"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_1)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_6)"
			;;
			5)
				echo "4 Use $IPSRV_2"
				echo "4 Use $IPSRV_3"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_2)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_3)"
			;;
			6)
				echo "4 Use $IPSRV_2"
				echo "4 Use $IPSRV_4"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_2)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_4)"
			;;
			7)
				echo "4 Use $IPSRV_2"
				echo "4 Use $IPSRV_5"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_2)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_5)"
			;;
			8)
				echo "4 Use $IPSRV_2"
				echo "4 Use $IPSRV_6"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_2)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_6)"
			;;
			9)
				echo "4 Use $IPSRV_3"
				echo "4 Use $IPSRV_4"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_3)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_4)"
			;;
			10)
				echo "4 Use $IPSRV_3"
				echo "4 Use $IPSRV_5"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_3)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_5)"
			;;
			11)
				echo "4 Use $IPSRV_3"
				echo "4 Use $IPSRV_6"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_3)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_6)"
			;;
			12)
				echo "4 Use $IPSRV_4"
				echo "4 Use $IPSRV_5"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_4)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_5)"
			;;
			13)
				echo "4 Use $IPSRV_4"
				echo "4 Use $IPSRV_6"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_4)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_6)"
			;;
			14)
				echo "4 Use $IPSRV_5"
				echo "4 Use $IPSRV_6"
				IP4_NEW_RAW_1="$($CURL4 $IPSRV_5)"
				IP4_NEW_RAW_2="$($CURL4 $IPSRV_6)"
			;;	
		esac
	fi
	# IP 6
	if [ "$RECORD_TYPE" = "6" ] || [ "$RECORD_TYPE" = "both" ]; then
		case "$NUMBER_MOD" in
			0)
				echo "6 Use $IPSRV_1"
				echo "6 Use $IPSRV_2"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_1)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_2)"
			;;
			1)
				echo "6 Use $IPSRV_1"
				echo "6 Use $IPSRV_3"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_1)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_3)"
			;;
			2)
				echo "6 Use $IPSRV_1"
				echo "6 Use $IPSRV_4"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_1)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_4)"
			;;
			3)
				echo "6 Use $IPSRV_1"
				echo "6 Use $IPSRV_5"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_1)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_5)"
			;;
			4)
				echo "6 Use $IPSRV_1"
				echo "6 Use $IPSRV_6"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_1)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_6)"
			;;
			5)
				echo "6 Use $IPSRV_2"
				echo "6 Use $IPSRV_3"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_2)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_3)"
			;;
			6)
				echo "6 Use $IPSRV_2"
				echo "6 Use $IPSRV_4"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_2)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_4)"
			;;
			7)
				echo "6 Use $IPSRV_2"
				echo "6 Use $IPSRV_5"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_2)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_5)"
			;;
			8)
				echo "6 Use $IPSRV_2"
				echo "6 Use $IPSRV_6"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_2)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_6)"
			;;
			9)
				echo "6 Use $IPSRV_3"
				echo "6 Use $IPSRV_4"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_3)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_4)"
			;;
			10)
				echo "6 Use $IPSRV_3"
				echo "6 Use $IPSRV_5"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_3)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_5)"
			;;
			11)
				echo "6 Use $IPSRV_3"
				echo "6 Use $IPSRV_6"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_3)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_6)"
			;;
			12)
				echo "6 Use $IPSRV_4"
				echo "6 Use $IPSRV_5"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_4)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_5)"
			;;
			13)
				echo "6 Use $IPSRV_4"
				echo "6 Use $IPSRV_6"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_4)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_6)"
			;;
			14)
				echo "6 Use $IPSRV_5"
				echo "6 Use $IPSRV_6"
				IP6_NEW_RAW_1="$($CURL6 $IPSRV_5)"
				IP6_NEW_RAW_2="$($CURL6 $IPSRV_6)"
			;;	
		esac
	fi

	# Remove LF
	IP4_NEW_1=$(echo $IP4_NEW_RAW_1 | tr -d '\n')
	IP4_NEW_2=$(echo $IP4_NEW_RAW_2 | tr -d '\n')

	IP6_NEW_1=$(echo $IP6_NEW_RAW_1 | tr -d '\n')
	IP6_NEW_2=$(echo $IP6_NEW_RAW_2 | tr -d '\n')
	# Compare
	if [ "$RECORD_TYPE" = "4" ] || [ "$RECORD_TYPE" = "both" ]; then
		if [ "$IP4_NEW_1" = "$IP4_NEW_2" ]; then
			IP4_NEW="$IP4_NEW_1"
		else
			echo "IP4 Compare error!"
			exit 1
		fi
	fi
	if [ "$RECORD_TYPE" = "6" ] || [ "$RECORD_TYPE" = "both" ]; then
		if [ "$IP6_NEW_1" = "$IP6_NEW_2" ]; then
			IP6_NEW="$IP6_NEW_1"
		else
			echo "IP6 Compare error!"
			exit 1
		fi
	fi

	# Validate
	if [ "$RECORD_TYPE" = 4 ]; then
		if echo "$IP4_NEW" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
			if echo "$IP4_NEW" | awk -F'.' '{ if ($1 > 255 || $2 > 255 || $3 > 255 || $4 > 255) exit 1; }'; then
				echo "IP4 valid"
				echo "New IP4 $IP4_NEW"
			else
				echo "IP4 format error!"
				exit 1
			fi
		else
			echo "IP4 format error!"
			exit 1
		fi
	elif [ "$RECORD_TYPE" = 6 ]; then
		if echo "$IP6_NEW" | grep -Eq '^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$|^([0-9a-fA-F]{1,4}:)*::([0-9a-fA-F]{1,4}:)*[0-9a-fA-F]{1,4}$'; then
			echo "IP6 valid"
			echo "New IP6 $IP6_NEW"
		else
			echo "IP6 format error!"
			exit 1
		fi
	elif [ "$RECORD_TYPE" = "both" ]; then
		if echo "$IP4_NEW" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
			if echo "$IP4_NEW" | awk -F'.' '{ if ($1 > 255 || $2 > 255 || $3 > 255 || $4 > 255) exit 1; }'; then
				echo "IP4 valid"
				echo "New IP4 $IP4_NEW"
			else
				echo "IP4 format error!"
				exit 1
			fi
		else
			echo "IP4 format error!"
			exit 1
		fi
		if echo "$IP6_NEW" | grep -Eq '^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$|^([0-9a-fA-F]{1,4}:)*::([0-9a-fA-F]{1,4}:)*[0-9a-fA-F]{1,4}$'; then
			echo "IP6 valid"
			echo "New IP6 $IP6_NEW"
		else
			echo "IP6 format error!"
			exit 1
		fi
	fi

}

get_ip_address_old() {
	if [ "$RECORD_TYPE" = "4" ] || [ "$RECORD_TYPE" = "both" ] ;then
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
	if [ "$RECORD_TYPE" = "6" ] || [ "$RECORD_TYPE" = "both" ] ;then
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
	elif [ "$RECORD_TYPE" = "both" ]; then
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
	if [ "$RECORD_TYPE" = "both" ]; then
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
