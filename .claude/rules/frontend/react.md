---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.jsx"
---

# React Rules

React-specifieke regels.

---

## Component structuur

Organiseer op feature — niet op component type:

```
src/
  features/
    orders/
      components/
        OrderCard.tsx
        OrderList.tsx
      hooks/
        useOrders.ts
      api/
        ordersApi.ts
      types.ts
      index.ts
  shared/
    components/   ← herbruikbare UI componenten
    hooks/        ← herbruikbare hooks
    utils/
```

## Component regels

- Functionele componenten altijd — geen class components
- Één component per bestand
- Exporteer als default export
- Props type altijd expliciet definiëren

```tsx
type OrderCardProps = {
  readonly order: Order
  readonly onSelect: (id: string) => void
}

export default function OrderCard({ order, onSelect }: OrderCardProps) {
  return (...)
}
```

## Hooks

- Custom hooks voor herbruikbare logica
- Hooks beginnen altijd met `use`
- Geen business logica in componenten — extraheer naar hooks

## State management

- `useState` voor lokale UI state
- `useReducer` voor complexe lokale state
- React Query / TanStack Query voor server state
- Geen globale state voor server data — dat is caching werk

## Performance

- `React.memo` alleen als je een meetbaar probleem hebt
- `useCallback` en `useMemo` alleen bij aantoonbare performance issues
- Lazy loading voor routes: `React.lazy` + `Suspense`

## Error handling

- Error boundaries voor component crashes
- Behandel altijd loading, error, en empty states in data-fetching componenten

```tsx
if (isLoading) return <LoadingSpinner />
if (error) return <ErrorMessage error={error} />
if (!data?.length) return <EmptyState />
return <OrderList orders={data} />
```

## Forms

- Gebruik React Hook Form voor formulieren
- Validatie met Zod schema's
- Controlled components voor complexe interacties

## Testing

- Vitest + React Testing Library
- Test gedrag, niet implementatie
- Geen snapshot tests
- `userEvent` voor interacties (niet `fireEvent`)

## Verboden

- `dangerouslySetInnerHTML` zonder sanitization
- Inline functies als props op veelgerenderde componenten (performance)
- `any` in props types
- Direct DOM manipulatie — gebruik refs alleen als laatste optie
- `useEffect` voor dingen die event handlers kunnen oplossen
