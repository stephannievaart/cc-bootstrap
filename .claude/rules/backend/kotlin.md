---
paths:
  - "**/*.kt"
  - "**/*.kts"
---

# Kotlin Conventions

Kotlin-specifieke conventies. Dit bestand beschrijft waar Kotlin afwijkt of eigen idiomen heeft.

---

## Versie & tooling

- Kotlin 2.0+ — gebruik K2 compiler
- Build: Gradle met Kotlin DSL (`.gradle.kts`) — geen Groovy DSL in Kotlin projecten
- Linter: ktlint voor formatting, detekt voor statische analyse
- Detekt config in repo: `detekt.yml` — standaard ruleset + `complexity` en `coroutines`

## Naming conventions

- Classes, objects, interfaces: `PascalCase`
- Functies, properties, variabelen: `camelCase`
- Constanten (`const val` en top-level `val`): `UPPER_SNAKE_CASE`
- Packages: `lowercase.met.punten`
- Test functies: backtick-namen toegestaan: `` `should create order when valid input` ``
- Bestanden: `PascalCase.kt` voor single-class, `camelCase.kt` voor top-level functies

## Code structuur

- Gebruik `data class` voor DTOs en value objects — niet voor entities met identity
- Gebruik `sealed class` / `sealed interface` voor exhaustive hierarchieen — compiler forceert `when` branches
- Extension functions voor utility operaties op bestaande types — niet voor core business logica
- Scope functions bewust kiezen:
  - `let` — null checks en transformaties: `user?.let { sendEmail(it) }`
  - `apply` — object configuratie: `Order().apply { status = CREATED }`
  - `also` — side effects (logging): `result.also { logger.info { "Result: $it" } }`
  - `run` en `with` — vermijd tenzij scope duidelijk baat heeft
- Prefer `object` boven utility classes met companion functions
- Gebruik `value class` voor type-safe wrappers: `value class OrderId(val value: UUID)`

## Null safety

- Nullable types expliciet markeren — `String?` alleen als null een valide domeinwaarde is
- Gebruik `?.` (safe call) en `?:` (Elvis) voor null handling
- `!!` (not-null assertion) is verboden — gebruik `?: throw` met duidelijke exception
- Prefer `requireNotNull()` of `checkNotNull()` — geeft betere foutmeldingen
- Platform types van Java libraries altijd expliciet typen — vertrouw niet op inferred nullability

## Coroutines

- Structured concurrency: elke coroutine heeft een parent `CoroutineScope` — geen `GlobalScope`
- Gebruik `coroutineScope { }` of `supervisorScope { }` voor parallelle operaties
- `suspend` functies voor sequentiele async operaties
- `Flow` voor reactieve streams — prefer boven `Channel` tenzij fan-out nodig is
- Gebruik `Dispatchers.IO` voor blocking I/O — nooit blocking calls op `Dispatchers.Default`
- Cancellation respecteren: check `isActive` in lange loops, gebruik `ensureActive()`
- Exception handling: `CoroutineExceptionHandler` op top-level scope, niet op individuele coroutines

## Logging & observability

- Gebruik `io.github.oshai:kotlin-logging` (KotlinLogging) als wrapper rond SLF4J
- Declaratie: `private val logger = KotlinLogging.logger {}`
- Lambda syntax voor lazy evaluatie: `logger.info { "Order $orderId verwerkt" }`
- Coroutine context voor trace propagatie: gebruik `MDCContext()` als coroutine context element
- Zie `docs/architecture/observability-standards.md` voor verplichte velden

## Exception handling

- Gebruik sealed classes/interfaces voor domein error types — maakt `when` exhaustive
- `runCatching` alleen voor interactie met Java libraries die exceptions gooien — niet als standaard flow control
- `Result<T>` niet als return type in publieke APIs — gebruik eigen sealed result types voor expliciete error modeling

## Immutability

- `val` altijd tenzij mutatie onvermijdelijk — `var` is een bewuste keuze
- Immutable collections: `listOf()`, `mapOf()`, `setOf()` als default
- Mutable collecties alleen als performance het vereist — `mutableListOf()` bewust
- Wijzigingen op data classes via `copy()` — muteer nooit het origineel

## Spring Boot interop

- Constructor injection via primary constructor — geen `@Autowired`:
  ```kotlin
  @Service
  class OrderService(
      private val orderRepository: OrderRepository,
      private val eventPublisher: EventPublisher
  )
  ```
- `@ConfigurationProperties` met data class + `@Validated` — niet met `lateinit var`:
  ```kotlin
  @ConfigurationProperties(prefix = "app.payment")
  @Validated
  data class PaymentProperties(
      @field:NotBlank val apiUrl: String,
      @field:Positive val timeoutSeconds: Int = 30
  )
  ```
- Gebruik `@MockkBean` (MockK) in plaats van `@MockBean` (Mockito) in Spring tests
- Open classes voor Spring proxying: gebruik `allopen` compiler plugin (Spring plugin doet dit automatisch)

## Testing

- JUnit 5 als test runner — of Kotest als het project dat al gebruikt
- MockK als mocking library — niet Mockito (Kotlin-onvriendelijk door final classes)
- Coroutine tests: `runTest { }` uit `kotlinx-coroutines-test`
- Turbine voor `Flow` testing
- Assertions: kotest-assertions of AssertJ — consistent per project

## Verboden

- `!!` operator — gebruik `requireNotNull()`, `checkNotNull()`, of `?: throw`
- `GlobalScope.launch` — altijd structured concurrency
- `var` waar `val` volstaat
- `lateinit` voor dependencies — gebruik constructor injection
- `companion object` als namespace voor utility functies — gebruik top-level functies of `object`
- `runBlocking` in productiecode — alleen in tests en main functies
- `Thread.sleep()` in coroutine code — gebruik `delay()`
