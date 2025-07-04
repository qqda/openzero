FROM openresty/openresty:alpine

# Installiere benötigte Tools
RUN apk add --no-cache \
    curl \
    git \
    unzip \
    build-base \
    lua-dev \
    openssl-dev

# Luarocks manuell installieren (stabil & unabhängig vom Alpine-Paketmanager)
ENV LUAROCKS_VERSION=3.9.2

RUN curl -sSL https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz | tar -xz && \
    cd luarocks-${LUAROCKS_VERSION} && \
    ./configure --with-lua=/usr/local/openresty/luajit \
                --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 && \
    make && make install && \
    cd .. && rm -rf luarocks-${LUAROCKS_VERSION}

# Installiere lua-resty-http
RUN luarocks install lua-resty-http

# Setze Arbeitsverzeichnis und kopiere Konfigurationen
WORKDIR /usr/local/openresty/nginx/conf
COPY nginx.conf nginx.conf
COPY auth.lua auth.lua