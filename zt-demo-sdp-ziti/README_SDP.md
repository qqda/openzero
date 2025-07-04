# SDP-Erweiterung für Zero Trust Demo mit OpenZiti

Dieses Projekt erweitert das Zero Trust Demo-System um ein **Software Defined Perimeter (SDP)** mit **OpenZiti**.

## 🔐 Was ist OpenZiti?

[OpenZiti](https://openziti.io) ist ein Open-Source-Framework, das es ermöglicht, Netzwerkdienste vollständig zu verbergen („dark“) und nur für authentifizierte und autorisierte Clients verfügbar zu machen.

## 🧩 Komponenten

- **Ziti Controller:** Verwalter von Identities, Policies, Diensten
- **Ziti Edge Router:** Setzt Zugriffspfade durch
- **Ziti Client (Tunnel oder SDK):** Baut Verbindung nur nach Authentifizierung auf
- **Ziti Service Policy:** Nur autorisierte Nutzer sehen definierte Dienste

## 🚀 Ziel der Integration

- Dienste wie das Flask-Backend (`/data`) werden nur nach Authentifizierung über Ziti sichtbar
- Danach erfolgt wie gewohnt JWT + OPA-Zugriffskontrolle
- Kombination von Netzwerk- und Anwendungsebene in einer Zero Trust Architektur

## ⚙️ Konfigurationsdatei

Im Projekt enthalten: [`ziti-minimal-config.json`](./ziti-minimal-config.json)

```json
{
  "identities": [ "alice" ],
  "services": [ "backend-api" ],
  "policy": {
    "only alice -> backend-api"
  }
}
```

## 📦 Setup-Schritte mit OpenZiti (vereinfacht)

1. Installiere Ziti-Controller + Edge-Router (z. B. per Docker)
2. Importiere `ziti-minimal-config.json`
   ```bash
   ziti edge create identity user alice -o alice.jwt
   ziti edge create service backend-api
   ziti edge create service-policy allow-alice-access ...
   ```
3. Installiere Ziti Desktop Edge oder CLI Tunnel
4. Authentifiziere dich mit `alice.jwt`
5. Greife auf `http://backend-api` (Port 9000) zu – nur bei gültigem Token möglich

## 🔁 Kombination mit OPA & JWT

Nach erfolgreicher Ziti-Authentifizierung erfolgt der übliche Zero Trust Flow:

- Authentifizierung via JWT
- Zugriffskontrolle durch OPA
- Logging in Loki/Grafana

## 🔍 Vorteile

- Dienste sind vollständig unsichtbar (Stealth-Modus)
- Verbindung erst nach Authentifizierung
- Komplementär zur OPA-Regelkontrolle
- Ideal für Labore, Bildungseinrichtungen, Zero Trust Pilotprojekte

---

© 2025 – Erweiterung zu Zero Trust mit Software Defined Perimeter
