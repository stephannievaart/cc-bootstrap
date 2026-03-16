# Patterns & Anti-patterns

Patronen die we gebruiken en anti-patronen die we vermijden.
Projectspecifieke keuzes staan in `/docs/decisions/` als ADRs.

---

## Patterns die we gebruiken

### Repository pattern
- Data access geïsoleerd in repositories
- Business logic weet niet hoe data opgeslagen wordt
- Repositories zijn injecteerbaar (testbaar)

### Service layer
- Business logic in services, niet in controllers/handlers
- Controllers zijn dun — alleen request/response mapping
- Services hebben geen kennis van HTTP

### Dependency injection
- Dependencies injecteren via constructor
- Geen static calls naar externe services
- Maakt testen mogelijk zonder mocking frameworks

### Outbox pattern (voor event publishing)
- Events worden eerst opgeslagen in database
- Separate process publiceert naar message broker
- Garandeert at-least-once delivery

### Feature flags
- Nieuwe features achter een feature flag
- Maakt graduele uitrol mogelijk
- Verwijder flags na volledige uitrol

---

## Anti-patterns die we vermijden

### God objects
- Classes die alles weten en alles doen
- Signaal: class heeft meer dan 5-7 verantwoordelijkheden

### Anemic domain model
- Objecten zijn alleen data containers zonder gedrag
- Business logic verspreid over services
- Voorkeur: gedrag bij de data die het beschrijft

### Primitive obsession
- Primitives gebruiken voor domein concepten
- Gebruik value objects: `EmailAddress` in plaats van `String`

### Shotgun surgery
- Één wijziging vereist aanpassingen in veel bestanden
- Signaal: hoge koppeling, lage cohesie

### Hardcoded dependencies
- `new SomeService()` diep in de code
- Maakt testen onmogelijk zonder side effects

### Silent failures
- Catch blokken zonder actie
- Fouten negeren en doorgaan alsof alles goed is
