# API Conventies

Stack-onafhankelijke richtlijnen voor het ontwerpen van REST APIs.

---

## URL structuur

### Regels

- Gebruik **plural nouns** voor resources: `/users`, `/orders`, `/products`
- Geen werkwoorden in URLs — de HTTP methode drukt de actie uit
- Kebab-case voor paden: `/order-items`, niet `/orderItems` of `/order_items`
- Maximaal **2-3 niveaus** nesting: `/users/{id}/orders` is goed, `/users/{id}/orders/{id}/items/{id}/details` is te diep
- Resource IDs in het pad, niet in query parameters: `/users/123`, niet `/users?id=123`

---

## HTTP methoden & idempotency

### Methoden

| Methode | Doel | Idempotent | Response |
|---|---|---|---|
| GET | Resource ophalen | Ja | 200 met data |
| POST | Resource aanmaken | Nee | 201 met locatie |
| PUT | Resource volledig vervangen | Ja | 200 of 204 |
| PATCH | Resource gedeeltelijk wijzigen | Nee | 200 met data |
| DELETE | Resource verwijderen | Ja | 204 |

### Idempotency regels

- GET, PUT, DELETE zijn idempotent per RFC 9110 — meerdere identieke requests geven hetzelfde resultaat
- POST en PATCH zijn niet idempotent — meerdere requests kunnen verschillende resultaten geven
- Voor POST operaties die veilig geretried moeten kunnen worden: gebruik een **idempotency key** in een request header (bijv. `Idempotency-Key: <uuid>`)
- De server slaat het resultaat op bij de eerste request en retourneert hetzelfde resultaat bij herhaalde requests met dezelfde key

---

## Request & Response format

### Regels

- JSON als standaard formaat voor request en response bodies
- Content-Type header altijd meesturen: `application/json`
- Kies één response structuur en gebruik die consistent door de hele API
- Geen geneste objecten dieper dan 3-4 niveaus
- Lege collecties als `[]` teruggeven, niet als `null` of het veld weglaten
- Datums in ISO 8601 formaat: `2025-03-16T14:30:00Z`

---

## Status codes

### Gebruik de juiste code voor de situatie

**Succes (2xx):**

| Code | Wanneer |
|---|---|
| 200 OK | Request geslaagd, response bevat data |
| 201 Created | Resource succesvol aangemaakt |
| 204 No Content | Request geslaagd, geen response body (bijv. DELETE) |

**Client fouten (4xx):**

| Code | Wanneer |
|---|---|
| 400 Bad Request | Ongeldige input, validatiefout |
| 401 Unauthorized | Niet geauthenticeerd |
| 403 Forbidden | Wel geauthenticeerd, niet geautoriseerd |
| 404 Not Found | Resource bestaat niet |
| 409 Conflict | Conflicterende state (bijv. duplicate) |
| 422 Unprocessable Entity | Syntactisch correct maar semantisch ongeldig |
| 429 Too Many Requests | Rate limit bereikt |

**Server fouten (5xx):**

| Code | Wanneer |
|---|---|
| 500 Internal Server Error | Onverwachte fout |
| 503 Service Unavailable | Tijdelijk niet beschikbaar |

### Regels

- Niet alles als 200 teruggeven — gebruik de juiste status code
- Gebruik een beperkte, consistente set codes — niet elke obscure HTTP status code inzetten
- Client fouten (4xx) zijn geen bugs — ze zijn verwacht gedrag

---

## Error responses

Per **RFC 9457** (Problem Details for HTTP APIs). Geen eigen formaat, maar de gestandaardiseerde structuur.

### Format

Content-Type: `application/problem+json`

```json
{
  "type": "https://api.example.com/problems/validation-error",
  "title": "Validation Error",
  "status": 422,
  "detail": "Het veld 'email' is verplicht.",
  "instance": "/users/123"
}
```

### Velden

| Veld | Verplicht | Beschrijving |
|---|---|---|
| type | Ja | URI die het probleemtype identificeert |
| title | Ja | Korte, menselijk leesbare samenvatting |
| status | Ja | HTTP status code |
| detail | Nee | Specifieke uitleg voor deze occurrence |
| instance | Nee | URI die deze specifieke occurrence identificeert |

### Regels

- Gebruik `type` als machine-leesbare identifier — clients schakelen hierop, niet op `title`
- `title` verandert niet per occurrence — het beschrijft het type, niet het specifieke geval
- `detail` bevat de specifieke context — wat er fout ging bij deze request
- Geen stack traces of interne details in error responses
- Extensie velden toegestaan voor extra context (bijv. `errors` array voor meerdere validatiefouten)

---

## Paginatie

### Cursor-based als default

Cursor-based paginatie is de voorkeur: performant, consistent bij mutaties, schaalt goed.

```json
{
  "data": [...],
  "cursor": {
    "next": "eyJpZCI6MTAwfQ==",
    "has_more": true
  }
}
```

### Offset als alternatief

Acceptabel voor kleine, stabiele datasets waar de eenvoud opweegt.

```json
{
  "data": [...],
  "pagination": {
    "offset": 0,
    "limit": 20,
    "total": 150
  }
}
```

### Regels

- Kies één paginatie-aanpak per API — niet mixen
- Definieer een default en maximum page size
- Geef altijd aan of er meer resultaten zijn

---

## Naming conventies

### Regels

- Kies **één casing** voor JSON veldnamen (camelCase of snake_case) en gebruik die consistent door de hele API
- URL paden in kebab-case: `/user-profiles`, niet `/userProfiles`
- Query parameters in dezelfde casing als JSON velden
- Boolean velden: `is_active`, `has_permission`, `can_edit` (met prefix)
- Vermijd afkortingen tenzij domein-standaard (`id`, `url`, `api`)

---

## Versioning

Alleen relevant wanneer de API extern wordt aangeboden. Voor interne APIs: backward-compatible wijzigingen boven expliciete versioning.

### Regels

- URL-based versioning als standaard: `/v1/users`
- Versienummer alleen ophogen bij **breaking changes**
- Backward-compatible wijzigingen (velden toevoegen, optionele parameters) vereisen geen nieuwe versie
- Ondersteun maximaal **2 versies** tegelijk — oude versies actief uitfaseren
