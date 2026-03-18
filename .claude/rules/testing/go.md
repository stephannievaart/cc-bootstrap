# Go Testing — Table-driven, testify, httptest patronen

Paths: `**/*_test.go`

Voor basis testregels (testify, httptest, build tags) zie `backend/go.md`.
Voor TDD workflow zie `testing/common.md`.

---

## Table-driven structuur

- Elke test case als `t.Run(tc.name, ...)` subtest — duidelijke output bij failures
- Struct met columns: `name`, `input`, `want`, `wantErr` — consistent per test file
- Nooit inline `if`/`switch` in een loop als vervanging voor subtests

## require vs assert

- `require` voor precondities die de rest van de test zinloos maken (setup, nil checks)
- `assert` voor verificatie — laat de test doorlopen zodat je alle failures ziet
- Nooit `require` en `assert` mixen op dezelfde assertion — kies bewust

## t.Parallel() standaard

- `t.Parallel()` als eerste regel in elke test en subtest — tenzij gedocumenteerde reden
- `httptest.NewServer` aanmaken BINNEN de subtest bij parallel tests — niet gedeeld
- Shared state vermijden — als het moet, gebruik `sync.Mutex` expliciet

## Interface mocking

- Definieer kleine interfaces bij de consumer — niet grote interfaces bij de provider
- `testify/mock` of handgeschreven mocks voor test doubles
- Mock alleen geëxporteerde interfaces — unexported interfaces zijn implementatiedetail

## httptest juist inzetten

- `httptest.NewServer` voor integratie tests — test de hele HTTP stack
- Directe handler call via `handler.ServeHTTP(rr, req)` voor unit tests — sneller, geen netwerk
- `httptest.NewRecorder()` voor response capture in unit tests

## Verboden

- `time.Sleep()` in tests — gebruik channels, `testify/assert.Eventually`, of `time.After` met select
- `t.Log()` als assertion vervanging — log is geen verificatie
- Testen van unexported functions vanuit `_test.go` in extern package — test de publieke API
