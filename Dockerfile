FROM debian:stretch as builder

# https://www.zerotier.com/download.shtml

RUN apt-get update && apt-get install -y curl gnupg
RUN curl -s 'https://raw.githubusercontent.com/zerotier/download.zerotier.com/master/htdocs/contact%40zerotier.com.gpg' | gpg --import && \
    if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | bash; fi

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
