# Zero Trust Demo mit JWT-Authentifizierung und OPA

Dieses Projekt demonstriert eine einfache Zero-Trust-Architektur auf Basis von Open Source Tools. Der Zugriff auf eine geschützte Ressource erfolgt nur nach erfolgreicher Authentifizierung über ein JWT (JSON Web Token) und anschließender Policy-Prüfung durch den Open Policy Agent (OPA).

## 🔧 Architekturkomponenten

- **Gateway (PEP):** NGINX mit Lua prüft JWT und fragt OPA zur Autorisierung
- **Policy Decision Point (PDP):** Open Policy Agent (OPA) mit Rego-Policy
- **Backend API:** Kleine Flask-App mit einem geschützten `/data`-Endpoint

## 🔐 Authentifizierung

- Der Benutzer sendet ein JWT im HTTP-Header:
  ```
  Authorization: Bearer <token>
  ```
- Das JWT wird im Gateway validiert (lokale Signaturprüfung mit HS256).
- Claims wie `sub` (Benutzername) und `role` (z. B. admin) werden extrahiert und an OPA zur Autorisierungsentscheidung übergeben.

## 📜 Beispiel-Token (zum Testen)

Header:
```json
{ "alg": "HS256", "typ": "JWT" }
```

Payload:
```json
{ "sub": "alice", "role": "admin", "exp": 1893456000 }
```

Secret: `secret123`

Ein gültiges Token kannst du z. B. unter [jwt.io](https://jwt.io/) erzeugen.

## ▶️ Starten

### Voraussetzungen

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

### Start

```bash
docker-compose up --build
```

Die Dienste laufen dann unter:

- API Gateway: [http://localhost:8080](http://localhost:8080)
- Backend-Service: [http://localhost:9000/data](http://localhost:9000/data)
- OPA API: [http://localhost:8181](http://localhost:8181)

## 🔍 Zugriff testen

```bash
curl -H "Authorization: Bearer <your-JWT>" http://localhost:8080/data
```

Nur gültige, zugelassene Token (z. B. `sub=alice`, `role=admin`) erhalten Zugriff.

## 🛠️ Projektstruktur

```
zero-trust-demo-jwt/
├── backend/         # Flask Backend-App
├── nginx/           # NGINX Gateway + auth.lua
├── opa/             # Rego-Policy
└── docker-compose.yml
```

## 📚 Weiteres

- OPA Docs: https://www.openpolicyagent.org/docs/latest/
- Lua RESTY JWT: https://github.com/SkyLothar/lua-resty-jwt
- OpenResty (NGINX + Lua): https://openresty.org

---

© 2025 – Demo für Zero Trust Architekturen in der IT-Sicherheit
