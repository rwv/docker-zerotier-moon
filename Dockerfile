ARG ZT_VERSION=1.14.2

FROM zerotier/zerotier:${ZT_VERSION}

LABEL maintainer="seedgou <seedgou@gmail.com>"

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
EXPOSE 9993/udp

ENTRYPOINT ["/startup.sh"]
