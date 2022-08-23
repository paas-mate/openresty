FROM ttbb/compile:c AS openresty

WORKDIR /opt/sh

RUN wget https://openresty.org/download/openresty-1.21.4.1.tar.gz && \
mkdir /opt/sh/aux && \
tar -xf /opt/sh/openresty-1.21.4.1.tar.gz -C /opt/sh/aux --strip-components 1 && \
rm -rf /opt/sh/openresty-1.21.4.1.tar.gz && \
cd /opt/sh/aux && \
dnf install -y perl pcre-devel openssl-devel zlib-devel && \
mkdir /opt/sh/openresty && \
./configure --prefix=/opt/sh/openresty --with-http_stub_status_module && \
gmake && \
gmake install

WORKDIR /opt/sh/openresty

FROM ttbb/base

COPY --from=openresty /opt/sh/openresty /opt/sh/openresty

RUN ln -s /opt/sh/openresty/nginx/sbin/nginx /usr/bin/nginx && \
ln -s /opt/sh/openresty/bin/openresty /usr/bin/openresty && \
ln -s /opt/sh/openresty/bin/resty /usr/bin/resty && \
ln -s /opt/sh/openresty/luajit/bin/luajit /usr/bin/luajit

WORKDIR /opt/sh/openresty
