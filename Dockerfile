
FROM alpine:edge

ENV MEGA_VERSION=v3.6.5
ENV TRICKLE_VERSION=596bb13f2bc323fc8e7783b8dcba627de4969e07
ENV TRICKLE_SHA256SUM=a4111063d67a3330025eea2f29ebd8c8605e43cc1be0bf384b48f0eab8daf508

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# trickle
#  work around issue #16:  https://github.com/mariusae/trickle/issues/16
RUN set -eux; \
    apk add --no-cache libcurl libtirpc-dev libevent \
    && apk add --no-cache --virtual .build-deps curl make automake autoconf libtool alpine-sdk libevent-dev; \
    cd /tmp; \
    curl -L -o trickle.tgz https://github.com/mariusae/trickle/archive/${TRICKLE_VERSION}.tar.gz; \
    echo "$TRICKLE_SHA256SUM  trickle.tgz" | sha256sum -c -; \
    tar xvzf trickle.tgz; \
    cd "trickle-${TRICKLE_VERSION}"; \
    export CFLAGS=-I/usr/include/tirpc; \
    export LDFLAGS=-ltirpc; \
    autoreconf -if; \
    ./configure; \
    make install-exec-am install-trickleoverloadDATA; \
    rm -rf /tmp/*; \
    apk del .build-deps;

# megasync: https://gist.github.com/MaxKh/ae9ce059899f34ed2bd09e6995a91a08
RUN apk add --no-cache libcurl c-ares crypto++ zlib openssl sqlite-libs readline libsodium libtirpc-dev libevent-dev \
    && apk add --no-cache --virtual .build-deps \
    curl file git make automake autoconf libtool gcc libc-dev g++ curl-dev c-ares-dev crypto++-dev zlib-dev openssl-dev sqlite-dev readline-dev libsodium-dev \
    && git clone -b ${MEGA_VERSION} --depth 1 https://github.com/meganz/sdk.git \
    && cd sdk \
    && ./autogen.sh \
    && CXXFLAGS="-O2 -Wno-deprecated-declarations -Wno-psabi --param ggc-min-expand=1" ./configure --without-freeimage \
    && make examples/megacli  \
    && make examples/megasimplesync \
    && make install \
    && cd ../ \
    && rm -rf sdk \
    && apk del .build-deps
