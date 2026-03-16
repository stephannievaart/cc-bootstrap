---
paths:
  - "**/*.java"
---

# Java Conventions

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

## Spring Boot specifiek (indien van toepassing)

- Constructor injection — geen `@Autowired` op velden
- `@Service`, `@Repository`, `@Component` annotaties correct gebruiken
- Configuratie via `@ConfigurationProperties` — geen losse `@Value` overal
- Geen business logic in `@RestController` klassen

## Testing

- JUnit 5 + Mockito
- `@ExtendWith(MockitoExtension.class)` voor unit tests
- `@SpringBootTest` alleen voor integratie tests — te zwaar voor unit tests
- Test klassen zijn package-private

## Verboden

- `null` teruggeven uit publieke methoden — gebruik `Optional`
- Field injection met `@Autowired`
- `System.out.println` in productiecode
- Mutable static state
- Raw types: `List` in plaats van `List<String>`
