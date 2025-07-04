FROM openresty/openresty:1.21.4.1-1-bullseye

# Installiere systemabhängige Tools
RUN apt-get update && \
    apt-get install -y git curl unzip build-essential libssl-dev luarocks

# Fix: Lua include-Pfad (nicht nötig bei bullseye)
# Installiere lua-resty-http
RUN luarocks install lua-resty-http
# Installation der LuaSocket-Bibliothek
RUN luarocks install luasocket

# Arbeitsverzeichnis und Dateien einfügen
WORKDIR /usr/local/openresty/nginx/conf
COPY nginx.conf nginx.conf
COPY auth.lua auth.lua