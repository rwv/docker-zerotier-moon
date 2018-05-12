FROM ubuntu:xenial

COPY install.sh /install.sh

RUN apt-get update \
    && apt-get install -y curl \
    && bash /install.sh \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove curl

COPY startup.sh /startup.sh
EXPOSE 9993
EXPOSE 9993/udp

ENTRYPOINT ["/startup.sh"]