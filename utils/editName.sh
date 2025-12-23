#!/bin/sh
# TO GET TSIG
# tsig-keygen -a HMAC-SHA512 keyname >> keyfile

# /PATH/TO/KEY/FILE	# Leave blank if not used
TSIG=""
# ns1.example.net, 123.45.67.89
NS=""

echo "[A] Add RR\n[U] Update RR [Delete and Add]\n[D] Delete RR By Name\n[P] Delete All RR By QNAME/Type\n[Cancel] CTRL + C"
read -p ">>> " MENU
read -p "Enter ZONE name (APEX ZONE example.net): " ZONE
read -p "Enter QNAME (myhome.example.net, example.net):" QNAME

NO_TSIG() {
case $MENU in
# Add RR
	A | a)
        	read -p "Enter Type:" TYPE
		read -p "Enter RR:" RR
		read -p "Enter TTL:" TTL
		if [ -z "$TTL" ] || [ -z "$TYPE" ] || [ -z "$RR" ]; then
			echo "Req Type, RR, TTL"
			exit 1
		fi
nsupdate -v -D << EOF
server $NS
zone $ZONE
update add $QNAME $TTL $TYPE $RR
send
EOF
		exit 0
	;;
# Delete RR By QName
	D | d)
		read -p "Enter Type:" TYPE
		read -p "Enter RR:" RR
		if [ -z "$TYPE" ] || [ -z "$RR" ]; then
			echo "Req Type, RR"
			exit 1
		fi
nsupdate -v -D << EOF
server $NS
zone $ZONE
update delete $QNAME $TYPE $RR
send
EOF
	exit 0
	;;
# Update RR By QName
	U | u)
		read -p "Enter Type:" TYPE
		read -p "Enter Old RR:" RR
		read -p "Enter New RR:" RRADD
		read -p "Enter TTL:" TTL

		if [ -z "$TTL" ] || [ -z "$TYPE" ] || [ -z "$RR" ] || [ -z "$RRADD" ]; then
			echo "Req Type, RR, New RR, TTL"
			exit 1
		fi
nsupdate -v -D << EOF
server $NS
zone $ZONE
update delete $QNAME $TTL $TYPE $RR
update add $QNAME $TTL $TYPE $RRADD
send
EOF
		exit 0
	;;
# Delete ALL RR By QName
	P | p)
		read -p "Enter Type:" TYPE
		if [ -z "$TYPE" ] ; then
			echo "Req Type, RR"
			exit 1
		fi
nsupdate -v -D << EOF
server $NS
zone $ZONE
update delete $QNAME $TYPE $RR
send
EOF
	exit 0
	;;
        *)
		echo "Error Exit..."
		exit 1
	;;
esac
exit 0
}

IS_TSIG() {
case $MENU in
# Add RR
	A | a)
        	read -p "Enter Type:" TYPE
		read -p "Enter RR:" RR
		read -p "Enter TTL:" TTL
		if [ -z "$TTL" ] || [ -z "$TYPE" ] || [ -z "$RR" ]; then
			echo "Req Type, RR, TTL"
			exit 1
		fi
nsupdate -v -D -k "$TSIG" << EOF
server $NS
zone $ZONE
update add $QNAME $TTL $TYPE $RR
send
EOF
		exit 0
	;;
# Delete RR By QName
	D | d)
		read -p "Enter Type:" TYPE
		read -p "Enter RR:" RR
		if [ -z "$TYPE" ] || [ -z "$RR" ]; then
			echo "Req Type, RR"
			exit 1
		fi
nsupdate -v -D -k "$TSIG" << EOF
server $NS
zone $ZONE
update delete $QNAME $TYPE $RR
send
EOF
	exit 0
	;;
# Update RR By QName
	U | u)
		read -p "Enter Type:" TYPE
		read -p "Enter Old RR:" RR
		read -p "Enter New RR:" RRADD
		read -p "Enter TTL:" TTL

		if [ -z "$TTL" ] || [ -z "$TYPE" ] || [ -z "$RR" ] || [ -z "$RRADD" ]; then
			echo "Req Type, RR, New RR, TTL"
			exit 1
		fi
nsupdate -v -D -k "$TSIG" << EOF
server $NS
zone $ZONE
update delete $QNAME $TTL $TYPE $RR
update add $QNAME $TTL $TYPE $RRADD
send
EOF
		exit 0
	;;
# Delete ALL RR By QName
	P | p)
		read -p "Enter Type:" TYPE
		if [ -z "$TYPE" ] ; then
			echo "Req Type, RR"
			exit 1
		fi
nsupdate -v -D -k "$TSIG" << EOF
server $NS
zone $ZONE
update delete $QNAME $TYPE $RR
send
EOF
	exit 0
	;;
        *)
		echo "Error Exit..."
		exit 1
	;;
esac
exit 0
}

if [ -z "$ZONE" ] || [ -z "$QNAME" ] || [ -z "$NS" ]; then
	echo "Req ZONE QNAME NS"
	exit 1
elif [ -z "$TSIG" ]; then
	echo "No TSIG mode"
	NO_TSIG
else
	IS_TSIG
fi
