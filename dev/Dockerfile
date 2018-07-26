FROM ubuntu:18.04

ADD start.sh /start
RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install -y --no-install-recommends autoconf automake make gcc unzip wget g++ \
    && apt-get install -y --no-install-recommends libtool libevent-dev libssl-dev uuid-dev libevhtp-dev librocksdb-dev libunivalue-dev \
    \
    && echo "Install cpptrade" \
    && wget --no-check-certificate  https://codeload.github.com/bloq/cpptrade/zip/master -O /tmp/cpptrade.zip \
    && cd /tmp && unzip cpptrade.zip && rm cpptrade.zip && cd cpptrade-master \
    && ./autogen.sh && ./configure && make && make install \
    && mkdir -p /etc/cpptrde \
    && cp test-config-obsrv.json /etc/cpptrde/config-obsrv.json \
    && chmod +x /start
RUN apt-get install -y --no-install-recommends net-tools nodejs gdb vim \  
    && rm -rf /var/lib/apt/lists \
EXPOSE 7979
ENTRYPOINT ["/start"]
