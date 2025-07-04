# Anforderungen für das Projekt `zero-trust-demo-sdp`

Diese Datei beschreibt alle Systemvoraussetzungen und technischen Abhängigkeiten für das vollständige Zero Trust Demo-System inkl. OPA, Logging und SDP-Erweiterung.

---

## ✅ Technische Anforderungen

### 1. Containerumgebung
- Docker ≥ 20.10
- Docker Compose ≥ 1.27

### 2. Lokale Python-Umgebung (optional)
Falls du das Flask-Backend lokal ohne Docker starten möchtest:
- Python ≥ 3.8
- Paket: `flask`

### 3. Benötigte Docker-Images
| Komponente           | Image                                 |
|----------------------|----------------------------------------|
| OPA                  | `openpolicyagent/opa:latest`           |
| NGINX mit Lua        | `openresty/openresty:alpine`           |
| Flask Backend        | lokal gebaut über `backend/Dockerfile` |
| Loki                 | `grafana/loki:2.9.0`                   |
| Promtail             | `grafana/promtail:2.9.0`               |
| Grafana              | `grafana/grafana:latest`               |

---

## 🧪 Testzugriff
- cURL oder REST-Client
- JWT mit HS256, signiert mit `secret123`
- Beispiel-Header:
  ```http
  Authorization: Bearer <token>
  ```

---

## 🔍 Optional – Logging & Dashboard

- Grafana Web-UI: Port **3000**
- Loki Log-Ingestion: Port **3100**
- Volumes:
  - `./logs:/var/log/nginx`
  - `./grafana-storage:/var/lib/grafana`

---

## 🔐 Optional – OpenZiti SDP-Erweiterung

### Zusätzliche Tools:
- Ziti Controller & Edge Router
- Ziti CLI (`ziti`)
- Ziti Tunnel / Desktop Edge

### Konfigurationsdatei:
- `ziti-minimal-config.json` enthält Beispiel für Zugriffskontrolle:
  - Nur `alice` darf auf `backend-api` zugreifen

---

## 🔁 Genutzte Ports

| Dienst       | Port     | Beschreibung               |
|--------------|----------|----------------------------|
| API Gateway  | 8080     | Zugriff mit JWT + Lua      |
| Backend API  | 9000     | Geschützte Ressource       |
| OPA API      | 8181     | Policy Decision Point      |
| Grafana      | 3000     | Dashboard UI               |
| Loki         | 3100     | Log-Datenquelle            |

---

## 📂 Verzeichnisstruktur (Auszug)
```
zero-trust-demo-sdp/
├── backend/
├── nginx/
├── opa/
├── logs/
├── grafana/
├── promtail-config.yaml
├── docker-compose.yml
├── monitor-alice.sh
├── ziti-minimal-config.json
├── README_SDP.md
└── requirements.md
```

---

© 2025 – Zero Trust Demo mit SDP, Logging, OPA & JWT
