ARG ZT_VERSION=1.6.5

FROM alpine:latest

LABEL maintainer="seedgou <seedgou@gmail.com>"

RUN apk add --no-cache zerotier-one=${ZT_VERSION}

COPY startup.sh /startup.sh
EXPOSE 9993/udp

ENTRYPOINT ["/startup.sh"]
