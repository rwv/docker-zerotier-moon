# Builder script copied and modifed from https://github.com/zerotier/ZeroTierOne/blob/master/ext/installfiles/linux/zerotier-containerized/Dockerfile

FROM debian:stretch as builder

## Supports x86_64, x86, arm, and arm64

RUN apt-get update && apt-get install -y curl gnupg
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 0x1657198823e52a61  && \
    echo "deb http://download.zerotier.com/debian/stretch stretch main" > /etc/apt/sources.list.d/zerotier.list
RUN apt-get update && apt-get install -y zerotier-one=1.2.12

## Build moon

FROM alpine:latest

LABEL version="1.2.12"
LABEL description="An image to create ZeroTier moon in one step."

LABEL maintainer="seedgou <seedgou@gmail.com>"

COPY --from=builder /var/lib/zerotier-one/zerotier-cli /zerotier-cli
COPY --from=builder /var/lib/zerotier-one/zerotier-idtool /zerotier-idtool
COPY --from=builder /usr/sbin/zerotier-one /zerotier-one

COPY startup.sh /startup.sh
EXPOSE 9993/udp

ENTRYPOINT ["/startup.sh"]
