# Elixir Testing — ExUnit, Mox, Ecto sandbox patronen

Paths: `**/*_test.exs`

Voor tooling keuze (ExUnit, Mox, StreamData) zie `backend/elixir-conventions.md`.
Voor Phoenix test helpers zie `backend/elixir-phoenix.md`.
Voor TDD workflow zie `testing/common.md`.

---

## Mox + behaviour contract

- Altijd een `@behaviour` module definiëren vóór de Mox mock — Mox valideert tegen het contract
- `expect` voor gedragsverificatie — test faalt als de verwachte call niet komt
- `stub` alleen voor setup zonder verificatie — wanneer je het gedrag nodig hebt maar niet checkt
- Mox mocks in de test zelf of in `setup` — niet in globale conftest

## async: true veiligheid

- Veilig bij: Ecto sandbox + geen gedeelde GenServer state + geen PubSub broadcasts
- `async: false` verplicht bij: LiveView tests, PubSub, gedeelde GenServer, globale ETS state
- Documenteer `async: false` reden in comment: `# async: false — uses PubSub broadcasts`

## Pattern matching assertions

- `assert {:ok, %Order{id: id, status: :pending}} = Orders.create(attrs)` — destructure in de assertion
- Geen `case`/`if`/`cond` in tests — pattern match direct in `assert`
- `assert_receive`/`refute_receive` voor message-based tests

## Factory discipline

- Minimale defaults in factory — test specificeert wat relevant is voor die test
- `insert(:order, status: :pending)` — expliciet over wat de test valideert
- Nooit op factory defaults vertrouwen voor test intent — de lezer moet zien wat belangrijk is

## Ecto sandbox

- `DataCase` voor alle database tests — sandbox handelt transactie rollback automatisch
- Geen handmatige cleanup in `on_exit` callbacks — laat de sandbox zijn werk doen
- `Ecto.Adapters.SQL.Sandbox.checkout` in setup, niet per test

## Doctest actueel houden

- `@doc` voorbeelden zijn executable tests via `doctest MyModule`
- Update doctests bij elke gedragswijziging — verouderde voorbeelden misleiden
- Draai doctests in CI — ze zijn net zo belangrijk als unit tests

## Verboden

- `async: true` bij LiveView, PubSub, of GenServer tests — race conditions
- Mox zonder behaviour — geen contractvalidatie, mock kan uit sync raken
- Handmatige database cleanup — gebruik Ecto sandbox
