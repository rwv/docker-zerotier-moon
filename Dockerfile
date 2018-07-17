FROM zerotier/zerotier-containerized

LABEL maintainer="seedgou <seedgou@gmail.com>"

RUN ln -sf /zerotier-one /zerotier-idtool
COPY startup.sh /startup.sh
EXPOSE 9993/udp

ENTRYPOINT ["/startup.sh"]