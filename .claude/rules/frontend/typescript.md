---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript Conventions

TypeScript-specifieke conventies.

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
try {
  const result = await processOrder(orderId)
  return result
} catch (error) {
  logger.error('Order processing failed', { orderId, error })
  throw new OrderProcessingError('Failed to process order', { cause: error })
}
```

## Observability

- Gebruik `pino` voor structured JSON logging in Node.js backend code
- Maak een logger instance per module: `const logger = pino({ name: 'module-naam' })`
- Zie `docs/architecture/observability-standards.md` voor verplichte velden en log niveaus

## Testing

- Test bestanden: `[naam].test.ts` naast bronbestanden of in `__tests__/`
- Mockeer externe dependencies — niet interne modules

## Verboden

- `any` zonder `// eslint-disable` comment met uitleg
- Non-null assertion `!` zonder uitleg
- `console.log` / `console.warn` / `console.error` in productiecode — gebruik de project logger
- Mutable exports (verander geen geëxporteerde objecten)
- `eval()`
