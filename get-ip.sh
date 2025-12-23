#!/bin/sh
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -n "$0" "$0" "$@" || :

IPSRV_1="https://ifconfig.me/ip"
IPSRV_2="https://ifconfig.co/ip"
IPSRV_3="https://icanhazip.com/"
IPSRV_4="https://myexternalip.com/raw"
IPSRV_5="https://utils.furnu.net/ip"
IPSRV_6="https://ifconfig.io/ip"

# 4 6 all
ADDR_VER="all"

CURL4="curl -s -4 --max-filesize 16 --connect-timeout 10 -m 10"
CURL6="curl -s -6 --max-filesize 40 --connect-timeout 10 -m 10"

######################################################################

# เตรียมสุ่ม seed URL
RANDOM_NUMBER=$(od -An -N2 -i /dev/urandom | awk '{print $1}')
NUMBER_MOD=$(expr $RANDOM_NUMBER % 15)

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

#
# มันมีวิธีย่อให้สั้นกว่านี้ได้อย่างมาก แต่ไม่อยากทำ...มันอ่านแบบเข้าใจยาก แบบนี้ดูแลยากหน่อยนะ แต่เข้าใจง่าย
get_ip_address() {
	# IP 4
	if [ "$ADDR_VER" = "4" ] || [ "$ADDR_VER" = "all" ]; then
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
	if [ "$ADDR_VER" = "6" ] || [ "$ADDR_VER" = "all" ]; then
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

	IP4_NEW_1=$(echo $IP4_NEW_RAW_1 | tr -d '\r\n')
	IP4_NEW_2=$(echo $IP4_NEW_RAW_2 | tr -d '\r\n')

	IP6_NEW_1=$(echo $IP6_NEW_RAW_1 | tr -d '\r\n')
	IP6_NEW_2=$(echo $IP6_NEW_RAW_2 | tr -d '\r\n')
}
get_ip_address


cd $(dirname $0)
if [ "$ADDR_VER" = "4" ] || [ "$ADDR_VER" = "all" ];then
	if ! ./validate-ipv4-6.elf i4 "$IP4_NEW_RAW_1" || ! ./validate-ipv4-6.elf i4 "$IP4_NEW_RAW_2" ;then
		echo " BAD v4"
		exit 1
	fi
fi
if [ "$ADDR_VER" = "6" ] || [ "$ADDR_VER" = "all" ];then
	if ! ./validate-ipv4-6.elf i6 "$IP6_NEW_RAW_1" || ! ./validate-ipv4-6.elf i6 "$IP6_NEW_RAW_2" ;then
		echo " BAD v6"
		exit 1
	fi
fi
echo "$IP4_NEW_RAW_1" > /tmp/_host_address_4.txt.move
echo "$IP6_NEW_RAW_1" > /tmp/_host_address_6.txt.move
mv /tmp/_host_address_4.txt.move /tmp/_host_address_4.txt
mv /tmp/_host_address_6.txt.move /tmp/_host_address_6.txt
echo "Bye"
#!/bin/sh
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -n "$0" "$0" "$@" || :

IPSRV_1="https://ifconfig.me/ip"
IPSRV_2="https://ifconfig.co/ip"
IPSRV_3="https://icanhazip.com/"
IPSRV_4="https://myexternalip.com/raw"
IPSRV_5="https://utils.furnu.net/ip"
IPSRV_6="https://ifconfig.io/ip"

# 4 6 all
ADDR_VER="all"

CURL4="curl -s -4 --max-filesize 16 --connect-timeout 10 -m 10"
CURL6="curl -s -6 --max-filesize 40 --connect-timeout 10 -m 10"

######################################################################

# เตรียมสุ่ม seed URL
RANDOM_NUMBER=$(od -An -N2 -i /dev/urandom | awk '{print $1}')
NUMBER_MOD=$(expr $RANDOM_NUMBER % 15)

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

#
# มันมีวิธีย่อให้สั้นกว่านี้ได้อย่างมาก แต่ไม่อยากทำ...มันอ่านแบบเข้าใจยาก แบบนี้ดูแลยากหน่อยนะ แต่เข้าใจง่าย
get_ip_address() {
	# IP 4
	if [ "$ADDR_VER" = "4" ] || [ "$ADDR_VER" = "all" ]; then
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
	if [ "$ADDR_VER" = "6" ] || [ "$ADDR_VER" = "all" ]; then
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

	IP4_NEW_1=$(echo $IP4_NEW_RAW_1 | tr -d '\r\n')
	IP4_NEW_2=$(echo $IP4_NEW_RAW_2 | tr -d '\r\n')

	IP6_NEW_1=$(echo $IP6_NEW_RAW_1 | tr -d '\r\n')
	IP6_NEW_2=$(echo $IP6_NEW_RAW_2 | tr -d '\r\n')
}
get_ip_address


cd $(dirname $0)
if [ "$ADDR_VER" = "4" ] || [ "$ADDR_VER" = "all" ];then
	if ! ./validate-ipv4-6.elf i4 "$IP4_NEW_RAW_1" || ! ./validate-ipv4-6.elf i4 "$IP4_NEW_RAW_2" ;then
		echo " BAD v4"
		exit 1
	fi
fi
if [ "$ADDR_VER" = "6" ] || [ "$ADDR_VER" = "all" ];then
	if ! ./validate-ipv4-6.elf i6 "$IP6_NEW_RAW_1" || ! ./validate-ipv4-6.elf i6 "$IP6_NEW_RAW_2" ;then
		echo " BAD v6"
		exit 1
	fi
fi
echo "$IP4_NEW_RAW_1" > /tmp/_host_address_4.txt.move
echo "$IP6_NEW_RAW_1" > /tmp/_host_address_6.txt.move
mv /tmp/_host_address_4.txt.move /tmp/_host_address_4.txt
mv /tmp/_host_address_6.txt.move /tmp/_host_address_6.txt
echo "Bye"
