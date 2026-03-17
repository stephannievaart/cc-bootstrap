---
paths:
  - "**/*.cs"
---

# C# / .NET Conventions

C#-specifieke conventies.

---

## Versie & tooling

- .NET 8+ — gebruik moderne features (primary constructors, collection expressions)
- C# 12+ — `global using`, file-scoped namespaces, raw string literals
- `dotnet format` als formatter — configuratie via `.editorconfig` in repo root
- Analyzers: `Microsoft.CodeAnalysis.NetAnalyzers` altijd aan, treat warnings as errors in CI

## Naming conventions

- Types & methoden: `PascalCase`
- Private velden: `_camelCase` met underscore prefix
- Lokale variabelen & parameters: `camelCase`
- Constanten: `PascalCase` (niet `UPPER_SNAKE_CASE` — C# conventie)
- Interfaces: `I` prefix: `IOrderService`
- Async methoden: `Async` suffix: `GetOrderAsync`
- Test klassen: `[KlasseNaam]Tests`

## Code structuur

- Gebruik `record` voor immutable DTOs en value objects — gebruik `class` voor entities met identity
- Nullable reference types altijd aan: `<Nullable>enable</Nullable>`
- Gebruik pattern matching (`is`, `switch` expressions) boven type checks en casts
- LINQ voor collectie operaties — geen handmatige loops voor filter/map/reduce
- `var` waar het type duidelijk is uit de rechterkant — expliciet type bij ambiguiteit
- File-scoped namespaces: `namespace App.Orders;` — niet het blok-formaat

## Exception handling

- Gooi specifieke exceptions: `NotFoundException`, `ValidationException` — niet `Exception`
- Nooit `catch (Exception)` tenzij top-level middleware
- Gebruik het Result pattern (`Result<T>`) voor verwachte fouten in business logic
- `ArgumentNullException.ThrowIfNull()` en guard clauses aan het begin van methoden
- Geen exceptions voor flow control — exceptions zijn voor uitzonderlijke situaties

## Immutability

- `record` boven `class` voor data objecten
- `init`-only properties voor configuratie objecten
- `ImmutableArray<T>`, `ImmutableList<T>` voor onveranderlijke collecties
- `IReadOnlyList<T>` als return type wanneer de caller niet mag muteren

## Logging & observability

- `Microsoft.Extensions.Logging` als logging API — nooit direct Serilog, NLog, of `Console.WriteLine`
- `ILogger<T>` injecteren via constructor — niet `ILoggerFactory`
- Structured logging met templates: `logger.LogInformation("Order {OrderId} created", orderId)` — geen string interpolatie
- High-performance logging: gebruik `LoggerMessage.Define` of source generators (`[LoggerMessage]`) voor hot paths
- Zie `docs/architecture/observability-standards.md` voor verplichte velden en log niveaus

## Async

- `CancellationToken` propageren door alle async methoden — accepteer als parameter, geef door aan downstream calls
- `ConfigureAwait(false)` in library code — niet in applicatiecode (ASP.NET heeft geen SynchronizationContext)
- `ValueTask<T>` boven `Task<T>` alleen bij high-throughput hot paths waar caching zinvol is
- `IAsyncDisposable` implementeren voor async cleanup (database connections, streams)

## Testing

- xUnit als test framework
- Test method naming: `Should_ReturnError_When_InvalidInput` of `MethodName_Scenario_ExpectedResult`
- NSubstitute als mocking library — prefer boven Moq vanwege type safety
- FluentAssertions voor assertions: `result.Should().BeEquivalentTo(expected)`
- Test projecten: `[ProjectNaam].Tests.Unit`, `[ProjectNaam].Tests.Integration`

## Verboden

- `null` teruggeven uit publieke methoden — gebruik nullable return type of Result pattern
- `Console.WriteLine` in productiecode
- Mutable static state
- String interpolatie in log statements: `logger.LogInformation($"Order {id}")` — gebruik templates
- `async void` — altijd `async Task` (behalve event handlers)
- `Task.Result` of `Task.Wait()` — veroorzaakt deadlocks, gebruik `await`
