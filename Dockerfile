FROM ubuntu:18.04 as base
RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install -y --no-install-recommends libtool libevent-dev libssl-dev uuid-dev libevhtp-dev librocksdb-dev libunivalue-dev \
    && rm -rf /var/lib/apt/lists

FROM base as builder
RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install -y --no-install-recommends autoconf automake make gcc unzip wget g++ \
    \
    && echo "Install cpptrade" \
    && wget --no-check-certificate  https://codeload.github.com/bloq/cpptrade/zip/master -O /tmp/cpptrade.zip \
    && cd /tmp && unzip cpptrade.zip && rm cpptrade.zip && cd cpptrade-master \
    && ./autogen.sh && ./configure && make

FROM base
COPY --from=builder /tmp/cpptrade-master/obdb /tmp/cpptrade-master/obsrv /usr/local/sbin/
ADD start.sh /start
RUN mkdir -p /etc/cpptrde/ \
    && echo "{}" > /etc/cpptrde/config-obsrv.json \
    && chmod +x /start

EXPOSE 7979
CMD ["/start"]
