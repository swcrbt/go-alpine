FROM alpine:latest
MAINTAINER swcrbt@test.com

#更换源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add gcc \
    && apk add g++ \
    && apk add musl-dev \
    && apk add make \
    && apk add libstdc++ \
    && apk add perl \
    && apk add tzdata \
    && apk add bash \
    && apk add curl \
    && apk add go

# 时区处理
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo '$TZ' > /etc/timezone

#sql lite
ADD package/sqlite-autoconf-3290000.tar.gz /tmp
RUN cd /tmp/sqlite-autoconf-3290000 \
    && ./configure \
    && make && make install \
    && cd - \
    && rm -rf /tmp/sqlite-autoconf-3290000

#openssl
ADD package/openssl-1.0.2g.tar.gz /tmp
RUN cd /tmp/openssl-1.0.2g \
    && ./Configure linux-x86_64 no-asm shared --prefix=/usr --libdir=lib \
    && make depend && make && make install \
    && cd - \
    && rm -r /tmp/openssl-1.0.2g

RUN echo "export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib" >> /etc/profile \
    && source /etc/profile
    
COPY nsswitch.conf /etc/nsswitch.conf
