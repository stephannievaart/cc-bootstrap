# Error Handling Rules

Cross-cutting error afspraken.

---

## Error classificatie

- Onderscheid **verwachte fouten** (validatie, not found, conflict) en **onverwachte fouten** (bugs, infrastructure failures)
- Verwachte fouten: specifieke HTTP status + error code, log op WARN niveau
- Onverwachte fouten: generiek bericht naar client, log op ERROR met volledige context en stack trace

## Error response format

- Alle services gebruiken RFC 9457 ProblemDetails — zie `docs/architecture/api-conventions.md`
- Geen eigen error DTOs per service — consistentie over de hele stack

## Wat niet naar de client gaat

- Stack traces, SQL errors, dependency namen, interne paden
- Ruwe foutmeldingen van downstream services — vertaal naar eigen domein
- Alles dat een aanvaller helpt de interne architectuur te begrijpen

## Error propagatie over service grenzen

- Downstream fouten altijd vertalen naar eigen error codes — nooit HTTP status of error body doorpompen
- Transient fouten (timeout, 503) markeren als retryable — permanent fouten (404, 422) niet
- Correlation ID meegeven en loggen bij elke service grens

## Partial failures

- Bulk operaties: communiceer welke items geslaagd en welke gefaald zijn
- Documenteer het partial success format in de API specificatie

## Verboden

- Stack traces of interne details teruggeven aan clients
- Downstream error responses onvertaald doorsturen
