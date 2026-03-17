# Coding Style Rules

Regels die linters niet afdwingen. Laat de linter doen wat de linter kan.

---

## Bestandsstructuur

- Organiseer op feature/domein, niet op type — geen `/controllers`, `/services/` mappen
- Bestandsgrootte: 500 regels is een waarschuwing, 800 absoluut maximum
- Bestandsnaamgeving: volg de conventie uit de taalspecifieke rules
- Geen circulaire dependencies tussen modules

## Functies en methoden

- Max 40 regels — grotere functies opsplitsen
- Max 3 niveaus nesting — gebruik early returns en guard clauses
- Geen boolean/flag parameters om gedrag te schakelen — maak aparte functies
- Booleans: `is`, `has`, `can`, `should` prefix (taalspecifieke conventies kunnen overriden)

## Scope en zichtbaarheid

- Exporteer alleen wat consumers nodig hebben — interne implementatie is privé
- Geen barrel files of index re-exports tenzij bewust gekozen als publieke API

## Comments en TODOs

- Geen uitgecommentarieerde code committen
- TODO format: `TODO(naam YYYY-MM-DD): beschrijving`
