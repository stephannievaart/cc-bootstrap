---
paths:
  - "**/*.py"
---

# Django Rules

---

## Project structuur

Organiseer op feature (Django apps) — niet op technische laag:

```
project/
  apps/
    orders/
      models.py
      views.py
      serializers.py
      services.py      ← business logica hier
      urls.py
      tests/
    users/
  config/
    settings/
      base.py
      development.py
      production.py
    urls.py
    wsgi.py
```

## Views

- Dun — alleen request/response mapping
- Geen business logica in views
- Gebruik Django REST Framework voor API views
- Gebruik `@api_view` decorators of `APIView` classes

```python
class OrderListView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request: Request) -> Response:
        serializer = CreateOrderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        order = OrderService.create(
            user=request.user,
            data=serializer.validated_data
        )
        return Response(
            OrderSerializer(order).data,
            status=status.HTTP_201_CREATED
        )
```

## Services

- Business logica in service klassen of functies
- Services zijn gewone Python — geen Django specifieke decorators
- Gooi domein exceptions — geen HTTP concerns

## Models

- Gebruik `select_related` en `prefetch_related` om N+1 queries te voorkomen
- Model methoden voor domein gedrag op het model
- Geen business logica in model `save()` — gebruik signals spaarzaam

## Serializers

- Validatie in serializers
- Gebruik `validate_[field]` methoden voor veld-specifieke validatie
- Gebruik `validate` voor cross-field validatie

## Settings

- Splits settings in base/development/production
- Geen secrets in settings bestanden — gebruik environment variabelen
- Gebruik `django-environ` of `pydantic-settings`

## Database

- Migraties voor alle model wijzigingen
- Nooit `--fake` zonder expliciete reden
- Zie `/docs/architecture/migration-standards.md` voor zero-downtime regels

## Security

- `ALLOWED_HOSTS` altijd ingevuld in productie
- `DEBUG=False` in productie
- CSRF protection aan (standaard) — niet uitschakelen voor API endpoints
- Gebruik DRF authentication classes

## Testing

- `pytest-django`
- Gebruik `APIClient` voor API tests
- Factory Boy voor test data
- `@pytest.mark.django_db` voor database tests

## Verboden

- Business logica in views
- Raw SQL zonder expliciete reden — gebruik ORM
- `DEBUG=True` in productie
- `SECRET_KEY` hardcoden
- `filter()` zonder limiet op grote tabellen — altijd pagineren
