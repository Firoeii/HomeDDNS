#!/bin/sh
IP4_OLD=""
IP6_OLD=""
get_ip_address() {
	local RECORD_TYPE="$1"
	local PATH_4="$2"
	local PATH_6="$3"
	if [ "$RECORD_TYPE" = "4" ] || [ "$RECORD_TYPE" = "all" ] ;then
		if ! IP4_NEW=$(head -c 17 $PATH_4);then
			echo "IP file on $PATH_4 missing"
			return 1
		fi
	fi
	if [ "$RECORD_TYPE" = "6" ] || [ "$RECORD_TYPE" = "all" ] ;then
		if ! IP6_NEW=$(head -c 41 $PATH_6);then
			echo "IP file on $PATH_6 missing"
			return 1
		fi
	fi
}

get_ip_address_old() {
	local RECORD_TYPE="$1"
	local QNAME="$2"
	local DIG_ARGS="$3"
	
	if [ "$RECORD_TYPE" = "4" ] || [ "$RECORD_TYPE" = "all" ] ;then
		IP4_OLD="$(dig $QNAME +short $DIG_ARGS -t A)" || return 1
	fi
	if [ "$RECORD_TYPE" = "6" ] || [ "$RECORD_TYPE" = "all" ] ;then
		IP6_OLD="$(dig $QNAME +short $DIG_ARGS -t AAAA)" || return 1
	fi
}

compare_ip_address() {
	local RECORD_TYPE="$1"
	
	if [ "$RECORD_TYPE" = "6" ] && [ "$IP6_NEW" = "$IP6_OLD" ]; then
		return 0
	elif [ "$RECORD_TYPE" = "4" ] && [ "$IP4_NEW" = "$IP4_OLD" ]; then
		return 0
	elif [ "$RECORD_TYPE" = "all" ]; then
		if [ "$IP6_NEW" = "$IP6_OLD" ] && [ "$IP4_NEW" = "$IP4_OLD" ]; then
			return 0
		fi
	fi
	return 1
}

update_rfc2136() {
	local NSUPDATE_CMD="$1"
	local NS="$2"
	local ZONE="$3"
	local QNAME="$4"
	local TTL="$5"
	local ECORD_TYPE="$6"
	if [ "$RECORD_TYPE" = "4" ]; then
$NSUPDATE_CMD -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME A
update add $QNAME $TTL A $IP4_NEW
send
EOF
		return $?
	fi
	if [ "$RECORD_TYPE" = "6" ]; then
$NSUPDATE_CMD -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME AAAA
update add $QNAME $TTL AAAA $IP6_NEW
send
EOF
		return $?
	fi
	if [ "$RECORD_TYPE" = "all" ]; then
$NSUPDATE_CMD -k $TSIG_PATH << EOF
server $NS
zone $ZONE
update delete $QNAME A
update delete $QNAME AAAA
update add $QNAME $TTL A $IP4_NEW
update add $QNAME $TTL AAAA $IP6_NEW
send
EOF
		return $?
	fi
}
