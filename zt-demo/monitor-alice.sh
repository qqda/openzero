#!/bin/bash

LOGFILE="./logs/zero-trust.log"
BLACKLIST="./opa/blacklist.json"
USER="alice"
THRESHOLD=10

# Zähle Anzahl erfolgreicher Zugriffe von 'alice' in den letzten 5 Minuten
COUNT=$(grep "user=\"$USER\"" $LOGFILE | grep "access=\"allowed\"" | tail -n 100 | wc -l)

# Prüfe ob über Schwellwert
if [ "$COUNT" -gt "$THRESHOLD" ]; then
  echo "Zugriffsanzahl für $USER überschreitet Schwelle ($COUNT > $THRESHOLD)."
  echo "{\"blocked_users\": [\"$USER\"]}" > $BLACKLIST
  echo "Blacklist aktualisiert. Bitte OPA neu starten:"
  echo "docker-compose restart opa"
else
  echo "Zugriffe für $USER unter Kontrolle ($COUNT <= $THRESHOLD)."
fi
