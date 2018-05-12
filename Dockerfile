FROM zerotier/zerotier-containerized

RUN ln -sf /zerotier-one /zerotier-idtool
COPY startup.sh /startup.sh
EXPOSE 9993
EXPOSE 9993/udp

ENTRYPOINT ["/startup.sh"]