#!/bin/sh

# usage ./startup.sh -4 1.2.3.4

# TODO
# IPv6

port=9994

while getopts "4:6" arg 
do
        case $arg in
             4)
                ipv4_address="$OPTARG"
                echo "ipv4 address: $ipv4_address"
                ;;
             6)
                ipv6_address="$OPTARG"
                echo "ipv6 address: $ipv6_address"
                ;;
             ?)
            echo "unknown argument"
        exit 1
        ;;
        esac
done

if [ -d "/one/moons.d" ] # check if the moons conf has generated
then
        moon_id=$(cat /one/identity.public | cut -d ':' -f1)
        echo "Your ZeroTier moon id is \033[0;31m$moon_id\033[0m, you could orbit moon using \033[0;31m\"zerotier-cli orbit $moon_id $moon_id\"\033[0m"
        /var/lib/zerotier-one/zerotier-one -U /one -p$port
else
        nohup /var/lib/zerotier-one/zerotier-one -U /one -p$port >/dev/null 2>&1 &
        # Waiting for identity generation...'
        while [ ! -f /one/identity.secret ]; do
	        sleep 1
        done
        /var/lib/zerotier-one/zerotier-idtool initmoon /one/identity.public >>/one/moon.json
        sed -i 's/"stableEndpoints": \[\]/"stableEndpoints": ["'$ipv4_address'\/'$port'"]/g' /one/moon.json
        /var/lib/zerotier-one/zerotier-idtool genmoon /one/moon.json
        mkdir /one/moons.d
        mv *.moon /one/moons.d/
        pkill zerotier-one
        moon_id=$(cat /one/moon.json | grep \"id\" | cut -d '"' -f4)
        echo "Your ZeroTier moon id is \033[0;31m$moon_id\033[0m, you could orbit moon using \033[0;31m\"zerotier-cli orbit $moon_id $moon_id\"\033[0m"
        /var/lib/zerotier-one/zerotier-one -U /one -p$port
fi