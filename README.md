alpine-l2tp-vpn-deluge-browser
---
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/wuamin/alpine-l2tp-vpn-deluge-browser)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/wuamin/alpine-l2tp-vpn-deluge-browser)
[![](https://images.microbadger.com/badges/image/wuamin/alpine-l2tp-vpn-deluge-browser.svg)](https://microbadger.com/images/wuamin/alpine-l2tp-vpn-deluge-browser "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/wuamin/alpine-l2tp-vpn-deluge-browser.svg)](https://microbadger.com/images/wuamin/alpine-l2tp-vpn-deluge-browser "Get your own version badge on microbadger.com")
![GitHub](https://img.shields.io/github/license/wuamin/alpine-l2tp-vpn-deluge-browser)


An Alpine based docker image to offer [deluge](https://deluge-torrent.org/)-[web](https://dev.deluge-torrent.org/wiki/UserGuide/ThinClient#WebUI) client with an [L2TP](https://github.com/xelerance/xl2tpd) over IPsec VPN client w/ PSK (and optionally Socks5, [Openbox](http://openbox.org/wiki/Main_Page), VNC, [Firefox](https://www.mozilla.org/en-US/firefox) Browser) within the container.

## Config

Setup environment variables for your credentials and config:

```bash
export VPN_SERVER='YOUR VPN SERVER IP OR FQDN'
export VPN_PSK='my pre shared key'
export VPN_USERNAME='myuser@myhost.com'
export VPN_PASSWORD='mypass'
export SCOKS5_ENABLE=0
export SCOKS5_PORT=1080
export DELUGED_USER=myuser
export DELUGED_PASS=mypass
export DELUGED_PORT=58846 # Default port
export DELUGE_WEB_PORT=8112 # Default port
export DELUGE_CONFIG='/some/path/deluge'
export DELUGE_DOWNLOAD='/some/path/downloads'
```
`DELUGED_USER`, `DELUGED_PASS` and `DELUGED_PORT` are to connect with [Thin-client mode](https://dev.deluge-torrent.org/wiki/UserGuide/ThinClient#GTKUI) (GTK UI) or [deluge-console](https://dev.deluge-torrent.org/wiki/UserGuide/ThinClient#Console)

`DELUGE_WEB_PORT` is for accessing from browser to [webUI](https://dev.deluge-torrent.org/wiki/UserGuide/ThinClient#WebUI) or [Browser Plugins](https://dev.deluge-torrent.org/wiki/Plugins#BrowserPlugins).

**NOTE**: Defalt password for deluge-web is `deluge`. after connecting to WebUI, you can change WebUI password from preferences.

`DELUGE_DOWNLOAD` will be mounted to `/home/deluge/Downloads` which is default deluge download folder. This let you download your files straightly out of container.

`DELUGE_CONFIG` is path for keeping deluge configuration and sessions files. This will let you recreate container and continue to activity without losing any data our configuration.


## Run
`USERID` will make sure the uid of the deluge user within container is the same as yours, so configuration and download files will have the proper ownership.
Now run it (you can daemonize of course after debugging):
```bash
docker run --rm -it --privileged \
           -e $(id -u):USERID \
           -e VPN_SERVER \
           -e VPN_PSK \
           -e VPN_USERNAME \
           -e VPN_PASSWORD \
           -e SCOKS5_ENABLE \
           -e DELUGED_USER=myuser \
           -e DELUGED_PASS=mypass \
           -p ${DELUGED_PORT}:58846 \
           -p ${DELUGE_WEB_PORT}:8112 \
           -v "${DELUGE_CONFIG}":/home/deluge/.config/deluge \
           -v "${DELUGE_DOWNLOAD}":/home/deluge/Downloads \
              wuamin/alpine-l2tp-vpn-deluge-browser
```
You can use `.env` file:
```bash
source .env;docker run --rm -it --privileged -e $(id -u):USERID --env-file .env -p ${DELUGED_PORT}:58846 -p ${DELUGE_WEB_PORT}:8112 -p ${SCOKS5_PORT}:1080 -p ${GUI_VNC_PORT}:5900 -v "${DELUGE_CONFIG}":/home/deluge/.config/deluge -v "${DELUGE_DOWNLOAD}":/home/deluge/Downloads wuamin/alpine-l2tp-vpn-deluge-browser
```

## Socks5
If you set `SCOKS5_ENABLE` to `1` (default value is `0`), the container will run `dante` at startup to provide a socks5 proxy (via VPN). Don not forget to expose port 1080.
```bash
docker run --rm -it --privileged \
           -e $(id -u):USERID \
           -e VPN_SERVER \
           -e VPN_PSK \
           -e VPN_USERNAME \
           -e VPN_PASSWORD \
           -e SCOKS5_ENABLE \
           -p ${SCOKS5_PORT}:1080 \
           -e DELUGED_USER=myuser \
           -e DELUGED_PASS=mypass \
           -p ${DELUGED_PORT}:58846 \
           -p ${DELUGE_WEB_PORT}:8112 \
           -v "${DELUGE_CONFIG}":/home/deluge/.config/deluge \
           -v "${DELUGE_DOWNLOAD}":/home/deluge/Downloads \
           -v "${GUI_FIREFOX_USERDIR}":/home/deluge/.mozilla \
              wuamin/alpine-l2tp-vpn-deluge-browser
```

## GUI
If you set `GUI_ENABLE` to `1` (default value is `0`), the container will run [Openbox](http://openbox.org/wiki/Main_Page) on [xvfb](https://linux.die.net/man/1/xvfb). 
By changing `GUI_RESOLUTION`, you can modify xvfb resoulation and color-depth. (`[width]x[height]x[depth]`)

If you enable GUI, by default x11vnc will run too, unless you set `GUI_VNC_ENABLE` to `0`.

Container come with a [Firefox](https://www.mozilla.org/en-US/firefox) installed. 
By default firefox will be updated on startup and can be disabled by setting `GUI_FORCE_UPDATE_FIREFOX` to `0`. 
`GUI_FIREFOX_USERDIR` let you define a path to mount into container for keeping your browser data.


```bash
export GUI_ENABLE=1
export GUI_RESOLUTION=1920x1080x24
export GUI_VNC_ENABLE=1
export GUI_VNC_PORT=5900
export GUI_FIREFOX_USERDIR='/some/path/mozilla'
export GUI_FORCE_UPDATE_FIREFOX=1

docker run --rm -it --privileged \
           -e $(id -u):USERID \
           -e VPN_SERVER \
           -e VPN_PSK \
           -e VPN_USERNAME \
           -e VPN_PASSWORD \
           -e SCOKS5_ENABLE \
           -p ${SCOKS5_PORT}:1080 \
           -e DELUGED_USER=myuser \
           -e DELUGED_PASS=mypass \
           -p ${DELUGED_PORT}:58846 \
           -p ${DELUGE_WEB_PORT}:8112 \
           -p ${GUI_VNC_PORT}:5900 \
           -v "${DELUGE_CONFIG}":/home/deluge/.config/deluge \
           -v "${DELUGE_DOWNLOAD}":/home/deluge/Downloads \
           -v "${GUI_FIREFOX_USERDIR}":/home/deluge/.mozilla \
              wuamin/alpine-l2tp-vpn-deluge-browser
```


## Debugging
On your VPN client localhost machine you may need to `sudo modprobe af_key`
if you're getting this error when starting:
```
pluto[17]: No XFRM/NETKEY kernel interface detected
pluto[17]: seccomp security for crypto helper not supported
```

