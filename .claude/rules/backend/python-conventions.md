---
paths:
  - "**/*.py"
---

# Python Conventions

Python-specifieke conventies.

---

## Versie & tooling

- Python 3.11+
- Dependency management: `uv` of `poetry` — gebruik wat het project al heeft
- Formatter & linter: `ruff` (format + lint in één tool)
- Type checking: `mypy` — strict mode altijd in nieuwe projecten

## Type hints

- Type hints zijn verplicht op alle publieke functies en methoden
- Gebruik `from __future__ import annotations` voor forward references
- Gebruik `TypeAlias` (3.11) of `type` statement (3.12+) voor complexe types
- Geen `Any` tenzij echt onvermijdelijk — documenteer waarom

```python
def process_order(order_id: int, user: User) -> OrderResult:
    ...
```

## Code structuur

- Gebruik dataclasses of Pydantic models voor data
- Gebruik `@dataclass(frozen=True, slots=True)` voor immutable data
- Gebruik `StrEnum` (3.11+) voor string enumeraties
- Prefer `pathlib.Path` boven `os.path`
- Gebruik context managers (`with`) voor resources

## Logging

- Gebruik `structlog` met JSON output — niet de stdlib `logging` direct
- Configureer eenmalig bij startup via `structlog.configure()`
- Bind context progressief: `logger = logger.bind(order_id=order_id)`
- Geen string formatting in log calls — gebruik key-value pairs
- Zie `docs/architecture/observability-standards.md` voor verplichte velden en niveaus

## Configuration

- Gebruik Pydantic `BaseSettings` voor environment variabelen
- Validatie bij startup — fail fast bij ontbrekende waarden
- Nooit `os.getenv()` verspreid door de code — centraliseer in een `Settings` class

## Dependency injection

- Injecteer via constructor (`__init__`) — geen module-level singletons
- Gebruik `Protocol` voor abstracties — niet `ABC` tenzij gedeeld gedrag nodig is
- Factory functions voor het samenstellen van de dependency graph

## Async

- Gebruik `async/await` consistent — mix niet met sync in dezelfde laag
- Gebruik `asyncio.TaskGroup` (3.11+) boven `asyncio.gather()` — veiliger bij exceptions
- Gebruik `httpx` voor async HTTP calls (niet `requests`)

## Verboden

- `from module import *`
- Mutable default arguments: `def f(items=[]):`
- `type: ignore` zonder comment waarom
