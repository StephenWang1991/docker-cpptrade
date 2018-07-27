FROM rastasheep/ubuntu-sshd:18.04

RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install -y --no-install-recommends autoconf automake make gcc unzip wget g++\
    && apt-get install -y --no-install-recommends libtool libevent-dev libssl-dev uuid-dev libevhtp-dev librocksdb-dev libunivalue-dev\
    && apt-get install -y --no-install-recommends net-tools nodejs gdb vim cmake curl\
    && rm -rf /var/lib/apt/lists \
    \
    && echo "Install cpptrade" \
    && wget --no-check-certificate  https://codeload.github.com/bloq/cpptrade/zip/master -O /tmp/cpptrade.zip \
    && cd /tmp && unzip cpptrade.zip && rm cpptrade.zip && cd cpptrade-master \
    && ./autogen.sh && ./configure && make && make install

EXPOSE 7777 7979
 
