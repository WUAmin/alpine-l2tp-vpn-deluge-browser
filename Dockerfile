FROM wuamin/alpine-l2tp-vpn-client

ENV LANG C.UTF-8
ENV USERID 1000

RUN set -x && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache deluge \
    && rm -rf /tmp/* \
    mkdir -pv /home/deluge/.config


COPY startup2.sh /
COPY start-deluged.sh /

CMD ["/startup2.sh"]
