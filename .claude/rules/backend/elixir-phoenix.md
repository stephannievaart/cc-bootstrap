---
paths:
  - "**/*.ex"
  - "**/*.exs"
---

# Phoenix Rules

Phoenix-specifieke regels.

---

## Project structuur

Business/domein code (`lib/my_app/`) volgt feature-organisatie.
De web layer (`lib/my_app_web/`) volgt Phoenix-conventie met type-gebaseerde mappen — dit is een bewuste afwijking.

```
lib/my_app/
  accounts/            # Context: Accounts
    user.ex            # Ecto schema
    accounts.ex        # Context module (publieke API)
  orders/              # Context: Orders
    order.ex
    order_item.ex
    orders.ex
lib/my_app_web/
  controllers/
    order_controller.ex
    order_json.ex
  live/
    order_live/
      index.ex
      show.ex
      form_component.ex
  components/
    core_components.ex
  router.ex
  endpoint.ex
```

## Controllers & LiveView

- Controllers zijn dun — alleen request/response mapping, delegeer naar contexts
- Gebruik `action_fallback` met een `FallbackController` voor consistente error responses
- LiveView voor interactieve pagina's — geen LiveView voor statische content
- LiveView events afhandelen in `handle_event/3` — business logica in de context, niet in de LiveView
- Assigns minimaal houden — alleen wat de template nodig heeft

```elixir
def create(conn, %{"order" => order_params}) do
  case Orders.create_order(order_params) do
    {:ok, order} -> conn |> put_status(:created) |> render(:show, order: order)
    {:error, changeset} -> conn |> put_status(:unprocessable_entity) |> render(:errors, changeset: changeset)
  end
end
```

## Contexts als service layer

- Elke context is de enige toegang tot zijn domein — geen directe Repo calls buiten contexts
- Context functies accepteren en retourneren domein types — geen Plug.Conn of socket
- Contexts kennen geen web layer — geen HTTP, geen LiveView, geen channels
- Houd contexts gefocust: als een context te groot wordt, splits in sub-contexts

## Ecto & changesets

- Validatie altijd via changesets — nooit handmatige validatie in controllers
- Changesets voor elke operatie: `create_changeset/2`, `update_changeset/2`
- Gebruik `Ecto.Multi` voor operaties die meerdere database wijzigingen atomair moeten uitvoeren
- Migraties: gebruik `mix ecto.gen.migration` — zie `docs/architecture/database-standards.md`
- Prefer `Repo.insert/update` met changeset boven raw SQL
- Vermijd `Repo.get!` in controllers — gebruik `Repo.get` met expliciete error handling

```elixir
def create_changeset(order, attrs) do
  order
  |> cast(attrs, [:product_id, :quantity])
  |> validate_required([:product_id, :quantity])
  |> validate_number(:quantity, greater_than: 0)
  |> foreign_key_constraint(:product_id)
end
```

## Channels & PubSub

- Phoenix.PubSub voor interne real-time communicatie
- Channels voor client-facing WebSocket communicatie
- Autoriseer in `join/3` — weiger ongeautoriseerde subscriptions
- Broadcast via PubSub vanuit contexts — niet vanuit controllers of LiveViews
- Houd payloads klein — stuur IDs en laat clients data ophalen indien nodig

## Security

- Plug pipeline voor authenticatie en autorisatie — niet in individuele controllers
- CSRF bescherming: standaard aan voor browser requests
- Rate limiting op API endpoints
- `Plug.SSL` voor HTTPS afdwingen in productie
- Input validatie via Ecto changesets (zie ook Ecto & changesets sectie)

## Testing

- `ConnTest` voor controller tests — test de volledige plug pipeline
- `DataCase` voor context tests met database — sandbox voor isolatie
- Gebruik `Phoenix.LiveViewTest` voor LiveView tests
- Factory functies (ex_machina of eigen) voor test data — geen fixtures
- Test contexts onafhankelijk van de web layer

```elixir
test "creates order with valid data", %{conn: conn} do
  attrs = %{product_id: product.id, quantity: 3}

  conn = post(conn, ~p"/api/orders", order: attrs)

  assert %{"id" => id} = json_response(conn, 201)["data"]
  assert Orders.get_order(id)
end
```

## Verboden

- Directe `Repo` calls in controllers of LiveViews — ga via contexts
- Business logica in templates of LiveView renders
- `Repo.get!` zonder rescue in request handling — gebruik `Repo.get` + error tuple
- N+1 queries — gebruik `Repo.preload` of `from` met `preload`
- Hardcoded secrets in config — gebruik `runtime.exs` met environment variabelen
