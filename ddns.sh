#!/bin/sh
# dnssec-keygen -T key -a ED25519 -n HOST example.net
## Please add an empty DNS record before use.
## example.net IN A 0.0.0.0
## example.net IN AAAA ::1
# 4 or 6 or both (have 4 and 6)
IPv="4"
# APEX ZONE
ZONE="example.net"
# (DOMAIN = QNAME eg. myhostname.example.net)
DOMAIN="myhome.example.net"
# PATH/TO/KEY
DNSKEY="/PATH/TO/KEY/FILE"
# NS Address or Host NS Name
NS="ns1.example.net"
# IP Service
## https://ifconfig.me/ip
## https://icanhazip.com/
IPSRV=""
# DiG Option [+tls +tls-ca @1.1.1.1]
DIG_OPTION="+tls-ca @1.1.1.1"
TTL=60
# Discord webhook URL
# Leave blank if not used
URL=""
HOOKNAME="My home"

INET_4() {
	RR4=$(curl -4 -s $IPSRV)
	if [ $? != 0 ]; then
		echo "CURL 4 ERROR Exit code $?"
		exit 1
	fi

	OLDIP=$(dig $DOMAIN +short $DIG_OPTION -t A)

	if [ -z "$OLDIP" ] || [ -z "$RR4" ]; then
        	echo "DNS String Empty"
	        echo "Exit...."
        	exit 1
	fi

	if [ "$RR4" = "$OLDIP" ]; then
	        echo "IP 4 NOT CHANGE"
        	echo "Exit...."
	        exit 0
	else
        	echo "Wait....."
	fi;
echo "RR4"
echo $RR4
nsupdate -d -v -k $DNSKEY << EOF
server $NS
zone $ZONE
update delete $DOMAIN A
update add $DOMAIN $TTL A $RR4
send
EOF
	if [ ! -z "$URL" ]; then
		curl \
		  -H "Content-Type: application/json" \
		  -d "{\"username\": \"$HOOKNAME\", \"content\": \"IP "$DOMAIN" "$OLDIP" Change To "$RR4" Now\"}" \
		  $URL

		exit 0
	fi
}

INET_6() {
	RR6=$(curl -6 -s $IPSRV)
        if [ $? != 0 ]; then
                echo "CURL 6 ERROR Exit code $?"
                exit 1
        fi

	OLDIP=$(dig $DOMAIN +short $DIG_OPTION -t AAAA)

	if [ -z "$OLDIP" ] || [ -z "$RR6" ]; then
        	echo "DNS String Empty"
	        echo "Exit...."
        	exit 1
	fi

	if [ "$RR6" = "$OLDIP" ]; then
        	echo "IP 6 NOT CHANGE"
	        echo "Exit...."
        	exit 0
	else
        	echo "Wait....."
	fi;
echo "RR6"
echo $RR6
nsupdate -d -v -k $DNSKEY << EOF
server $NS
zone $ZONE
update delete $DOMAIN AAAA
update add $DOMAIN $TTL AAAA $RR6
send
EOF
	if [ ! -z "$URL" ]; then
		curl \
		  -H "Content-Type: application/json" \
		  -d "{\"username\": \"$HOOKNAME\", \"content\": \"IP "$DOMAIN" "$OLDIP" Change To "$RR6" Now\"}" \
		  $URL
		exit 0
	fi
}

INET_BOTH() {
	OLDIP6=$(dig $DOMAIN +short $DIG_OPTION -t AAAA)
	OLDIP4=$(dig $DOMAIN +short $DIG_OPTION -t A)
	RR4=$(curl -4 -s $IPSRV)
        if [ $? != 0 ]; then
                echo "CURL 4 ERROR Exit code $?"
                exit 1
        fi
	RR6=$(curl -6 -s $IPSRV)
        if [ $? != 0 ]; then
                echo "CURL 6 ERROR Exit code $?"
                exit 1
        fi

        if [ -z "$OLDIP4" ] || [ -z "$OLDIP6" ] || [ -z "$RR4" ] || [ -z "$RR6" ]; then
                echo "DNS String Empty"
                echo "Exit...."
                exit 1
        fi

	if [ "$RR4" != "$OLDIP4" ] && [ "$RR6" != "$OLDIP6" ]; then

echo "RR4 AND RR6 CHANGE"
echo $RR4
echo $RR6
nsupdate -d -v -k $DNSKEY << EOF
server $NS
zone $ZONE
update delete $DOMAIN A
update add $DOMAIN $TTL A $RR4
update delete $DOMAIN AAAA
update add $DOMAIN $TTL AAAA $RR6
send
EOF
		if [ ! -z "$URL" ]; then
			curl \
			  -H "Content-Type: application/json" \
			  -d "{\"username\": \"$HOOKNAME\", \"content\": \"IP "$DOMAIN" "$OLDIP4" AND "$OLDIP6" Change To "$RR4" AND "$RR6" Now\"}" \
			  $URL
			exit 0
		fi
	fi
	if [ "$RR4" != "$OLDIP4" ]; then
echo "RR4 Only Change"
echo $RR4
nsupdate -d -v -k $DNSKEY << EOF
server $NS
zone $ZONE
update delete $DOMAIN A
update add $DOMAIN $TTL A $RR4
send
EOF
		if [ ! -z "$URL" ]; then
			curl \
			  -H "Content-Type: application/json" \
			  -d "{\"username\": \"$HOOKNAME\", \"content\": \"IP "$DOMAIN" "$OLDIP4" Change To "$RR4" Now\"}" \
			  $URL
			exit 0
		fi
	fi

	if [ "$RR6" != "$OLDIP6" ]; then
echo "RR6 Only Change"
echo $RR6
nsupdate -d -v -k $DNSKEY << EOF
server $NS
zone $ZONE
update delete $DOMAIN AAAA
update add $DOMAIN $TTL AAAA $RR6
send
EOF
		if [ ! -z "$URL" ]; then
			curl \
			  -H "Content-Type: application/json" \
			  -d "{\"username\": \"$HOOKNAME\", \"content\": \"IP "$DOMAIN" "$OLDIP6" Change To "$RR6" Now\"}" \
			  $URL
			exit 0
	        fi
	fi
	echo "IP 4 AND 6 Not Change..."
	exit 0
}

if [ "$IPv" = "both" ]; then
	INET_BOTH
elif [ "$IPv" = "4" ]; then
        INET_4
elif [ "$IPv" = "6" ]; then
        INET_6
else
	echo "ERROR: Allow Only IPv4 OR IPv6 OR BOTH"
	exit 1
fi
