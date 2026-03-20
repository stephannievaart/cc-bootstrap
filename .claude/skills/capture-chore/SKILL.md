---
name: capture-chore
description: Registreert technische chores. Bepaalt of een doc nodig is (klein=geen doc, groot=doc). Classificeert type en risico. Parkeert grote chores in docs/work/chores/.
argument-hint: "[korte chore beschrijving]"
user-invocable: true
---

# Chore Capture

Je registreert een technische chore — werk zonder user-visible gedragsverandering. Je bepaalt of het klein (geen doc, direct doen) of groot (doc vereist, via pipeline) is.

---

## Stap 1 — Begrijp de chore

Vraag de gebruiker:
1. **Wat moet er gebeuren?** — concrete beschrijving
2. **Waarom nu?** — urgentie, risico als het niet gebeurt
3. **Wat wordt er geraakt?** — welke componenten, lagen, bestanden

---

## Stap 2 — Classificeer type

Bepaal het type op basis van het antwoord:

| Type | Voorbeelden |
|------|-------------|
| `dependency-upgrade` | Library update, framework upgrade, security patch |
| `refactor` | Code herstructurering, patronen verbeteren |
| `tech-debt` | Workarounds opruimen, TODO's afwerken |
| `infra` | Deployment config, Docker, K8s, monitoring setup |
| `ci-cd` | Pipeline aanpassen, build stappen wijzigen |
| `security-patch` | CVE fix, dependency met vulnerability |

---

## Stap 3 — Bepaal grootte

### Klein (geen doc nodig)
Kenmerken:
- Patch version update van een dependency
- Dead code verwijderen
- Formatting / linting fix
- Enkele configuratiewijziging
- Geen risico op regressie

**Actie bij kleine chore:**
- Meld aan de gebruiker: "Dit is een kleine chore. Geen doc nodig — voer het uit als `chore: [beschrijving]` commit."
- Geef het exacte commit message format
- **Stop hier — geen git-capture, geen doc**

### Groot (doc vereist)
Kenmerken:
- Major version upgrade
- Cross-service refactor
- Wijziging in meerdere lagen
- Risico op regressie
- Meerdere bestanden geraakt
- Security vulnerability met impact

**Actie bij grote chore:** ga door naar Stap 4.

---

## Stap 4 — Risico bepalen (alleen grote chores)

| Risico | Criteria |
|--------|----------|
| **Laag** | Geïsoleerde wijziging, goede test coverage, geen externe impact |
| **Midden** | Meerdere componenten, matige test coverage, interne consumers |
| **Hoog** | Database migratie, API wijziging, externe consumers, lage test coverage |

Bij **hoog risico**: meld dit expliciet aan de gebruiker.

---

## Stap 5 — Bepaal benodigde review agents (alleen grote chores)

Op basis van wat er geraakt wordt:

| Wijziging | Review agent |
|-----------|-------------|
| Database migratie | DBA reviewer |
| Security gerelateerd | Security reviewer (altijd bij security-patch type) |
| Infra/deployment | Non-functional reviewer |
| Code structuur | Architect |
| Dependencies | Security reviewer + Architect |

Noteer welke agents nodig zijn in de chore doc.

---

## Stap 6 — Genereer chore doc en capture (alleen grote chores)

### 1. Genereer chore doc
Gebruik het chore template (`chore-template.md` in deze skill folder) en vul in:
- Titel en beschrijving
- Type classificatie
- Risico level
- Wat er geraakt wordt
- Benodigde review agents
- Acceptatiecriteria (focus op: wat mag niet kapot gaan)

### 2. Bepaal volgnummer
Tel alle bestaande `.md` bestanden in `docs/work/chores/` (exclusief `.gitkeep`).

Volgnummer = totaal aantal + 1, geformateerd als `C-XXX` (bijv. `C-001`, `C-002`).

Gebruik dit nummer in de doc header: `# C-[nummer] — [Chore titel]`

### 3. Bepaal bestandsnaam
Format: `C-[nummer]-[korte-beschrijving].md` in kebab-case.
Voorbeeld: `C-002-spring-boot-upgrade.md`, `C-001-refactor-service-layer.md`

### 4. Bepaal branch naam
Format: `chore/[korte-beschrijving]` (geen nummer in branch)
Voorbeeld: `chore/spring-boot-3-upgrade`

### 5. Roep git-capture aan
Geef door aan de git-capture skill:
- **doc_path:** `docs/work/chores/[bestandsnaam]`
- **doc_content:** de gegenereerde chore doc
- **branch_name:** `chore/[naam]`

### 6. Bevestig aan de gebruiker
- Toon type, risico, en branch naam
- Bij hoog risico: herhaal de waarschuwing
- Verwijs naar `/start-work` om het op te pakken

---

## Regels

- Kleine chores krijgen NOOIT een doc — dat is overhead
- Grote chores gaan ALTIJD door het volledige pipeline (plan → implement → test → review)
- Chores raken nooit user-facing interfaces — als dat wel zo is, is het een feature
- Gebruik altijd git-capture voor de git operaties bij grote chores
- API Design stap (1b) is NOOIT nodig bij chores
