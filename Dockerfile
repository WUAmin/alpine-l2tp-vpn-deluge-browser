FROM wuamin/alpine-l2tp-vpn-client

ENV LANG C.UTF-8
ENV USERID 1000
ENV DELUGED_ENABLE 1
ENV GUI_ENABLE 0
ENV GUI_RESOLUTION 1280x720x24
ENV GUI_VNC_ENABLE 1
ENV GUI_FORCE_UPDATE_FIREFOX 1

RUN set -x \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
                deluge \
                openbox \
                # fbpanel \
                tint2 \
                # fluxbox \
                xterm supervisor sudo xvfb ttf-opensans x11vnc \
                firefox \
    && rm -rf /tmp/* \
    && mkdir -pv /home/deluge/.config \
    && mkdir -pv /home/deluge/.mozilla


COPY supervisord.conf /etc/supervisord.conf
COPY startup2.sh /
COPY start-deluged.sh /
COPY start-gui.sh /

CMD ["/startup2.sh"]
