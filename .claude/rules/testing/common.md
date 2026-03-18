# Testing Rules

Voor teststrategie (wanneer welke testtypen) zie `docs/architecture/testing-standards.md`.

---

## TDD — strikt

Dit project volgt TDD zonder uitzondering:
1. **Red** — Stap 3: tests geschreven VOOR implementatie. Ze moeten falen.
2. **Green** — Stap 4: implementatie maakt tests groen. Niet meer code dan nodig.
3. **Refactor** — Code opschonen terwijl tests groen blijven.

- Developer agents schrijven GEEN tests — alleen de test-automation agent.
- Een test die groen is zonder implementatie test niets nuttigs.

## Kwaliteitseisen

- Elk acceptatiecriterium is gedekt door minimaal één geautomatiseerde test
- Code coverage is een signaal, niet een doel — 80% is een gezonde ondergrens,
  maar lage coverage op kritieke paden is erger dan een laag totaalpercentage

### Altijd testen

- Business logica en domeinregels
- Validatieregels en grenswaarden
- Error paths en exception handling
- Security-gevoelige flows (auth, autorisatie, input sanitization)
- State transities en hun guards

### Niet testen om te testen

- Triviale getters/setters zonder logica
- Doorgeefluiken die alleen delegeren
- Framework boilerplate en gegenereerde code

## Verboden

- Tests aanpassen om ze groen te krijgen in plaats van de code te fixen
- Hardcoded timeouts als vervanging voor correcte async handling
- Tests skippen zonder gedocumenteerde reden
