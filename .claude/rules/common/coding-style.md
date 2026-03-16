# Coding Style Rules

Stijlregels die gelden naast wat de linter enforceert.
Laat de linter doen wat de linter kan — dit zijn de regels die linters missen.

---

## Structuur

- Organiseer op feature/domein, niet op type (geen `/controllers`, `/services`, `/repositories` mappen)
- Kleine bestanden: 200-400 regels normaal, 800 absoluut maximum
- Hoge cohesie, lage koppeling — gerelateerde code bij elkaar
- Geen circulaire dependencies

## Functies en methoden

- Één verantwoordelijkheid per functie
- Max 30-40 regels — grotere functies zijn refactoring kandidaten
- Max 3 niveaus nesting — dieper is een waarschuwingssignaal
- Geen flags als parameters om gedrag te schakelen — maak twee functies

## Naamgeving

- Intentionele namen — een naam beschrijft wat, niet hoe
- Geen afkortingen tenzij domein-standaard (bijv. `id`, `url`, `api`)
- Consistent met bestaande codebase naamgeving
- Booleans: `is`, `has`, `can`, `should` prefix

## Immutability

- Maak altijd nieuwe objecten — muteer nooit bestaande
- Geef nieuwe kopieën terug met wijzigingen
- Voorkom side effects in functies

## Comments

- Comments leggen uit *waarom*, niet *wat* — de code legt wat uit
- Geen uitgecommentarieerde code committen
- TODO comments altijd met naam en datum: `// TODO(naam 2025-03-16): ...`

## Magic values

- Geen magic numbers of strings in code
- Definieer als benoemde constanten of enums
