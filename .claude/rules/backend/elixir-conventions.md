---
paths:
  - "**/*.ex"
  - "**/*.exs"
---

# Elixir Conventions

Elixir-specifieke conventies.

---

## Versie & tooling

- Elixir 1.16+ / OTP 26+ — gebruik moderne features (`dbg/2`, improved guards)
- Build tool: `mix` — geen alternatieve build tools
- Formatter: `mix format` met `.formatter.exs` in repo — draait voor elke commit
- Linter: `credo` in strict mode
- Type checking: `dialyzer` via `dialyxir` — typespecs op alle publieke functies

## Naming conventions

- Modules: `PascalCase` — `MyApp.Orders.OrderService`
- Functies en variabelen: `snake_case`
- Atoms voor bekende waarden: `:ok`, `:error`, `:pending`
- Predicate functies: `?` suffix — `valid?/1`, `empty?/1`
- Functies met side effects of die een exception raisen: `!` suffix — `save!/1`
- Private functies: prefix met `do_` als het een recursieve helper is van een publieke functie

## Pattern matching & guards

- Prefer pattern matching in functiehoofden boven `if/cond/case` in de body
- Gebruik guards voor type- en waardechecks: `when is_binary(name)`
- Meerdere function clauses boven één functie met geneste conditionals
- Zet de meest specifieke clause bovenaan

```elixir
# Goed — pattern matching in functiehoofden
def process(%Order{status: :pending} = order), do: ...
def process(%Order{status: :paid} = order), do: ...

# Vermijd — if/case in de body
def process(order) do
  if order.status == :pending, do: ...
end
```

## Code structuur

- Contexts als boundary modules — elke context heeft een duidelijke publieke API
- Interne modules van een context zijn niet toegankelijk van buiten
- Protocols voor polymorfisme — niet pattern matching op struct types in andere modules
- Behaviours voor contracts tussen modules — definieer callbacks expliciet
- Gebruik `defstruct` met `@enforce_keys` — voorkom structs met ontbrekende velden

## Error handling

- Gebruik `{:ok, result}` / `{:error, reason}` tuples als standaard return type
- `with` statement voor het chainen van meerdere ok/error stappen
- Raise exceptions alleen voor echte programmafouten — nooit voor flow control
- Bied zowel `foo/1` (returns tuple) als `foo!/1` (raises) aan waar zinvol
- Custom error structs met `defexception` als de error context nodig heeft

```elixir
with {:ok, user} <- Accounts.get_user(user_id),
     {:ok, order} <- Orders.create(user, attrs) do
  {:ok, order}
end
```

## Concurrency

- `GenServer` voor stateful processen met message-based interface
- `Task` voor eenmalig asynchroon werk — gebruik `Task.Supervisor` voor fault tolerance
- `Agent` alleen voor simpele state wrapping — bij complexere logica: `GenServer`
- Supervision trees: definieer altijd een expliciete restart strategie per child
- Vermijd `Process.send_after` voor scheduling — gebruik libraries of een dedicated GenServer

## Dependency injection

Elixir heeft geen constructors — DI gaat via behaviours en configuratie.

- Definieer behaviours voor externe dependencies — maakt swappen en testen mogelijk
- Configuratie-based injection: `Application.compile_env` voor compile-time, `Application.get_env` voor runtime
- Gebruik `Mox` met behaviours voor test doubles — niet handmatige module swapping

## Logging & observability

- Gebruik `Logger` met structured metadata: `Logger.metadata(request_id: id)`
- Geen string interpolatie in log calls — gebruik metadata: `Logger.info("Order created", order_id: id)`
- `:telemetry` events voor meetbare operaties — sluit aan op Telemetry.Metrics
- Zie `docs/architecture/observability-standards.md` voor verplichte velden en niveaus

## Testing

- ExUnit als test framework
- `doctest` voor functies met voorbeelden in `@doc` — houd ze actueel
- Property-based testing met `StreamData` voor edge case detectie
- `Mox` voor het mocken van behaviours — definieer altijd een behaviour eerst
- Gebruik `async: true` op test modules waar mogelijk voor parallelle uitvoering

## Verboden

- `try/rescue` voor flow control — gebruik ok/error tuples
- `String.to_atom/1` op user input — atom table is niet garbage collected
- Applicatie environment (`Application.get_env`) verspreid door de code — centraliseer configuratie bij startup
- `spawn/1` zonder supervisor — gebruik altijd `Task.Supervisor` of een supervision tree
- `IEx.pry` of `dbg` in gecommitte code
