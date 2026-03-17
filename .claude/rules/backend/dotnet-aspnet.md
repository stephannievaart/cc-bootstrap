---
paths:
  - "**/*.cs"
---

# ASP.NET Core Rules

ASP.NET Core-specifieke regels.

---

## Project structuur

Organiseer op feature/domein — niet op technische laag:

```
src/[Service].Api/
  [Feature]/
    [Feature]Endpoint.cs
    [Feature]Service.cs
    [Feature]Repository.cs
    [Feature]Request.cs
    [Feature]Response.cs
  Shared/
    Configuration/
    Exceptions/
    Security/
```

## Endpoints / Controllers

- Prefer Minimal APIs voor nieuwe projecten — controllers alleen als het project ze al gebruikt
- Dun — alleen request/response mapping, geen business logica
- Valideer input met FluentValidation of `IValidatableObject`
- Gebruik `TypedResults` voor compile-time type-safe responses

## Services & DI

- Built-in DI container — geen Autofac of andere containers tenzij al in gebruik
- Registreer services met correcte lifetime: `Scoped` voor request-gebonden, `Singleton` voor stateless, `Transient` als default ongeschikt
- Constructor injection — nooit `[FromServices]` in method parameters of service locator
- Registratie gegroepeerd per feature: `builder.Services.AddOrderFeature()`

## Middleware pipeline

- Volgorde: exception handling > security > routing > endpoints
- Custom middleware als class met `InvokeAsync` — geen inline lambda's voor complexe logica
- Middleware mag geen business logica bevatten — alleen cross-cutting concerns

## Configuratie

- Options pattern met `IOptions<T>` of `IOptionsSnapshot<T>` voor configuratie
- Valideer met `ValidateDataAnnotations()` en `ValidateOnStart()`
- Geen losse `IConfiguration.GetValue()` calls verspreid over de codebase
- Bind configuratie secties: `builder.Services.Configure<PaymentOptions>(config.GetSection("Payment"))`

## Exception handling

- `ProblemDetails` (RFC 9457) als standaard error response — geen eigen error DTOs
- Gebruik `IExceptionHandler` (ASP.NET Core 8+) voor globale exception mapping
- Domein exceptions in de service laag — geen HTTP status codes in services
- `app.UseStatusCodePages()` en `app.UseExceptionHandler()` in de pipeline

## Security

- Authentication schemes via `builder.Services.AddAuthentication().AddJwtBearer()`
- Authorization policies: `builder.Services.AddAuthorizationBuilder().AddPolicy("CanManageOrders", ...)`
- `[Authorize]` of `RequireAuthorization()` op endpoints — nooit open tenzij expliciet gedocumenteerd
- CORS strict configureren — geen wildcard origins in productie

## Database

- EF Core als ORM — migrations via `dotnet ef`
- Zie `docs/architecture/database-standards.md` voor migratie richtlijnen
- `DbContext` als scoped service — nooit singleton
- Geen lazy loading: `UseLazyLoadingProxies()` is verboden — gebruik explicit loading of projection

## Observability

- OpenTelemetry via `builder.Services.AddOpenTelemetry()` voor traces en metrics
- Health checks: `builder.Services.AddHealthChecks().AddDbContextCheck<AppDbContext>()`
- Liveness op `/health/live`, readiness op `/health/ready`
- Zie `docs/architecture/observability-standards.md` voor verplichte velden
- Zie `docs/architecture/resilience-patterns.md` voor health check semantiek

## Resilience

- `Microsoft.Extensions.Http.Resilience` voor HTTP clients — bouwt op Polly v8
- Configureer via `AddStandardResilienceHandler()` of custom pipelines
- Elke externe dependency krijgt een eigen benoemde `HttpClient` met eigen resilience config
- Zie `docs/architecture/resilience-patterns.md` voor thresholds en backoff strategie

## Testing

- `WebApplicationFactory<Program>` voor integratie tests — start de volledige pipeline
- Testcontainers voor database integratie tests
- `HttpClient` via `factory.CreateClient()` — nooit handmatig `TestServer` instantieren
- Gebruik `IServiceCollection` overrides om dependencies te vervangen in tests

## Verboden

- `[FromServices]` in action parameters — gebruik constructor injection
- Business logica in controllers of endpoints
- `UseLazyLoadingProxies()` — veroorzaakt N+1 queries
- `app.UseDeveloperExceptionPage()` in productie configuratie
- Singleton `DbContext` — is niet thread-safe
