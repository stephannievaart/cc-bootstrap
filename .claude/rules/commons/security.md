# Security Rules

Projectspecifieke security beslissingen. Cross-cutting over alle talen en frameworks.

---

## Secrets management

- Secrets via environment variabelen of secret manager — nooit in code of config files
- Valideer vereiste secrets bij startup — fail fast met duidelijke melding
- Secret per ongeluk gecommit → roteer direct, beschouw als gecompromitteerd
- Pre-commit hook voor secret detectie (git-secrets, detect-secrets, of equivalent)

## Data classificatie

- PII versleutelen at rest en in transit
- Minimale data opslag — sla niet op wat je niet nodig hebt
- Log NOOIT: passwords, tokens, PII, session identifiers
- Log WEL: security events (login attempts, authorization failures, data access) met correlation ID

## Web security baseline

- CORS: expliciete origin whitelist — nooit wildcard (`*`) in productie
- CSRF bescherming: standaard aan voor state-wijzigende browser requests
- Rate limiting op publieke endpoints — voorkom brute force en abuse
- Content Security Policy headers op web-facing services

## Supply chain

- Geen dependencies met bekende CRITICAL CVEs
- Lockfiles altijd committen
- Controleer licenties bij nieuwe dependencies — geen copyleft in proprietary code
- Minimaal aantal dependencies — elke dependency is aanvalsoppervlak
