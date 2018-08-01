FROM ubuntu:18.04 as base
COPY sources.list /etc/apt/sources.list
RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install -y --no-install-recommends libevent-dev libssl-dev uuid-dev libonig-dev librocksdb-dev libunivalue-dev \
    && rm -rf /var/lib/apt/lists

FROM base as builder
RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install -y --no-install-recommends libtool autoconf automake make gcc unzip wget g++ cmake
RUN set -o errexit -o nounset \
    && echo "Install evhtp" \
    && wget --no-check-certificate https://github.com/criticalstack/libevhtp/archive/1.2.16.tar.gz -O /tmp/evhtp.tar.gz \
    && cd /tmp && tar zxvf evhtp.tar.gz && cd /tmp/libevhtp-1.2.16/build \
    && cmake .. && make && make install 
RUN set -o errexit -o nounset \
    && echo "Install cpptrade" \
    && wget --no-check-certificate  https://codeload.github.com/bloq/cpptrade/zip/master -O /tmp/cpptrade.zip \
    && cd /tmp && unzip cpptrade.zip && rm cpptrade.zip
COPY Makefile.am /tmp/cpptrade-master/Makefile.am
RUN set -o errexit -o nounset \
    && cd /tmp/cpptrade-master/\
    && ./autogen.sh && ./configure && make

FROM base
COPY --from=builder /usr/local/lib/libevhtp.a /usr/local/lib/
COPY --from=builder /usr/local/include/evhtp/ /usr/local/include/evhtp.h /usr/local/include/
COPY --from=builder /usr/local/lib/pkgconfig/evhtp.pc /usr/local/lib/pkgconfig/
COPY --from=builder /tmp/cpptrade-master/obdb /tmp/cpptrade-master/obsrv /usr/local/sbin/
ADD start.sh /start
RUN mkdir -p /etc/cpptrde/ \
    && echo "{}" > /etc/cpptrde/config-obsrv.json \
    && chmod +x /start

EXPOSE 7979
CMD ["/start"]
