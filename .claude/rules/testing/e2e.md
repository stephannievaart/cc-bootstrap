# E2E Testing — Playwright

Paths: `**/e2e/**`, `**/playwright.config.*`

Voor teststrategie (wanneer e2e) zie `docs/architecture/testing-standards.md`.
Voor TDD workflow zie `testing/common.md`.

---

## Selectors

- `getByRole`/`getByLabel` primair — test zoals een gebruiker de pagina ervaart
- `data-testid` als fallback wanneer geen semantische selector mogelijk is
- Nooit CSS classes of XPath — breken bij elke styling of structuurwijziging

## Page Object Model

- Elke pagina of complex component een POM class
- POM encapsuleert selectors en acties — assertions horen in de test, niet in de POM
- Hergebruik POM classes tussen tests — geen gedupliceerde selectors

## Test isolatie

- Schone state per test — geen afhankelijkheid van andere tests of testvolgorde
- Data setup via API calls, niet via UI clicks — sneller en stabieler
- Tests zijn parallel-safe — geen gedeelde test accounts of data

## Authenticatie

- `storageState` hergebruiken voor geauthenticeerde tests — niet elke test opnieuw inloggen
- Setup project in `playwright.config` voor auth state generatie
- Gescheiden storage states per rol als de app role-based access heeft

## Wachten

- Vertrouw Playwright auto-waiting — het wacht automatisch op elementen
- Expliciete `waitFor` alleen voor niet-standaard condities (bijv. netwerk idle)
- `page.waitForResponse()` voor specifieke API calls waar timing cruciaal is

## CI integratie

- Headless in CI, headed optioneel lokaal
- Screenshots en traces automatisch bij failure — configureer in `playwright.config`
- Retries: max 2 in CI, 0 lokaal — lokale failures moeten reproduceerbaar zijn

## Structuur

- Eén file per user flow — niet per pagina
- Beschrijf tests in gebruikerstaal: `test('klant kan bestelling annuleren')`
- Max 10 stappen per test — langere flows opsplitsen

## Verboden

- `waitForTimeout()` — altijd een expliciete conditie gebruiken
- CSS class selectors — breken bij styling wijzigingen
- Test-afhankelijkheden — elke test moet onafhankelijk kunnen draaien
- `page.evaluate()` voor assertions — assertions via Playwright API, niet via browser JS
