# Observability Standards

Stack-onafhankelijke richtlijnen voor logging en tracing. Doel: elk probleem in productie is traceerbaar en diagnosticeerbaar.

---

## Structured Logging

Alle logs in gestructureerd formaat (JSON). Geen plain text log regels.

### Verplichte velden per log entry

| Veld | Beschrijving |
|---|---|
| timestamp | ISO 8601 in UTC |
| level | Log niveau (zie onder) |
| trace_id | W3C Trace Context ID (zie Tracing sectie) |
| service | Naam van de service |
| message | Beschrijving van het event |

### Log niveaus

| Niveau | Wanneer |
|---|---|
| ERROR | Onverwachte fout, vereist aandacht |
| WARN | Verwachte fout of degraded situatie |
| INFO | Significante business events (request ontvangen, order verwerkt) |
| DEBUG | Diagnostische informatie, alleen aan in development of bij troubleshooting |

### Regels

- Eén event per log entry — geen multiline logs
- Consistente veldnamen over alle services heen
- Geen PII in logs (namen, emailadressen, BSN, etc.)
- Geen secrets in logs (tokens, wachtwoorden, API keys)
- Log bij elke inkomende en uitgaande request: methode, pad, status code, duur
- ERROR en WARN loggen altijd voldoende context om het probleem te diagnosticeren zonder de code te lezen

---

## Correlation / Tracing

Distributed tracing per **W3C Trace Context** standaard. Geen eigen correlation ID schema.

### Hoe het werkt

- Elke inkomende request krijgt een trace ID (of neemt het over uit de `traceparent` header)
- De `traceparent` header wordt doorgegeven bij elke uitgaande call
- Elke operatie binnen een trace is een **span** met een eigen span ID, start- en eindtijd

### Regels

- Elke service propageert de `traceparent` header — nooit een trace afbreken
- Trace ID is aanwezig in elke log entry (veld `trace_id`)
- Spans bevatten relevante attributen: HTTP methode, status code, database operatie, queue naam
- Maak spans voor elke significante operatie: HTTP calls, database queries, message publishing
