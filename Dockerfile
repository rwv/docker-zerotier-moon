ARG ALPINE_VERSION=3.14

FROM alpine:${ALPINE_VERSION}

ARG ZT_VERSION=1.6.5-r0

LABEL maintainer="seedgou <seedgou@gmail.com>"

RUN apk add --no-cache zerotier-one=${ZT_VERSION}

COPY startup.sh /startup.sh
EXPOSE 9993/udp

ENTRYPOINT ["/startup.sh"]
