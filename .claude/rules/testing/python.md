# Python Testing — pytest patronen

Paths: `**/test_*.py`, `**/*_test.py`, `**/conftest.py`

Voor tooling keuze (pytest, httpx.AsyncClient, Testcontainers) zie `backend/python-fastapi.md`.
Voor TDD workflow zie `testing/common.md`.

---

## Fixture scope

- Default `scope="function"` — elke test krijgt een schone fixture
- Override naar `session` of `module` alleen met expliciete reden en documentatie
- Async fixtures MOETEN `scope="function"` zijn — hogere scopes leiden tot event loop problemen

## conftest.py organisatie

- Eén `conftest.py` per test directory — niet alles in de root conftest
- Max 10 fixtures per conftest — split op als het groeit
- Fixtures die <2 test files gebruiken horen in het test file zelf, niet in conftest

## Parametrize

- `@pytest.mark.parametrize` voor betekenisvolle variatie: happy/sad paths, grenswaarden
- Max 3 dimensies — cartesisch product van alles maakt tests onleesbaar
- Geef elke case een id: `pytest.param(..., id="empty-input-returns-none")`

## Mock de grens

- Mock externe services op de adapter/client laag — niet op interne functies
- Interne business logica direct testen met echte objecten, zonder mocks
- `unittest.mock.patch` alleen op de boundary — import path van de consumer, niet de provider

## Database isolatie

- Transactie rollback per test — nooit commit naar de test database
- FastAPI: `dependency_overrides` voor session fixtures die rollback garanderen
- Testcontainers voor representatieve database — geen SQLite als productie PostgreSQL draait

## Async testing

- `@pytest.mark.asyncio` voor async test functions
- `httpx.AsyncClient` voor async FastAPI endpoints — nooit sync `TestClient` voor async apps
- `async with AsyncClient(app=app)` als context manager voor correcte cleanup

## Verboden

- `scope="session"` voor database fixtures — gedeelde state tussen tests
- `unittest.TestCase` mixen met pytest — verlies van pytest features (fixtures, parametrize)
- `mock.patch` op interne methoden — test het contract, niet de implementatie
