# Testing Rules

---

## TDD — Test-Driven Development

Dit project volgt strikt TDD:
1. **Red** — Tests worden geschreven VOOR implementatie. Ze moeten falen.
2. **Green** — Implementatie maakt tests groen. Niet meer code dan nodig.
3. **Refactor** — Code opschonen terwijl tests groen blijven.

- Tests schrijven is Stap 3. Implementatie is Stap 4. Nooit andersom.
- Een test die groen is zonder implementatie test niets nuttigs.
- Developer agents voegen geen tests toe — alleen test-automation agent schrijft tests.

---

## Algemeen

- Test scenarios definiëren voor implementatie begint (Stap 2)
- Minimaal 80% coverage op acceptance criteria
- Alle unhappy paths gedekt — niet alleen happy path
- Nooit tests skippen zonder gedocumenteerde reden

## Test structuur

- Arrange / Act / Assert patroon
- Één assertion per test waar mogelijk
- Beschrijvende test namen: `should_[gedrag]_when_[conditie]`
- Tests zijn onafhankelijk — volgorde mag niet uitmaken

## Test types

- **Unit tests** — geïsoleerde business logic, geen externe dependencies
- **Integratie tests** — samenwerking tussen componenten
- **Acceptatie tests** — end-to-end scenario's

## Mocking

- Mock externe dependencies (HTTP clients, databases in unit tests)
- Gebruik echte implementaties in integratie tests waar mogelijk
- Geen productie data in tests

## Wat NIET mag

- `it.skip()`, `@pytest.mark.skip`, of uitgecommentarieerde tests zonder reden
- Tests aanpassen om ze te laten slagen in plaats van de code te fixen
- Tests die afhangen van volgorde of gedeelde state
- Hardcoded timeouts als vervanging voor correcte async handling

## Test data

- Gebruik factories of builders voor test objecten
- Geen gedeelde mutable state tussen tests
- Databases cleanen voor elke test suite
