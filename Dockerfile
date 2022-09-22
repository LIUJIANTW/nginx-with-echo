FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev vim net-tools wget curl git -y

RUN mkdir -p /etc/nginx/nginx-test && \
    cd /etc/nginx/nginx-test && \
    wget http://nginx.org/download/nginx-1.20.0.tar.gz && \
    tar -zxvf nginx-1.20.0.tar.gz && \
    cd nginx-1.20.0 && \
    git clone https://github.com/openresty/echo-nginx-module.git && \
    ./configure --with-http_v2_module --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --with-pcre \
    --add-module=/etc/nginx/nginx-test/nginx-1.20.0/echo-nginx-module && \
    make && make install

RUN rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

ENV PORT=80

CMD ["nginx", "-g", "daemon off;"]
