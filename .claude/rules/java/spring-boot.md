---
paths:
  - "**/*.java"
---

# Spring Boot Rules

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
- Gebruik `ResponseEntity<?>` voor expliciete HTTP status control

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
- Domein exceptions in de service laag
- Geen HTTP exceptions in de service laag

## Security

- `SecurityFilterChain` bean voor security configuratie
- Method-level security met `@PreAuthorize` voor fine-grained control
- Nooit `permitAll()` op endpoints zonder expliciete reden

## Database

- Flyway voor migraties — zie `/docs/database/migration-standards.md`
- Gebruik `spring.jpa.open-in-view=false` — vermijd lazy loading problemen
- Geen `@Transactional` op controllers

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
