---
paths:
  - "**/*.ts"
  - "**/*.html"
---

# Angular Rules

Angular-specifieke regels.

---

## Project structuur

Organiseer op feature — niet op technische laag:

```
src/app/
  features/
    orders/
      order-list.component.ts
      order-detail.component.ts
      order.service.ts
      order.model.ts
      order.routes.ts
    shared/
  core/
    auth/
    interceptors/
    guards/
  shared/
    components/
    directives/
    pipes/
```

- Standalone components als standaard — `NgModule` alleen voor legacy code
- Elke feature heeft eigen routes file met lazy loading
- `core/` voor singleton services en app-brede configuratie

## Component regels

- Standalone components altijd — `standalone: true`
- Smart (container) vs dumb (presentational) scheiding:
  - Smart: injecteert services, beheert state, geen UI logica
  - Dumb: alleen `input()` / `output()`, puur presentatie, makkelijk testbaar
- `ChangeDetectionStrategy.OnPush` op alle componenten — geen uitzondering
- Gebruik signals voor reactieve state:
  - `signal()` voor lokale state
  - `computed()` voor afgeleide waarden
  - `effect()` spaarzaam — alleen voor side effects die niet anders kunnen
- Prefix: `app-` voor app-componenten, feature-prefix voor feature-specifiek

## Services & DI

- `providedIn: 'root'` voor singleton services
- Feature-scoped services: provide in de feature route config
- Services zijn stateless waar mogelijk — state in signals of stores
- Geen business logica in componenten — delegeer naar services

## State management

- Signals als primaire state primitive — niet BehaviorSubject voor nieuwe code
- Component state: `signal()` en `computed()`
- Feature state: signal-based store (NgRx SignalStore of eigen pattern)
- NgRx ComponentStore of global store alleen bij bewezen complexiteit (meerdere features delen state)
- Geen state management library toevoegen zonder ADR

## RxJS

- Gebruik RxJS voor streams en event-gebaseerde patronen (WebSocket, complexe async flows)
- Signals voor synchrone/eenvoudige state — niet alles hoeft Observable te zijn
- Unsubscribe strategie: `takeUntilDestroyed()` in injection context
- `async` pipe in templates voor Observables — nooit handmatig subscriben in component
- Operators: prefer `switchMap` voor requests, `exhaustMap` voor submits, `concatMap` voor volgorde
- Geen geneste subscribes — gebruik operators om streams te combineren

## Forms

- Reactive forms altijd — geen template-driven forms
- Typed forms (`FormGroup<T>`) met expliciete types
- Validatie in form definition — niet in template
- Custom validators als pure functies
- Toon errors pas na interactie: `hasError('required') && control.touched`

## Routing

- Lazy loading per feature via `loadChildren` of `loadComponent`
- Functionele guards en resolvers — geen class-based guards
- Route data typen met `Route['data']` of custom types

## Testing

- Jest of Jasmine — gebruik wat het project al heeft
- `TestBed` voor integratie tests met DI
- Component harness (`HarnessLoader`) voor component interactie tests
- Isoleer unit tests: test services zonder `TestBed` waar mogelijk
- `provideHttpClientTesting()` voor HTTP service tests

## Verboden

- `subscribe()` in componenten zonder unsubscribe strategie
- `ChangeDetectionStrategy.Default` op nieuwe componenten
- `any` in template expressions
- Direct DOM manipulatie — gebruik renderer of signals
- `NgModule` voor nieuwe features — standalone only
- `ngOnChanges` voor input reactie — gebruik `input()` signals of `computed()`
