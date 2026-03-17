---
paths:
  - "**/*.go"
---

# Go Conventions

Go-specifieke conventies.

---

## Versie & tooling

- Go 1.22+ — gebruik moderne features (range over int, enhanced routing patterns)
- Modules: `go.mod` in de root — geen vendor tenzij het project dit al doet
- Formatter: `gofmt` — geen discussie, geen configuratie
- Linter: `golangci-lint` met project-specifieke `.golangci.yml`
- Geen `go install` of `go get` in CI — pin tool versies via `tools.go` of Makefile

## Naming conventions

- Exported: `PascalCase` — unexported: `camelCase`
- Acroniemen consistent: `HTTPClient`, `userID`, niet `HttpClient`, `userId`
- Interfaces: beschrijf gedrag — `Reader`, `Validator`, niet `IReader`, `ValidatorImpl`
- Interfaces met één methode: naam = methode + `er` suffix (`Reader`, `Writer`, `Closer`)
- Packages: kort, lowercase, enkelvoud — `order`, niet `orders` of `orderService`
- Geen `util`, `common`, `helpers` packages — vind een betere naam
- Booleans: geen `is`/`has` prefix — gebruik direct het adjectief: `connected`, `valid`, `ready`

## Error handling

Go heeft geen exceptions — elke error wordt gecheckt, gewrapt met context, en geretourneerd.

- Return errors als laatste return waarde — `func Do() (Result, error)`
- Wrap met context via `fmt.Errorf("omschrijving: %w", err)` — altijd `%w` voor wrapping
- Check met `errors.Is()` en `errors.As()` — nooit string matching op error messages
- Custom error types alleen wanneer de caller moet switchen op error type
- Geen `panic` in library code — alleen in `main` bij onherstelbare startup fouten
- `defer` voor cleanup — maar let op: defer evalueert argumenten direct

## Code structuur

- `cmd/[naam]/main.go` — entry points, minimale code, alleen wiring
- `internal/` — niet-exporteerbare packages, vrij te refactoren
- Kleine interfaces dicht bij de consumer, niet bij de producer
- Accept interfaces, return structs — maakt testen eenvoudig
- Vermijd package-level variabelen — injecteer dependencies via constructors

## Types & structs

- Definieer eigen types voor domein concepten: `type OrderID string` — voorkom primitive obsession
- Value receivers voor immutable operaties, pointer receivers voor mutatie
- Struct embedding voor compositie — niet voor inheritance
- Mutatie van structs is acceptabel waar idiomatisch (receivers, buffer writes) — prefer value copies waar praktisch

## Concurrency

- Start goroutines alleen als de caller weet dat het gebeurt — documenteer ownership
- Propageer `context.Context` als eerste parameter door de hele call chain
- Gebruik `errgroup.Group` voor parallelle taken met error handling
- Channels voor communicatie, `sync.Mutex` alleen voor gedeelde state die niet via channels kan
- Nooit een goroutine starten zonder shutdown mechanisme — voorkom goroutine leaks
- Gebruik `sync.Once` voor lazy initialization — niet handmatig met flags

## Logging & observability

- `log/slog` als standaard logger (stdlib sinds Go 1.21)
- Structured logging altijd: `slog.Info("order created", "order_id", id, "user_id", uid)`
- Geen string formatting in log calls — gebruik key-value pairs
- Logger injecteren via constructor, niet als package-level variabele
- Zie `docs/architecture/observability-standards.md` voor verplichte velden en niveaus

## Configuration

- Environment variabelen als primaire bron — niet hardcoded
- Parse en valideer bij startup in een `Config` struct — fail fast bij ontbrekende waarden
- Geen `os.Getenv()` verspreid door de code — centraliseer in config package

## Testing

- Table-driven tests als standaard patroon — `tests := []struct{ ... }`
- `testify/assert` en `testify/require` voor assertions
- `httptest.NewServer` voor HTTP integratie tests
- `t.Parallel()` op tests die onafhankelijk zijn — versnelt test suite
- Test helpers met `t.Helper()` markeren — correcte error locatie in output
- Subtests via `t.Run("naam", func(t *testing.T) { ... })` — elke case als subtest is de Go-vertaling van "één assertion per test"
- Test naming: `TestSubject_Scenario` of via subtests `t.Run("returns error when input invalid", ...)`

## Verboden

- `init()` functies — maakt testen onmogelijk en verbergt side effects
- Underscore imports (`_ "pkg"`) buiten `main` of test files
- `interface{}` of `any` zonder documentatie waarom een specifiek type niet kan
- `go vet` warnings negeren
