---
paths:
  - "**/*.java"
  - "**/*.kt"
  - "**/*.kts"
---

# Spring Boot Rules

Spring Boot-specifieke regels.

---

## Project structuur

Organiseer op feature/domein — niet op technische laag:

```
src/main/java/com/[bedrijf]/[service]/
  [feature]/
    [Feature]Controller.java
    [Feature]Service.java
    [Feature]Repository.java
    [Feature]Dto.java
    [Feature]Entity.java
  shared/
    config/
    exception/
    security/
```

## Controllers

- Dun — alleen request/response mapping
- Geen business logica
- Valideer input met `@Valid` en Bean Validation
- Gebruik `ResponseEntity<OrderResponse>` met concreet type — geen `ResponseEntity<?>` wildcards

```java
@RestController
@RequestMapping("/api/v1/orders")
@RequiredArgsConstructor
public class OrderController {
    private final OrderService orderService;

    @PostMapping
    public ResponseEntity<OrderResponse> create(
        @Valid @RequestBody CreateOrderRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(orderService.create(request));
    }
}
```

## Services

- Alle business logica hier
- `@Transactional` op service methoden die database wijzigen
- Gooi domein exceptions — geen HTTP concerns in services

## Repositories

- Gebruik Spring Data JPA interfaces
- Custom queries met `@Query` of Specifications
- Geen SQL strings buiten repositories

## Configuratie

- Gebruik `@ConfigurationProperties` voor gebundelde config
- Geen losse `@Value` annotations verspreid over de codebase
- Valideer config met `@Validated` op de properties class

```java
@ConfigurationProperties(prefix = "app.payment")
@Validated
public record PaymentProperties(
    @NotBlank String apiUrl,
    @Positive int timeoutSeconds
) {}
```

## Exception handling

- Centrale `@RestControllerAdvice` voor exception → HTTP response mapping
- Gebruik `ProblemDetail` (RFC 9457, Spring 6+) als error response type — geen eigen error DTOs
- Domein exceptions in de service laag
- Geen HTTP exceptions in de service laag

## Security

- `SecurityFilterChain` bean voor security configuratie
- Method-level security met `@PreAuthorize` voor fine-grained control
- Nooit `permitAll()` op endpoints zonder expliciete reden

## Database

- Flyway voor migraties — zie `docs/architecture/database-standards.md`
- Gebruik `spring.jpa.open-in-view=false` — vermijd lazy loading problemen

## Observability

- Micrometer Tracing voor distributed tracing — propageert W3C `traceparent` automatisch
- Spring Boot Actuator voor health endpoints met liveness en readiness groepen
- Configureer: `management.endpoint.health.group.readiness.include=db,diskSpace`
- Custom `HealthIndicator` implementaties voor niet-standaard dependencies
- Zie `docs/architecture/observability-standards.md` voor verplichte log velden
- Zie `docs/architecture/resilience-patterns.md` voor health check semantiek

## Resilience

- Resilience4j als resilience library — geen eigen retry/circuit breaker logica
- Configureer via `application.yml`, niet programmatisch
- Annotaties op service methoden: `@CircuitBreaker`, `@Retry`, `@TimeLimiter`
- Elke externe dependency krijgt een eigen benoemde circuit breaker instance
- Zie `docs/architecture/resilience-patterns.md` voor thresholds en backoff strategie

## Startup & shutdown

- Graceful shutdown: `server.shutdown=graceful`
- Shutdown timeout: `spring.lifecycle.timeout-per-shutdown-phase=30s`
- Fail fast bij ontbrekende config: `@Validated` op `@ConfigurationProperties` classes

## Testing

- `@SpringBootTest` alleen voor integratie tests
- `@WebMvcTest` voor controller tests (sneller dan full context)
- `@DataJpaTest` voor repository tests
- Gebruik Testcontainers voor database integratie tests

## Verboden

- `@Autowired` op velden — gebruik constructor injection
- `@Transactional` op controllers
- Business logica in controllers
- `spring.jpa.hibernate.ddl-auto=create-drop` in productie config
