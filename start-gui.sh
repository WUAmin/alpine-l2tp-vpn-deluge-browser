#!/bin/sh

# Run xvfb if GUI_ENABLE is 1
if [[ $GUI_ENABLE -eq 1 ]];then
  echo "start-gui: Configure GUI"
  cat << EOF | tee -a /etc/supervisord.conf

[program:xvfb]
command=/usr/bin/Xvfb :1 -screen 0 ${GUI_RESOLUTION}
autorestart=true
user=deluge
priority=100
EOF
  
  # Run VNC if GUI_VNC_ENABLE is 1
  if [[ $GUI_VNC_ENABLE -eq 1 ]];then
    cat << EOF | tee -a /etc/supervisord.conf

[program:x11vnc]
command=/usr/bin/x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :1 -nopw -wait 5 -shared -permitfiletransfer -tightfilexfer -rfbport 5900
user=deluge
autorestart=true
priority=200
EOF
  else
    echo "start-gui: Ignore VNC"
  fi

#   cat << EOF | tee -a /etc/supervisord.conf

# [program:fluxbox]
# environment=HOME="/home/deluge",DISPLAY=":1",USER="deluge"
# command=/usr/bin/fluxbox
# user=deluge
# autorestart=true
# priority=300
# EOF
  # su - deluge -c 'fluxbox-generate_menu'

  cat << EOF | tee -a /etc/supervisord.conf

[program:openbox]
environment=HOME="/home/deluge",DISPLAY=":1",USER="deluge"
command=/usr/bin/openbox
user=deluge
autorestart=true
priority=300
[program:tint2]
environment=HOME="/home/deluge",DISPLAY=":1",USER="deluge"
command=/usr/bin/tint2
user=deluge
autorestart=true
priority=310
EOF


  # Update firefox if GUI_FORCE_UPDATE_FIREFOX is 1
  if [[ $GUI_FORCE_UPDATE_FIREFOX -eq 1 ]];then
    echo "start-gui: make sure browser is up to date"
    apk update
    apk add --no-cache firefox
    rm -rf /tmp/*
  fi


  
  echo "start-gui: run GUI"
  exec /usr/bin/supervisord -c /etc/supervisord.conf
else
  echo "start-gui: Ignore GUI"
fi


