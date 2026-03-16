---
paths:
  - "**/*.py"
---

# Python Conventions

---

## Versie & tooling

- Python 3.11+
- Dependency management: `uv` of `poetry` — gebruik wat het project al heeft
- Formatter: `black` — geen discussie over stijl
- Linter: `ruff`
- Type checking: `mypy` — strict mode waar mogelijk

## Type hints

- Type hints zijn verplicht op alle publieke functies en methoden
- Gebruik `from __future__ import annotations` voor forward references
- Gebruik `TypeAlias` voor complexe types
- Geen `Any` tenzij echt onvermijdelijk — documenteer waarom

```python
def process_order(order_id: int, user: User) -> OrderResult:
    ...
```

## Naming conventions

- Functies & variabelen: `snake_case`
- Classes: `PascalCase`
- Constanten: `UPPER_SNAKE_CASE`
- Private: `_prefix` voor intern gebruik
- Modules: `snake_case`

## Code structuur

- Gebruik dataclasses of Pydantic models voor data
- Gebruik `@dataclass(frozen=True)` voor immutable data
- Prefer `pathlib.Path` boven `os.path`
- Gebruik context managers (`with`) voor resources

## Error handling

- Gebruik specifieke exceptions — niet bare `except:`
- Definieer custom exceptions voor domein fouten
- Gebruik `logging` module — geen `print()`

```python
# Goed
try:
    result = process(data)
except ValidationError as e:
    logger.warning("Validation failed", extra={"error": str(e)})
    raise

# Fout
try:
    result = process(data)
except:
    pass
```

## Async

- Gebruik `async/await` consistent — mix niet met sync in dezelfde laag
- Gebruik `asyncio.gather()` voor parallelle operaties
- Gebruik `httpx` voor async HTTP calls (niet `requests`)

## Testing

- pytest
- Fixtures voor herbruikbare test data
- `pytest-asyncio` voor async tests
- Gebruik `freezegun` voor tijd-afhankelijke tests
- Test bestanden: `test_[module].py`

## Verboden

- `from module import *`
- Mutable default arguments: `def f(items=[]):`
- `type: ignore` zonder comment waarom
- Bare `except:` of `except Exception:`
- `print()` in productiecode
