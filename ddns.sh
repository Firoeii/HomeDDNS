#!/bin/sh
#
# Edit your zone list below~ (Line 50)
#
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -n "$0" "$0" "$@" || :
set -eu
. "$(dirname "$0")/function.sh"

RECORD_TYPE="all"
NS="ns1.example.net"
TSIG_PATH="/TO/MY/KEY"
DIG_OPTION="+tls-ca @8.8.8.8"
NSUPDATE_CMD="nsupdate -p 53 -v"

# Discord webhook URL
# Leave blank if not used
DISCORD_URL=""
DISCORD_HOOKNAME="MyHome!"

PATH_IP_4="/tmp/_host_address_4.txt"
PATH_IP_6="/tmp/_host_address_6.txt"

HOOK_NOTIFY="0"
if get_ip_address "$RECORD_TYPE" "$PATH_IP_4" "$PATH_IP_6";then
	echo "[ \e[92m OK \e[0m ] Get IP for this host $(cat "${PATH_IP_6}"), $(cat "${PATH_IP_4}")"
else
	echo "[ \e[31mFAIL\e[0m ] get_ip_address"
	HOOK_NOTIFY="1"
fi


while read -r zone qname ttl; do
	if get_ip_address_old "$RECORD_TYPE" "$qname" "$DIG_OPTION";then
		echo "[ \e[92m OK \e[0m ] Get Old IP for $qname"
		if compare_ip_address "$RECORD_TYPE";then
			echo "[ \e[92m OK \e[0m ] IP unchanged $qname, Old addr is: $IP6_OLD, $IP4_OLD"
		else
			echo "[ \e[93mTry\e[0m  ] Update $qname, Old addr is: $IP6_OLD, $IP4_OLD"
			if update_rfc2136 "$NSUPDATE_CMD" "$NS" "$zone" "$qname" "$ttl" "$RECORD_TYPE"; then
				if [ "$HOOK_NOTIFY" != "1" ] && [ "$HOOK_NOTIFY" != "2" ]; then
					HOOK_NOTIFY="3"
				fi
				echo "[ \e[92m OK \e[0m ] NOERROR"
			else
				HOOK_NOTIFY="$?"
				echo "[ \e[31mFAIL\e[0m ] at $qname"
			fi
		fi
	else
		echo "[ \e[31mFAIL\e[0m ] $qname get_ip_address_old (if NXRRSET pls add 0.0.0.0 or ::1 !)"
		HOOK_NOTIFY="1"
	fi
done <<EOF
home.arpa change.me.pls.home.arpa 30
my-example.net my-example.net 60
EOF

if [ -n "$DISCORD_URL" ] && [ "$HOOK_NOTIFY" = "1" ]; then
	curl \
		-H "Content-Type: application/json" \
		-d "$(jq -n --arg username "$DISCORD_HOOKNAME" --arg content \
		"A temporary (network/other) error in update script. If you see it more than many times, it's probably not temporary." \
		'{"username": $username, "content": $content}')" \
		"$DISCORD_URL"
elif [ -n "$DISCORD_URL" ] && [ "$HOOK_NOTIFY" = "2" ]; then
	curl \
		-H "Content-Type: application/json" \
		-d "$(jq -n --arg username "$DISCORD_HOOKNAME" --arg content \
		"nsupdate error fix me pls." \
		'{"username": $username, "content": $content}')" \
		"$DISCORD_URL"
elif [ -n "$DISCORD_URL" ] && [ "$HOOK_NOTIFY" = "3" ]; then
	curl \
		-H "Content-Type: application/json" \
		-d "$(jq -n --arg username "$DISCORD_HOOKNAME" --arg content \
		"Update OK. V6=${IP6_OLD},V4=${IP4_OLD} To V6=${IP6_NEW},V4=${IP4_NEW}" \
		'{"username": $username, "content": $content}')" \
		"$DISCORD_URL"
fi
[ "$HOOK_NOTIFY" = "1" ] && exit 1
[ "$HOOK_NOTIFY" = "2" ] && exit 2
exit 0
