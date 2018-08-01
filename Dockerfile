FROM ubuntu:18.04

ADD start.sh /start
COPY sources.list /etc/apt/sources.list
RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install -y --no-install-recommends autoconf automake make gcc unzip wget g++ libtool cmake\
    && apt-get install -y --no-install-recommends  libevent-dev libssl-dev uuid-dev libonig-dev librocksdb-dev libunivalue-dev\
    && apt-get install -y --no-install-recommends net-tools nodejs gdb vim\
    && rm -rf /var/lib/apt/lists

RUN echo "Install evhtp" \
    && wget --no-check-certificate https://github.com/criticalstack/libevhtp/archive/1.2.16.tar.gz -O /tmp/evhtp.tar.gz \
    && cd /tmp && tar zxvf evhtp.tar.gz && cd /tmp/libevhtp-1.2.16/build \
    && cmake .. && make && make install 

RUN echo "Install cpptrade" \
    && wget --no-check-certificate  https://codeload.github.com/bloq/cpptrade/zip/master -O /tmp/cpptrade.zip \
    && cd /tmp && unzip cpptrade.zip && rm cpptrade.zip

COPY Makefile.am /tmp/cpptrade-master/Makefile.am

RUN cd /tmp/cpptrade-master/\
    && ./autogen.sh && ./configure && make && make install \
    && mkdir -p /etc/cpptrde \
    && cp test-config-obsrv.json /etc/cpptrde/config-obsrv.json \
    && chmod +x /start 

EXPOSE 7979
CMD  ["/start"]
 
