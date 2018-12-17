FROM alpine:3.6
LABEL Maintainer="Frank Wolf <FrankWolf@gmx.de>" \
Name="telegram-cli" \
Version=1.4.1

# see https://github.com/Goty/tg/

RUN apk add --no-cache --virtual build-dependencies \
build-base \
git \
jansson-dev \
libconfig-dev \
libevent-dev \
make \
openssl-dev \
readline-dev \
lua5.1-dev \
zlib-dev \
&& cd /tmp \
&& git clone --recursive https://github.com/Goty/tg.git \
&& cd tg \
&& rm -rf tgl \
&& git clone --recursive https://github.com/Goty/tgl.git \
&& ./configure \
&& make \
&& cp /tmp/tg/bin/* /usr/local/bin \
&& rm -rf /tmp/tg \
&& rm -rf /var/lib/apt/lists/* \
&& apk del build-dependencies

RUN apk add --no-cache \
jansson \
libconfig \
libcrypto1.0 \
libevent \
libssl1.0 \
lua5.1 \
readline \
&& rm -rf /var/lib/apt/lists/*

ARG USER=user
ARG UID=1000
ENV USER $USER

RUN mkdir /home/$USER \
&& addgroup -g $UID -S $USER \
&& adduser -u $UID -D -S -G $USER $USER \
&& chown -R $USER:$USER /home/$USER

USER $USER

VOLUME /home/$USER/.telegram-cli

CMD []
ENTRYPOINT ["/usr/local/bin/telegram-cli"]
