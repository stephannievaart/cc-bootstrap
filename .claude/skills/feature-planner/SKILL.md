---
name: feature-planner
description: Toont status en helpt bij prioritering van features, bugs en chores. Adviseert worktrees voor parallelle verwerking.
user-invocable: true
---

# Feature Planner

Je helpt de gebruiker bij het kiezen en prioriteren van de volgende taak. Je toont de huidige status en geeft advies op basis van severity, afhankelijkheden, en urgentie.

---

## Huidige situatie

- **Branch:** !`git branch --show-current`
- **In-progress:** !`grep -rl "status: in-progress" docs/work/ 2>/dev/null || echo "geen"`
- **Backlog features:** !`grep -rl "status: backlog" docs/work/features/ 2>/dev/null | wc -l | tr -d ' '`
- **Backlog bugs:** !`grep -rl "status: backlog" docs/work/bugs/ 2>/dev/null | wc -l | tr -d ' '`
- **Backlog chores:** !`grep -rl "status: backlog" docs/work/chores/ 2>/dev/null | wc -l | tr -d ' '`
- **Worktrees:** !`git worktree list`

---

## Stap 1 — Huidige status ophalen

### Check in-progress
Gebruik de data hierboven.

**Toon alle in-progress taken met hun branch en worktree:**
Per in-progress item toon:
- Titel
- Branch naam (uit `Branch:` veld)
- Worktree locatie (check `git worktree list` voor matching branch)

**Als er taken in progress staan en de gebruiker een tweede wil starten:**
- Adviseer: "Gebruik `/git-worktree` om een worktree aan te maken voor parallelle verwerking."
- Meerdere taken in-progress is normaal bij worktree-gebaseerd werken.

### Als er niets in progress staat:
Ga door naar Stap 2.

---

## Stap 2 — Overzicht tonen

### Open bugs (gesorteerd op severity)
Zoek bugs met `status: backlog` in `docs/work/bugs/` en toon gesorteerd op severity:
- **P1 bugs** — bovenaan, met waarschuwing
- **P2 bugs** — prominent
- **P3/P4 bugs** — als lijst

### Feature backlog
Zoek features met `status: backlog` in `docs/work/features/` en toon per item:
- Titel
- Korte beschrijving (eerste regel na `## Beschrijving`)
- Afhankelijkheden (als die er zijn)

### Chore backlog
Zoek chores met `status: backlog` in `docs/work/chores/` en toon per item:
- Titel
- Type en risico level
- Urgentie

---

## Stap 3 — Prioriteringsadvies

Geef een aanbeveling op basis van deze volgorde:

### Prioriteitsregels
1. **P1 bugs gaan altijd voor** — service down of data loss wacht niet
2. **P2 bugs voor features** — belangrijke functionaliteit moet werken
3. **Hoog-risico chores met urgentie** — CVEs, deprecated dependencies op EOL
4. **Features op volgorde van waarde** — bespreek met de gebruiker
5. **P3/P4 bugs en lage-risico chores** — als er ruimte is

### Afhankelijkheden checken
- Als een feature afhankelijk is van een andere die nog niet done is: meld dit
- Suggereer de afhankelijkheid eerst op te pakken

### Aanbeveling formuleren
Geef een concreet advies:
- "Mijn aanbeveling: pak [titel] op omdat [reden]."
- Als er meerdere opties zijn: geef top 3 met motivatie
- Laat de gebruiker beslissen — forceer niets

---

## Stap 4 — Taak starten

Als de gebruiker een keuze maakt:
- Verwijs naar `/start-work [taaknaam]` om het werkproces te starten
- Herhaal: "Vergeet niet `/clear` te doen voor een schone sessie"

---

## Regels

- Forceer nooit een keuze — adviseer en laat de gebruiker beslissen
- Meerdere taken in-progress is normaal — adviseer worktrees voor parallelle verwerking
- P1 bugs altijd bovenaan — ook als de gebruiker iets anders wil
- Toon altijd het volledige plaatje voordat je adviseert
- Als er niets in backlog staat: meld dit en verwijs naar `/new-feature`
