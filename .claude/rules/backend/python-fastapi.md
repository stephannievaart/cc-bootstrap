---
paths:
  - "**/*.py"
---

# FastAPI Rules

FastAPI-specifieke regels.

---

## Project structuur

Organiseer op feature — niet op technische laag:

```
src/
  features/
    orders/
      router.py
      service.py
      models.py
      repository.py
      dependencies.py
    users/
      ...
  core/
    config.py
    database.py
    security.py
    exceptions.py
  main.py
```

- Elke feature is een package met eigen router, service, models
- `core/` voor gedeelde infrastructuur
- `main.py` alleen app factory en router registratie

## Routers / endpoints

- Routers zijn dun — alleen request/response mapping en dependency injection
- Geen business logica in router functies
- Gebruik `Depends()` voor alle dependencies — nooit direct importeren en aanroepen
- Response model altijd expliciet: `response_model=OrderResponse`
- Status codes expliciet: `status_code=status.HTTP_201_CREATED`

```python
@router.post("/orders", response_model=OrderResponse, status_code=status.HTTP_201_CREATED)
async def create_order(
    request: CreateOrderRequest,
    service: OrderService = Depends(get_order_service),
) -> OrderResponse:
    return await service.create(request)
```

## Dependency injection

- Gebruik `Depends()` voor alles: services, repositories, database sessies, auth
- Generator dependencies voor resources die cleanup nodig hebben:
  ```python
  async def get_db() -> AsyncGenerator[AsyncSession, None]:
      async with session_factory() as session:
          yield session
  ```
- Lifespan handler voor startup/shutdown logica — geen `@app.on_event` (deprecated)
- Dependencies zijn composable: hogere dependencies injecteren lagere

## Pydantic models

- Aparte models voor request, response, en database — nooit hergebruiken
- `model_config = ConfigDict(strict=True)` voor strikte type coercion
- Gebruik `Field()` voor validatie: `Field(min_length=1, max_length=255)`
- Computed fields met `@computed_field` voor afgeleide waarden
- Serialization aliassen voor API conventies: `Field(alias="orderId")`

## Error handling

- Gooi `HTTPException` niet in services — alleen in routers of exception handlers
- Services gooien domein exceptions: `OrderNotFoundError`, `InsufficientStockError`
- Centrale exception handlers registreren op de app:
  ```python
  @app.exception_handler(OrderNotFoundError)
  async def handle_order_not_found(request: Request, exc: OrderNotFoundError) -> JSONResponse:
      return JSONResponse(status_code=404, content={"error": str(exc), "code": "ORDER_NOT_FOUND"})
  ```
- Validatiefouten worden automatisch afgevangen — pas het response format aan via custom handler

## Security

- OAuth2 met `OAuth2PasswordBearer` of custom scheme
- JWT validatie als dependency: `current_user: User = Depends(get_current_user)`
- Autorisatie checks in dependencies — niet in elke router functie apart
- CORS configuratie expliciet — nooit `allow_origins=["*"]` in productie

## Database

- SQLAlchemy 2.0+ met async engine en `AsyncSession`
- Alembic voor migraties — `async` Alembic configuratie — zie `docs/architecture/database-standards.md`
- Repository pattern: database queries geïsoleerd in repository classes
- Geen raw SQL in routers of services — alleen in repositories
- Transacties op service niveau via de geïnjecteerde sessie

## Observability

- OpenTelemetry voor distributed tracing — `opentelemetry-instrumentation-fastapi`
- Middleware voor request logging: method, path, status, duur
- Structlog integratie met trace context binding
- Health endpoint: `GET /health` met readiness en liveness checks

## Testing

- `pytest` met `pytest-asyncio` voor async tests
- `httpx.AsyncClient` met `ASGITransport` voor endpoint tests — niet de sync `TestClient` voor async apps
- `override_dependency` voor het vervangen van dependencies in tests:
  ```python
  app.dependency_overrides[get_order_service] = lambda: mock_service
  ```
- Fixtures voor database sessie, test client, en authenticated user
- Testcontainers voor database integratie tests

## Verboden

- `allow_origins=["*"]` in CORS config voor productie
- Synchrone database calls in async endpoints — gebruik `AsyncSession`
- `@app.on_event("startup")` — gebruik lifespan context manager
- Globale mutable state op module niveau als dependency
