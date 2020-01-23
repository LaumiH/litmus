FROM alpine:3.11.3

RUN apk add --update iptables curl bash

COPY start.sh /start.sh

ENTRYPOINT ["/start.sh"]
