FROM debian:stable-slim

LABEL maintainer.0="PIVX security team <security@pivx.org>" \
  maintainer.1="Marsmensch <marsmensch@pm.me>"

RUN useradd -r pivx \
  && apt-get update -y \
  && apt-get install -y curl gnupg unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex \
  && for key in \
    B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    4B88269ABD8DF332 \
  ; do \	
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done

ENV GOSU_VERSION=1.10

RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

ENV PIVX_VERSION=3.1.0.2
ENV PIVX_DATA=/home/pivx/.pivx \
  PATH=/opt/pivx-3.1.0/bin:$PATH

RUN curl -SLO https://github.com/PIVX-Project/PIVX/releases/download/v${PIVX_VERSION}/pivx-${PIVX_VERSION}-x86_64-linux-gnu.tar.gz \
  && tar -xzf pivx-${PIVX_VERSION}-x86_64-linux-gnu.tar.gz -C /opt \
  && rm *.tar.gz

VOLUME ["/home/pivx/.pivx"]

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# tor control port, p2p testnet port,  
EXPOSE 9051 51474

CMD ["pivxd"]