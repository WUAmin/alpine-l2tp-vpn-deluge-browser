#!/bin/sh

# Wait for VPN if VPN_ENABLE is 1
if [[ $VPN_ENABLE -eq 1 ]];then
  # Wait for vpn to create ppp0 network interface
  echo "start-deluge: waiting for ppp0";
  while ! route | grep  ppp0 > /dev/null; do sleep 1; done
  # make sure vpn is connected
  echo "start-deluge: ppp0 found.";
  sleep 5
else
  echo "start-deluge: Nothing to wait for. bacause VPN_ENABLE=$VPN_ENABLE";
fi

# Add Deluged user/pass
if [ -f "/home/deluge/.config/deluge/auth" ]; then
  echo "start-deluge: configuring deluge"
  su - deluge -c 'sed -i -n "1p" /home/deluge/.config/deluge/auth'
  su - deluge -c "echo '${DELUGED_USER}:${DELUGED_PASS}:10' >> /home/deluge/.config/deluge/auth"
else
  echo "start-deluge: configuring deluge ignored. '/home/deluge/.config/deluge/auth' does not exist!"
fi

# Run deluged and deluge-web
echo "start-deluge: Run deluged";
su - deluge -c 'deluged -u 0.0.0.0 -L error -d' &
echo "start-deluge: Run deluge-web";
su - deluge -c 'deluge-web -i 0.0.0.0 -L error -p 8112 -d'