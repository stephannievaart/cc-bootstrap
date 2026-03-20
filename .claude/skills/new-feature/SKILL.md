---
name: new-feature
description: Definieert een nieuwe feature via een gestructureerd interview. Maakt een feature doc aan in docs/work/features/ en een branch via git-capture. Geen blokkade bij in-progress taken.
argument-hint: "[korte feature beschrijving]"
user-invocable: true
---

# New Feature Capture

Je interviewt de gebruiker om een nieuwe feature te definiëren. Het resultaat is een volledige feature doc in `docs/work/features/` (met `status: backlog` in frontmatter) en een branch via de git-capture skill.

---

## Voordat je begint

### Check huidige status
Controleer hoeveel taken er in progress staan:
```bash
grep -rl "status: in-progress" docs/work/
```

**Meld ter info hoeveel taken momenteel in-progress zijn:**
- 0 taken: "Er is momenteel niets in progress."
- 1+ taken: "Er zijn momenteel [N] taken in progress: [titels]. Deze feature wordt geparkeerd in backlog."
- Ga altijd door met het interview — de feature wordt veilig geparkeerd in backlog.
- De feature wordt NIET gestart, alleen gecaptured. Geen blokkade.

---

## Interview — stel vragen in groepen

> **Agent-fallback:** Als alle benodigde informatie al beschikbaar is in het argument of de aanroepende context (bijv. een uitgebreide feature-beschrijving), sla de interviewvragen over en gebruik de beschikbare informatie direct. Stel alleen vragen voor ontbrekende verplichte velden (scope, acceptatiecriteria).

### Groep 1 — Wat en waarom
1. **Wat moet de feature doen?** — beschrijf het gewenste gedrag
2. **Waarom is dit nodig?** — welk probleem lost het op, welke waarde levert het
3. **Voor wie is dit?** — eindgebruiker, ander team, intern systeem

### Groep 2 — Scope en grenzen
4. **Wat hoort er WEL bij deze feature?** — concrete functionaliteit
5. **Wat hoort er NIET bij?** — expliciet uitsluiten om scope creep te voorkomen
6. **Zijn er afhankelijkheden?** — andere features, services, externe APIs

### Groep 3 — Acceptatiecriteria
7. **Wanneer is het klaar?** — concrete, testbare criteria
8. **Welke edge cases zijn er?** — foutscenario's, lege states, grenzen
9. **Zijn er non-functional eisen?** — performance, security, accessibility

### Groep 4 — Technische hints (optioneel)
10. **Welke lagen worden geraakt?** — frontend, backend, database, infra
11. **Is er een API wijziging nodig?** — nieuw endpoint, gewijzigde response
12. **Weet je al hoe je het wilt aanpakken?** — eventuele richting

---

## Na het interview

### 1. Genereer feature doc
Gebruik het feature template (`feature-template.md` in deze skill folder) en vul in:
- Titel en beschrijving
- User story of probleemomschrijving
- Scope (in/uit)
- Acceptatiecriteria als checklist
- Afhankelijkheden
- Technische hints indien gegeven
- Laat secties voor implementatie, review, etc. leeg — die worden later ingevuld

### 2. Bepaal volgnummer
Tel alle bestaande `.md` bestanden in `docs/work/features/backlog/` en `docs/work/features/done/` (exclusief `.gitkeep`).

Volgnummer = totaal aantal + 1, geformateerd als `F-XXX` (bijv. `F-001`, `F-012`).

Gebruik dit nummer in de doc header: `# F-[nummer] — [Feature titel]`

### 3. Bepaal bestandsnaam
Format: `F-[nummer]-[korte-beschrijving].md` in kebab-case.
Voorbeeld: `F-001-product-card-display.md`, `F-012-user-management-roles.md`

### 4. Bepaal branch naam
Format: `feature/[korte-beschrijving]` (geen nummer in branch)
Voorbeeld: `feature/product-card-display`

### 5. Roep git-capture aan
Geef door aan de git-capture skill:
- **doc_path:** `docs/work/features/backlog/[bestandsnaam]`
- **doc_content:** de gegenereerde feature doc
- **branch_name:** `feature/[naam]`

Git-capture handelt af: WIP commit, checkout main, doc schrijven, branch aanmaken, push, branch in doc schrijven, terug naar vorige branch.

### 6. Bevestig aan de gebruiker
- Toon de feature titel en branch naam
- Toon het worktree-pad: `../[repo-naam]--[branch-met-streepjes]`
- Meld: "De feature staat in backlog. Om eraan te werken: open een sessie in de worktree en voer `/start-work [taaknaam]` uit."

---

## Regels

- Sla nooit een interviewgroep over (groep 4 mag beknopt als gebruiker geen technische input heeft)
- Maak geen aannames over scope — vraag expliciet
- Voeg nooit features samen — elke feature is apart
- Gebruik altijd git-capture voor de git operaties — doe het niet zelf
- Het interview mag in het Nederlands of Engels — volg de taal van de gebruiker
