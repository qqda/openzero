# 🛠️ How-To: LuaSocket (socket.dns) in OpenResty-Gateway installieren und verwenden

Dieses How-To zeigt dir, wie du die LuaSocket-Bibliothek (`socket.dns`) in deinem OpenResty-Gateway integrierst, um z.B. Hostnamen wie `opa` zur IP aufzulösen.

---

## 📁 Schritt 1: Dockerfile vorbereiten

Speichere das folgende Dockerfile unter `nginx/Dockerfile`:

```dockerfile
FROM openresty/openresty:1.21.4.1-1-bullseye

# Systempakete für Build und luarocks
RUN apt-get update && \
    apt-get install -y git curl unzip build-essential libssl-dev luarocks

# Installation der LuaSocket-Bibliothek
RUN luarocks install luasocket

# Arbeitsverzeichnis und Konfigurationen kopieren
WORKDIR /usr/local/openresty/nginx/conf

COPY nginx.conf nginx.conf
COPY auth.lua auth.lua
```

---

## ⚙️ Schritt 2: docker-compose.yml anpassen

Stelle sicher, dass dein `gateway`-Service so aussieht:

```yaml
gateway:
  build: ./nginx
  ports:
    - "8080:80"
  volumes:
    - ./logs:/var/log/nginx
```

---

## 🚀 Schritt 3: Gateway neu bauen und starten

```bash
docker-compose down
docker-compose up --build
```

---

## 📄 Schritt 4: auth.lua anpassen

Verwende folgende Logik, um die IP von `opa` zur Laufzeit zu ermitteln:

```lua
local dns = require "socket.dns"
local opa_ip = "127.0.0.1"

local resolved, err = dns.toip("opa")
if resolved then
  opa_ip = resolved
end

local opa_url = "http://" .. opa_ip .. ":8181/v1/data/httpapi/authz/allow"
```

---

## ✅ Ergebnis

Dein Gateway kann nun zur Laufzeit die IP von `opa` auflösen und bei Bedarf auch mit anderen OPA-Hosts arbeiten.

