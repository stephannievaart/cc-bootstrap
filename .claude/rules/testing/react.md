# React Testing — Testing Library patronen

Paths: `**/*.test.tsx`, `**/*.test.ts`, `**/*.spec.tsx`

Voor tooling keuze (Vitest + RTL) zie `frontend/react.md`.
Voor TDD workflow zie `testing/common.md`.

---

## Query prioriteit

- `getByRole` > `getByLabelText` > `getByText` > `getByTestId`
- Semantische queries eerst — test zoals een screenreader de pagina ervaart
- `getByTestId` alleen als geen semantische query mogelijk is

## userEvent is async

- Altijd `await user.click()`, `await user.type()` — userEvent is async sinds v14
- Setup via `const user = userEvent.setup()` aan het begin van de test
- Eén `setup()` call per test — niet per interactie

## Async patronen

- `findBy*` voor elementen die verschijnen na async operatie (data laden, state update)
- `waitFor` alleen voor assertions op elementen die al in de DOM zijn maar van waarde veranderen
- Geen side effects in `waitFor` callback — alleen assertions

## Context en providers

- Custom `render` wrapper in `test-utils` met alle benodigde providers (router, theme, query client)
- Importeer `render` uit eigen `test-utils`, niet uit `@testing-library/react`
- Niet per test opnieuw providers opbouwen — DRY via de wrapper

## Hook testing

- `renderHook` uit `@testing-library/react` voor custom hooks
- Test via het resultaat (`result.current`), niet via component internals
- Hooks die UI nodig hebben: test via een component, niet via `renderHook`

## Verboden

- `container.querySelector()` — gebruik RTL queries
- Snapshot tests — broos, lage signaalwaarde, reviewers skippen de diff
- `fireEvent` — gebruik `userEvent` voor realistische interactie
- Testen op component state of props — test gedrag en output
