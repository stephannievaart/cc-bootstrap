# Backend Common Rules

Taal-onafhankelijke regels voor backend code. Geladen vóór taalspecifieke rules.
Voor logging/tracing zie `docs/architecture/observability-standards.md`.
Voor resilience (timeouts, retries, circuit breakers) zie `docs/architecture/resilience-patterns.md`.
Voor database richtlijnen zie `docs/architecture/database-standards.md`.
Voor API conventies zie `docs/architecture/api-conventions.md`.

---

## Service boundaries

- Een service exposeert functionaliteit alleen via zijn API contract — nooit directe database access door andere services
- Elke service beheert zijn eigen data store — geen gedeelde databases tussen services
- Wijzigingen aan een API zijn backwards compatible tenzij een nieuwe versie wordt geïntroduceerd
- Interne implementatiedetails lekken niet naar de API — geen ORM entities als response, geen database IDs als enige identifier
- Communicatie tussen services altijd via gedefinieerde interfaces (HTTP, messaging) — nooit via shared libraries met business logic

## Async processing

- Message consumers zijn idempotent — hetzelfde bericht tweemaal verwerken geeft hetzelfde resultaat
- Dead letter queue voor berichten die na max retries niet verwerkt kunnen worden
- Documenteer ordering guarantees per topic/queue — consumers mogen geen volgorde aannemen tenzij gegarandeerd
- Poison pill handling: een enkel corrupt bericht mag de consumer niet permanent blokkeren
- Acknowledgement pas na succesvolle verwerking — niet vooraf
- Outbox pattern voor event publishing: events eerst opslaan in database, apart proces publiceert naar broker — garandeert at-least-once delivery

## Startup & shutdown

- Graceful shutdown: stop met accepteren van nieuwe requests, maak lopende requests af, sluit connections
- Fail fast bij startup: ontbrekende configuratie of onbereikbare kritieke dependencies → niet starten
- Readiness probe: service is klaar om traffic te ontvangen (dependencies bereikbaar)
- Liveness probe: service is niet vastgelopen (geen dependency checks)
- Dependency ordering bij startup documenteren als een service afhankelijk is van een andere

## Concurrency

- Geen shared mutable state tussen threads — gebruik thread-local, immutable data, of expliciete synchronisatie
- Lock ordering documenteren als meerdere locks nodig zijn — voorkomt deadlocks
- Prefer message passing boven shared state — minder foutgevoelig
- Database als synchronisatiepunt: gebruik optimistic locking (versie kolom) boven pessimistic locking waar mogelijk
