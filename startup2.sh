#!/bin/sh


# Make a user woth same uid
adduser -h /home/deluge -u $USERID --disabled-password deluge
chown -hv deluge:deluge /home/deluge /home/deluge/.config

exec /start-deluged.sh &
exec /startup.sh
