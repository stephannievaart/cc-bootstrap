---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript Conventions

---

## Versie & tooling

- TypeScript 5.x — strict mode verplicht
- Runtime: Node.js 20+ of Bun
- Formatter: Prettier
- Linter: ESLint met TypeScript plugin
- Package manager: `pnpm` of `npm` — gebruik wat het project al heeft

## TypeScript configuratie

`tsconfig.json` minimaal:
```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "exactOptionalPropertyTypes": true
  }
}
```

## Types

- Geen `any` — gebruik `unknown` en type guards
- Prefer `type` boven `interface` voor data shapes
- Gebruik `interface` voor extensible contracts (class implementaties)
- Gebruik `readonly` op properties die niet mogen wijzigen
- Gebruik discriminated unions voor state modeling

```typescript
// Goed
type Result<T> =
  | { success: true; data: T }
  | { success: false; error: string }

// Fout
type Result = any
```

## Naming conventions

- Types & interfaces: `PascalCase`
- Functies & variabelen: `camelCase`
- Constanten: `UPPER_SNAKE_CASE` of `camelCase` (consistent per project)
- Bestanden: `kebab-case.ts`
- Test bestanden: `[naam].test.ts`

## Null handling

- Gebruik `strictNullChecks` — altijd aan
- Gebruik optional chaining `?.` en nullish coalescing `??`
- Nooit non-null assertion `!` zonder comment waarom het veilig is

## Async

- Altijd `async/await` — geen `.then()` chains
- Error handling via try/catch — niet `.catch()` chains
- Gebruik `Promise.all()` voor parallelle operaties

## Imports

- Gebruik absolute imports via path aliases — geen `../../../`
- Groepeer: externe libraries, interne modules, relatieve imports
- Geen circulaire imports

## Error handling

- Gebruik custom error classes voor domein fouten
- Geef errors altijd door of log ze — nooit stil opslokken

```typescript
// Goed
try {
  const result = await processOrder(orderId)
  return result
} catch (error) {
  logger.error('Order processing failed', { orderId, error })
  throw new OrderProcessingError('Failed to process order', { cause: error })
}
```

## Testing

- Vitest (voor Vite projecten) of Jest
- `@testing-library` voor UI component tests
- Mockeer externe dependencies — niet interne modules
- Test bestanden naast de bronbestanden of in `__tests__/`

## Verboden

- `any` zonder `// eslint-disable` comment met uitleg
- Non-null assertion `!` zonder uitleg
- `console.log` in productiecode
- Mutable exports (verander geen geëxporteerde objecten)
- `eval()`
