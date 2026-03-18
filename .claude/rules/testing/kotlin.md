# Kotlin Testing — MockK, coroutines, Turbine patronen

Paths: `**/*Test.kt`, `**/*IT.kt`

Voor tooling keuze (MockK, runTest, Turbine) zie `backend/kotlin.md`.
Voor Spring test annotations zie `backend/java-spring-boot.md`.
Voor TDD workflow zie `testing/common.md`.

---

## MockK DSL

- `every { service.find(any()) } returns order` voor gedrag setup
- `verify { service.save(match { it.status == PENDING }) }` voor interactie checks
- `slot<T>()` voor argument capture wanneer je de waarde moet inspecteren
- Nooit Mockito syntax in Kotlin — MockK is idiomatisch en werkt met final classes

## @MockkBean in Spring

- `@MockkBean` uit `com.ninja-squad:springmockk` — niet `@MockBean` (Mockito)
- `@MockBean` faalt silently op Kotlin final classes — MockK handelt dit correct
- Gebruik `@MockkBean` alleen in Spring integration tests — pure unit tests gebruiken `mockk<T>()`

## Coroutine testing

- `runTest { }` altijd voor coroutine tests — beheert `TestDispatcher` automatisch
- Nooit `runBlocking` in tests — blokkeert de thread en mist `TestDispatcher` voordelen
- `advanceUntilIdle()` voor pending coroutines, `advanceTimeBy()` voor delay-based logica

## Flow testing met Turbine

- `flow.test { }` block voor Flow assertions
- `awaitItem()` voor elke verwachte emission — expliciet per waarde
- `awaitComplete()` voor finite flows, `cancel()` voor infinite flows
- Nooit `toList()` op flows in tests — blokkeert bij infinite flows, verbergt timing

## Backtick test namen

- `` `should return order when valid input` `` — leesbaar in test reports
- Beschrijf verwacht gedrag, niet de implementatie
- Consistent format per project: `should [result] when [condition]`

## Extension functions als test helpers

- `fun Order.withStatus(status: OrderStatus) = copy(status = status)` — compact en leesbaar
- Prefer data class `copy()` boven builder pattern in Kotlin
- Test helpers in een gedeeld test-support module

## Verboden

- Mockito imports in Kotlin files — gebruik MockK
- `runBlocking` in tests — gebruik `runTest`
- `Thread.sleep()` — gebruik `advanceTimeBy()` of `advanceUntilIdle()`
- `@MockBean` (Mockito) — gebruik `@MockkBean` (springmockk)
