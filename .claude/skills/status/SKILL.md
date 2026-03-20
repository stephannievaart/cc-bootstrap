---
name: status
description: Toont een compleet overzicht van de projectstatus — in-progress taken, backlog aantallen, open bugs per severity, en worktree status.
user-invocable: true
---

# Project Status

Je geeft een compleet, overzichtelijk statusrapport van het project. Geen analyse, geen suggesties tenzij gevraagd — alleen feiten.

---

## Huidige situatie

- **Branch:** !`git branch --show-current`
- **Worktrees:** !`git worktree list`
- **In-progress:** !`grep -rl "status: in-progress" docs/work/ 2>/dev/null || echo "geen"`
- **Backlog features:** !`find docs/work/features/backlog/ -name "*.md" -not -name ".gitkeep" 2>/dev/null | wc -l | tr -d ' '`
- **Backlog bugs:** !`find docs/work/bugs/backlog/ -name "*.md" -not -name ".gitkeep" 2>/dev/null | wc -l | tr -d ' '`
- **Backlog chores:** !`find docs/work/chores/backlog/ -name "*.md" -not -name ".gitkeep" 2>/dev/null | wc -l | tr -d ' '`

---

## Wat je doet

### 1. In-progress taken
Gebruik de data hierboven. Per in-progress item lees het bestand voor:

Per in-progress item toon:
- Bestandsnaam
- Titel (eerste `#` heading uit het bestand)
- Branch naam (zoek naar `Branch:` in het bestand)
- Worktree locatie (match branch met `git worktree list` output)
- Huidige stap als die te bepalen is (zoek naar `## Aanpak`, `## Review bevindingen`, etc.)

Meerdere taken tegelijk in-progress is normaal bij worktree-gebaseerd werken — geen waarschuwing nodig.

### 2. Backlog
Zoek docs in de backlog/ subdirectories per type:
- `docs/work/features/backlog/` — features in backlog (aantal + lijst met titels)
- `docs/work/chores/backlog/` — chores in backlog (aantal + lijst met titels)

### 3. Open bugs per severity
Zoek bugs in `docs/work/bugs/backlog/` en classificeer op severity:
- **P1** — critical, mogelijke werkonderbreking
- **P2** — high
- **P3** — medium
- **P4** — low

Zoek naar `Severity:` of `Priority:` in elk bug-bestand. Toon per severity het aantal en de titels.

**Als er P1 bugs openstaan: markeer dit prominent bovenaan het rapport.**

### 4. Worktree status
Draai `git worktree list` en toon:
- Actieve worktrees met hun branch
- Worktrees waarvan de branch al gemerged is (kandidaat voor cleanup)

### 5. Recent afgerond
Zoek docs met `status: done` in `docs/work/` en toon de laatste 3-5 items.

Sorteer op bestandsdatum (meest recent eerst).

---

## Output formaat

```
# Project Status

## In progress
[items of "Niets in progress"]

## Open bugs
P1: [aantal] — [titels]
P2: [aantal] — [titels]
P3: [aantal]
P4: [aantal]

## Backlog
Features: [aantal] — [titels]
Chores: [aantal] — [titels]

## Worktrees
[lijst of "Geen actieve worktrees"]

## Recent afgerond
[laatste 3-5 items]
```

---

## Regels

- Geef alleen feiten, geen prioriteringsadvies (gebruik `/feature-planner` daarvoor)
- Als directories niet bestaan, meld dit als "Directory niet gevonden — is het project al gebootstrapt?"
- Lees nooit de volledige inhoud van bestanden — alleen titel, branch, severity
