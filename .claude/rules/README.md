# Rules Architectuur

Rules zijn zelfstandige bestanden. Agents bepalen welke rules ze laden — rules verwijzen niet naar elkaar.

---

## Structuur

```
commons/          ← cross-cutting, altijd geladen
backend/          ← backend werk: common + taal/framework
frontend/         ← frontend werk: common + taal/framework
testing/          ← test regels
```

## Precedentie

Specifiekere bestanden winnen bij conflict. Framework > taal > common.
Voorbeeld: `commons/coding-style.md` zegt `is`/`has` prefix voor booleans,
maar `backend/go.md` zegt geen prefix — de Go conventie wint.

---

## Commons (altijd geladen)

| Bestand | Scope |
|---|---|
| `commons/coding-style.md` | Bestandsgrootte, functies, scope, TODOs |
| `commons/error-handling.md` | Error classificatie, propagatie, partial failures |
| `commons/security.md` | Secrets, data classificatie, web security, supply chain |

## Backend

| Bestand | Scope |
|---|---|
| `backend/common.md` | Service boundaries, async, startup/shutdown, concurrency |
| `backend/java-conventions.md` | Java 21+ conventies |
| `backend/java-spring-boot.md` | Spring Boot (Java + Kotlin) |
| `backend/kotlin.md` | Kotlin 2.0+ conventies |
| `backend/python-conventions.md` | Python 3.11+ conventies |
| `backend/python-fastapi.md` | FastAPI |
| `backend/go.md` | Go 1.22+ conventies |
| `backend/elixir-conventions.md` | Elixir 1.16+ / OTP 26+ conventies |
| `backend/elixir-phoenix.md` | Phoenix |
| `backend/dotnet-conventions.md` | C# 12+ / .NET 8+ conventies |
| `backend/dotnet-aspnet.md` | ASP.NET Core |

## Frontend

| Bestand | Scope |
|---|---|
| `frontend/common.md` | Accessibility, state, responsive, forms, performance |
| `frontend/ui-ux.md` | Foutmeldingen, loading, terminologie, destructieve acties |
| `frontend/typescript.md` | TypeScript 5.x conventies |
| `frontend/react.md` | React |
| `frontend/angular.md` | Angular |

## Testing

| Bestand | Scope |
|---|---|
| `testing/common.md` | TDD workflow, kwaliteitseisen, verboden |
| `testing/e2e.md` | Playwright e2e patronen |
| `testing/react.md` | React Testing Library patronen |
| `testing/angular.md` | Angular TestBed patronen |
| `testing/java.md` | JUnit 5, Mockito, Spring test slicing |
| `testing/python.md` | pytest fixtures, async, mocking |
| `testing/dotnet.md` | xUnit, NSubstitute, WebApplicationFactory |
| `testing/go.md` | Table-driven, testify, httptest |
| `testing/kotlin.md` | MockK, coroutines, Turbine |
| `testing/elixir.md` | ExUnit, Mox, Ecto sandbox |

---

## Laadregels per agent type

### Backend developer agent
```
commons/* → backend/common.md → backend/[taal].md → backend/[framework].md
```

### Frontend developer agent
```
commons/* → frontend/common.md → frontend/typescript.md → frontend/[framework].md
```

### Architect / planner agent
```
commons/* → backend/common.md + frontend/common.md
```

### Review agents
```
commons/* → relevante backend/frontend bestanden
```

### Test automation agent
```
testing/common.md → testing/[taal].md → testing/e2e.md (als e2e relevant)
```

---

## Architecture docs

Rules zijn harde regels (do/don't). Architecture docs geven context en rationale.

| Architecture doc | Onderwerp |
|---|---|
| `docs/architecture/observability-standards.md` | Structured logging, W3C tracing |
| `docs/architecture/resilience-patterns.md` | Timeouts, retries, circuit breaker, health checks |
| `docs/architecture/api-conventions.md` | REST API design, error format, pagination |
| `docs/architecture/database-standards.md` | Migrations, indexing, naming |
| `docs/architecture/testing-standards.md` | Teststrategie per laag, per taaktype, TDD aanpak |
