#!/bin/sh


# Make a user woth same uid
echo "startup2: Create user"
adduser -h /home/deluge -u $USERID --disabled-password deluge
echo "startup2: Change permissions"
chown -hv deluge:deluge /home/deluge /home/deluge/.config
chown -hv deluge:deluge /home/deluge /home/deluge/.config

# Run deluge if DELUGED_ENABLE is 1
if [[ $DELUGED_ENABLE -eq 1 ]];then
  echo "startup2: run start-deluged"
	exec /start-deluged.sh &
else
  echo "startup2: Ignore start-deluged"
fi

exec /startup.sh &
exec /start-gui.sh &
exec sh ################## REMOVE IT
