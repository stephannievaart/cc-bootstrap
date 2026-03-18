# Java Testing — JUnit 5, Mockito, Spring Test patronen

Paths: `**/*Test.java`, `**/*IT.java`

Voor tooling keuze (JUnit 5, Mockito, AssertJ) zie `backend/java-conventions.md`.
Voor Spring test annotations zie `backend/java-spring-boot.md`.
Voor TDD workflow zie `testing/common.md`.

---

## Spring test slicing keuze

- `@WebMvcTest` voor controllers — laadt alleen web laag, geen database
- `@DataJpaTest` voor repositories — laadt alleen JPA, geen web laag
- `@SpringBootTest` alleen voor echte integratie die meerdere lagen combineert
- Hoe smaller de slice, hoe sneller en stabieler de test

## @Transactional valkuil

- Test-only `@Transactional` maskeert lazy-loading bugs en flush timing problemen
- De test ziet data die in productie een `LazyInitializationException` geeft
- Gebruik `@Transactional` alleen als je transactiegedrag expliciet test
- Integratie tests: laat transacties commiten, ruim op via `@Sql` of Testcontainers

## Mockito patronen

- `when().thenReturn()` voor gedrag setup, `verify()` voor interactie verificatie
- Meng niet exact values en argument matchers in dezelfde call — Mockito staat dit niet toe
- `@InjectMocks` + `@Mock` voor unit tests, `@MockBean` alleen binnen Spring context

## Test data builders

- `TestOrderBuilder.anOrder().withStatus(PENDING).build()` pattern voor domain objecten
- Voorkomt dat schemawijzigingen tientallen tests breken — alleen de builder aanpassen
- Builders in een gedeeld test-support package, niet per test class

## AssertJ voor alles

- `assertThat(result).isEqualTo(expected)` — altijd AssertJ
- Geen `assertEquals`, `assertTrue`, `assertNull` — AssertJ geeft betere foutmeldingen
- Gebruik fluent chains: `assertThat(list).hasSize(3).extracting("name").contains("foo")`

## Integratie test isolatie

- Testcontainers voor echte database — representatief voor productie
- `@DirtiesContext` alleen als absolute laatste redmiddel — herstart de hele Spring context
- Prefer database cleanup via truncate of `@Sql` scripts boven `@DirtiesContext`

## Verboden

- `@SpringBootTest` voor unit tests — te zwaar, te traag
- `Thread.sleep()` in tests — gebruik `Awaitility` voor async verificatie
- `@MockBean` overal — alleen waar Spring context daadwerkelijk nodig is
