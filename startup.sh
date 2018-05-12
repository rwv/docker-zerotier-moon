#!/bin/sh

# usage ./startup.sh -4 1.2.3.4 -6 2001:abcd:abcd::1

while getopts "4:6:" arg # handle args
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
             ?)
            echo "unknown argument"
        exit 1
        ;;
        esac
done

stableEndpointsForSed=""
if [ -z ${ipv4_address+x} ]
then # ipv4 address is not set
        if [ -z ${ipv6_address+x} ]
        then # ipv6 address is not set
                echo "Please set IPv4 address or IPv6 address."
                exit 0
        else # ipv6 address is set
                stableEndpointsForSed="\"$ipv6_address\/9993\""
        fi
else # ipv4 address is set
        if [ -z ${ipv6_address+x} ]
        then # ipv6 address is not set
                stableEndpointsForSed="\"$ipv4_address\/9993\""
        else # ipv6 address is set
                stableEndpointsForSed="\"$ipv4_address\/9993\",\"$ipv6_address\/9993\""
        fi
fi

if [ -d "/var/lib/zerotier-one/moons.d" ] # check if the moons conf has generated
then
        moon_id=$(cat /var/lib/zerotier-one/identity.public | cut -d ':' -f1)
        echo -e "Your ZeroTier moon id is \033[0;31m$moon_id\033[0m, you could orbit moon using \033[0;31m\"zerotier-cli orbit $moon_id $moon_id\"\033[0m"
        /zerotier-one
else
        nohup /zerotier-one >/dev/null 2>&1 &
        # Waiting for identity generation...'
        while [ ! -f /var/lib/zerotier-one/identity.secret ]; do
	        sleep 1
        done
        /zerotier-idtool initmoon /var/lib/zerotier-one/identity.public >>/var/lib/zerotier-one/moon.json
        sed -i 's/"stableEndpoints": \[\]/"stableEndpoints": ['$stableEndpointsForSed']/g' /var/lib/zerotier-one/moon.json
        /zerotier-idtool genmoon /var/lib/zerotier-one/moon.json
        mkdir /var/lib/zerotier-one/moons.d
        mv *.moon /var/lib/zerotier-one/moons.d/
        pkill zerotier-one
        moon_id=$(cat /var/lib/zerotier-one/moon.json | grep \"id\" | cut -d '"' -f4)
        echo -e "Your ZeroTier moon id is \033[0;31m$moon_id\033[0m, you could orbit moon using \033[0;31m\"zerotier-cli orbit $moon_id $moon_id\"\033[0m"
        /zerotier-one
fi