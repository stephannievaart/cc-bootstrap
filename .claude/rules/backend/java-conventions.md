---
paths:
  - "**/*.java"
---

# Java Conventions

Java-specifieke conventies.

---

## Versie & tooling

- Java 21+ — gebruik moderne features (records, sealed classes, pattern matching)
- Maven of Gradle — gebruik wat het project al heeft, wissel niet
- Linter: Checkstyle of SpotBugs — configuratie staat in repo

## Naming conventions

- Classes: `PascalCase`
- Methods & variabelen: `camelCase`
- Constanten: `UPPER_SNAKE_CASE`
- Packages: `lowercase.met.punten`
- Test klassen: `[KlasseNaam]Test`

## Code structuur

- Gebruik records voor immutable data transfer objecten
- Gebruik sealed interfaces voor algebraïsche types
- Prefer `Optional` boven `null` returns — nooit `null` teruggeven uit publieke methoden
- Gebruik `var` voor lokale variabelen waar het type duidelijk is uit de context

## Exception handling

- Checked exceptions alleen voor recoverable situaties
- Unchecked (RuntimeException) voor programmafouten
- Nooit `Exception` of `Throwable` catchen tenzij top-level handler
- Custom exceptions hebben betekenisvolle namen en messages

## Immutability

- Gebruik `final` op velden waar mogelijk
- Collections: gebruik `List.of()`, `Map.of()` voor immutable collections
- Muteer geen parameters van methoden

## Logging & observability

- SLF4J als logging API — nooit direct Logback, Log4j2, of `java.util.logging`
- Structured logging via Logback met JSON encoder (Logstash Logback Encoder)
- MDC voor trace context: `MDC.put("trace_id", ...)` wordt automatisch meegenomen in elke log entry
- Parameterized logging: `log.info("Order {} created", orderId)` — nooit string concatenatie
- Zie `docs/architecture/observability-standards.md` voor verplichte velden en log niveaus

## Testing

- JUnit 5 + Mockito als standaard test stack
- AssertJ voor fluent assertions — prefer boven JUnit assertions
- Test klassen zijn package-private (geen `public`)

## Verboden

- `null` teruggeven uit publieke methoden — gebruik `Optional`
- `System.out.println` in productiecode
- Mutable static state
- Raw types: `List` in plaats van `List<String>`
- String concatenatie in log statements: `log.info("Order " + id)` — gebruik `log.info("Order {}", id)`
