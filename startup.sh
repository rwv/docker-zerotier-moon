#!/bin/sh

set -eu

# usage ./startup.sh -4 1.2.3.4 -6 2001:abcd:abcd::1 -p 9993

moon_port=9993 # default ZeroTier moon port
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"

while getopts "4:6:p:" arg # handle args
do
        case $arg in
             4)
                ipv4_address="$OPTARG"
                echo "IPv4 address: $ipv4_address"
                ;;
             6)
                ipv6_address="$OPTARG"
                echo "IPv6 address: $ipv6_address"
                ;;
             p)
                moon_port="$OPTARG"
                echo "Moon port: $moon_port"
                ;;
             ?)
            echo "unknown argument"
        exit 1
        ;;
        esac
done

zt_one_bin=$(command -v zerotier-one || true)
zt_idtool_bin=$(command -v zerotier-idtool || true)

if [ -z "$zt_one_bin" ] || [ -z "$zt_idtool_bin" ]
then
        echo "ZeroTier binaries not found in PATH."
        exit 1
fi

stableEndpointsForSed=""
if [ -z "${ipv4_address+x}" ]
then # ipv4 address is not set
        if [ -z "${ipv6_address+x}" ]
        then # ipv6 address is not set
                echo "Please set IPv4 address or IPv6 address."
                exit 0
        else # ipv6 address is set
                stableEndpointsForSed="\"$ipv6_address\/$moon_port\""
        fi
else # ipv4 address is set
        if [ -z "${ipv6_address+x}" ]
        then # ipv6 address is not set
                stableEndpointsForSed="\"$ipv4_address\/$moon_port\""
        else # ipv6 address is set
                stableEndpointsForSed="\"$ipv4_address\/$moon_port\",\"$ipv6_address\/$moon_port\""
        fi
fi

show_moon_id() {
        moon_id="$1"
        printf 'Your ZeroTier moon id is \033[0;31m%s\033[0m, you could orbit moon using \033[0;31m"zerotier-cli orbit %s %s"\033[0m\n' "$moon_id" "$moon_id" "$moon_id"
}

if [ -d "/var/lib/zerotier-one/moons.d" ] # check if the moons conf has generated
then
        moon_id=$(cat /var/lib/zerotier-one/identity.public | cut -d ':' -f1)
        show_moon_id "$moon_id"
        exec "$zt_one_bin"
else
        "$zt_one_bin" >/dev/null 2>&1 &
        zt_pid=$!
        # Waiting for identity generation...'
        while [ ! -f /var/lib/zerotier-one/identity.secret ]; do
	        sleep 1
        done
        "$zt_idtool_bin" initmoon /var/lib/zerotier-one/identity.public >/var/lib/zerotier-one/moon.json
        sed -i 's/"stableEndpoints": \[\]/"stableEndpoints": ['$stableEndpointsForSed']/g' /var/lib/zerotier-one/moon.json
        "$zt_idtool_bin" genmoon /var/lib/zerotier-one/moon.json >/dev/null
        mkdir -p /var/lib/zerotier-one/moons.d
        mv *.moon /var/lib/zerotier-one/moons.d/
        kill "$zt_pid" 2>/dev/null || true
        wait "$zt_pid" 2>/dev/null || true
        moon_id=$(cat /var/lib/zerotier-one/moon.json | grep \"id\" | cut -d '"' -f4)
        show_moon_id "$moon_id"
        exec "$zt_one_bin"
fi
