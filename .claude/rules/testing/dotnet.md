# .NET Testing — xUnit, NSubstitute, WebApplicationFactory patronen

Paths: `**/*Tests.cs`, `**/*Test.cs`

Voor tooling keuze (xUnit, NSubstitute, FluentAssertions) zie `backend/dotnet-conventions.md`.
Voor WebApplicationFactory en Testcontainers zie `backend/dotnet-aspnet.md`.
Voor TDD workflow zie `testing/common.md`.

---

## Fact vs Theory

- `[Fact]` voor deterministische single-case tests
- `[Theory]` + `[InlineData]` voor parameterized grenswaarde tests
- Als je dezelfde test kopieert met andere waarden → maak er een `[Theory]` van

## NSubstitute patronen

- `Substitute.For<T>()` voor mocks — interfaces en virtual members
- `.Returns()` voor gedrag setup, `.Received()` voor interactie verificatie
- `Arg.Any<T>()` en `Arg.Is<T>(predicate)` voor argument matching
- Geen Moq — project standaard is NSubstitute

## WebApplicationFactory

- Override dependencies in `ConfigureWebHost` via `ConfigureTestServices`
- Eén factory per test class via `IClassFixture<WebApplicationFactory<Program>>`
- Nooit handmatig `TestServer` aanmaken — `WebApplicationFactory` beheert de lifecycle

## FluentAssertions

- `Should().Be()`, `Should().Contain()`, `Should().BeEquivalentTo()` voor alle assertions
- `BeEquivalentTo()` met `.Excluding(x => x.Id)` voor generated fields
- Nooit xUnit `Assert.*` — FluentAssertions geeft betere foutmeldingen

## Database strategie

- In-memory EF provider voor unit tests — snel maar niet representatief voor SQL gedrag
- Testcontainers voor integratie tests — echte database, representatief
- Weet het verschil: in-memory mist constraints, transactions, en SQL-specifiek gedrag

## Async tests

- Altijd `async Task` als return type — nooit `async void`
- xUnit awaits automatisch — geen speciale configuratie nodig
- `CancellationToken` meegeven waar de API het accepteert

## Verboden

- `Assert.Equal`/`Assert.True` — gebruik FluentAssertions
- `Thread.Sleep()` in tests — gebruik `Task.Delay` of polling met timeout
- `[Fact]` met hardcoded test data die `[Theory]` moet zijn — DRY
