# Testing Standards

Teststrategie: wanneer welke testtypen ingezet worden en wie dat bepaalt.
Voor hoe tests geschreven worden zie `.claude/rules/testing/common.md`.

---

## Teststrategie per laag

### Backend

| Testtype | Wanneer | Voorwaarde |
|---|---|---|
| Unit tests | Altijd | Business logica, domeinregels, validatie |
| Integratietests | Conditioneel | Feature raakt database of externe services |
| Contract tests | Conditioneel | API contract beschikbaar uit stap 1b |

### Frontend

| Testtype | Wanneer | Voorwaarde |
|---|---|---|
| Component tests | Altijd bij frontend werk | NA implementatie — test gedrag vanuit gebruikersperspectief, niet implementatiedetails |

Tooling: React Testing Library of equivalent.

### End-to-end

| Testtype | Wanneer | Voorwaarde |
|---|---|---|
| E2e tests | Conditioneel | User-facing flows |

- Geschreven VOOR implementatie als acceptatietest
- Tooling: Playwright
- E2e draait pas als backend én frontend component tests groen zijn

---

## Wanneer GEEN tests

- Triviale code — getters, setters, pure configuratie
- Gegenereerde code
- Tijdelijke scripts
- Simpele CRUD zonder business logica

---

## Teststrategie per taaktype

### Feature

Unit tests altijd. Integratie, e2e en contract tests alleen als de feature die lagen raakt. De architect bepaalt in stap 1 welke testtypen van toepassing zijn.

### Bug

Minimaal een reproducing test die de bug bewijst + fix verificatie.

### Chore

Regressietests op wat geraakt wordt. Geen nieuwe tests verplicht.

---

## TDD aanpak

### Wanneer TDD

- Business logica met meerdere condities en edge cases
- Domeinregels die fout kunnen gaan
- Algoritmes met duidelijke input/output
- E2e tests — altijd vóór implementatie als acceptatietest

### Wanneer GEEN TDD

- Frontend componenten — bouw eerst, test daarna op gedrag
- Infrastructuur code — database configuratie, migraties, DI setup
- Exploratory code — gedrag nog niet helder voor implementatie begint
- Simpele CRUD zonder business logica
- Integratie met externe systemen

**Vuistregel:** TDD waar het gedrag vooraf helder en stabiel te definiëren is. Niet als dogma voor elke regel code.

---

## Rol van de architect in stap 1

De architect beoordeelt per feature welke testtypen en welke TDD aanpak van toepassing zijn. Dit wordt opgenomen in het uitvoeringsplan.

Afwijkingen van de standaard worden expliciet gemotiveerd in de task doc.

---

## Referenties

- `.claude/rules/testing/common.md` — hoe tests geschreven worden (TDD workflow, kwaliteitseisen, verboden)
- `docs/architecture/api-conventions.md` — API contract formaat voor contract tests
- `docs/workflow/task-workflow.md` — stappen waarin testen plaatsvinden (stap 2, 3, 5)
