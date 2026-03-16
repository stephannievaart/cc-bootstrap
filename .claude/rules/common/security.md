# Security Rules

Harde security regels. Gelden voor alle talen en frameworks.

---

## Secrets

- NOOIT secrets hardcoden — geen API keys, passwords, tokens in code
- Gebruik environment variabelen of een secret manager
- Valideer vereiste secrets bij startup — fail fast met duidelijke melding
- Roteer direct als een secret per ongeluk gecommit is

## Input validatie

- Valideer alle user input op systeemgrenzen
- Gebruik schema-gebaseerde validatie (niet handmatig)
- Fail fast met duidelijke berichten
- Sanitize output — geen raw user data teruggeven

## Authenticatie & autorisatie

- Valideer authenticatie op elke endpoint
- Valideer autorisatie — niet alleen "is ingelogd" maar "mag dit"
- Gebruik geen zelfgeschreven crypto
- JWT tokens valideren op signature, expiry, en claims

## Error handling

- Geef geen interne details terug aan clients (stack traces, SQL errors)
- Log security events: login attempts, authorization failures, data access
- Log NIET: passwords, tokens, PII in logs

## Dependencies

- Geen libraries met bekende CRITICAL CVEs
- Controleer licenties bij nieuwe dependencies
- Minimaal aantal dependencies — elke dependency is een aanvalsoppervlak

## Data

- PII nooit loggen
- PII versleutelen at rest en in transit
- Minimale data opslag — sla niet op wat je niet nodig hebt
