FROM rastasheep/ubuntu-sshd:18.04


COPY sources.list /etc/apt/sources.list
RUN set -o errexit -o nounset \
    && apt-get update \
    && apt-get install -y --no-install-recommends autoconf automake make gcc unzip wget g++\
    && apt-get install -y --no-install-recommends libtool libevent-dev libssl-dev uuid-dev libonig-dev librocksdb-dev libunivalue-dev\
    && apt-get install -y --no-install-recommends net-tools nodejs gdb vim cmake curl git npm\
    && rm -rf /var/lib/apt/lists

RUN echo "Install evhtp" \
    && wget https://github.com/criticalstack/libevhtp/archive/1.2.16.tar.gz -O /tmp/evhtp.tar.gz \
    && cd /tmp && tar zxvf evhtp.tar.gz && cd /tmp/libevhtp-1.2.16/build \
    && cmake .. && make && make install 

RUN echo "Install cpptrade" \
    && wget --no-check-certificate  https://codeload.github.com/bloq/cpptrade/zip/master -O /tmp/cpptrade.zip \
    && cd /tmp && unzip cpptrade.zip && rm cpptrade.zip

COPY Makefile.am /tmp/cpptrade-master/Makefile.am

RUN cd /tmp/cpptrade-master/\
    && ./autogen.sh && ./configure && make && make install

EXPOSE 7979
 
