#!/bin/bash

# Script: simulate_alice_access.sh
# Purpose: Simulate 200 HTTP GET requests per minute from user 'alice' with JWT

URL="http://localhost:8080/data"
JWT="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhbGljZSIsInJvbGUiOiJhZG1pbiJ9.fZzvYr0wDM-RNl51cXcGHJ5VwtEvK0UBZBSGo-UkbFw"

echo "Sending 200 requests per minute (~1 every 300ms)..."

for i in {1..200}
do
  curl -s -o /dev/null -w "%{http_code}\n" -H "Authorization: Bearer $JWT" "$URL"
  sleep 0.3
done

echo "Done."
