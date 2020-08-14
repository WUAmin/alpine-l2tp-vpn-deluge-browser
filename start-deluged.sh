#!/bin/sh

# Wait for vpn to create ppp0 network interface
while ! route | grep  ppp0 > /dev/null; do echo "start-deluge: waiting for ppp0"; sleep 1; done
# make sure vpn is connected
sleep 5
# Add Deluged user/pass
su - deluge -c 'sed -i -n "1p" /home/deluge/.config/deluge/auth'
su - deluge -c "echo '${DELUGED_USER}:${DELUGED_PASS}:10' >> /home/deluge/.config/deluge/auth"
# Run deluged and deluge-web
su - deluge -c 'deluged -u 0.0.0.0 -L error -d' &
su - deluge -c 'deluge-web -i 0.0.0.0 -L error -p 8112 -d'