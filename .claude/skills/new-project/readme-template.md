# [Projectnaam]

[Één zin — wat doet deze service en voor wie]

## Quickstart

```bash
# Installeer dependencies
[install commando]

# Start lokaal
[run commando]

# Draai tests
[test commando]
```

## Tech stack

| Component | Keuze |
|-----------|-------|
| Taal | [taal] |
| Framework | [framework] |
| Database | [type] |
| ORM | [orm] |
| Message broker | [broker of "Geen"] |
| Cache | [cache of "Geen"] |

## Architectuur

[Korte beschrijving van de service rol in het systeem]

Voor gedetailleerde architectuurdocs zie `/docs/architecture/`.

## Project structuur

```
src/
  [structuur passend bij framework]
docs/
  features/       Backlog, in-progress, done
  bugs/           Open, in-progress, done
  chores/         Backlog, in-progress, done
  decisions/      Architecture Decision Records
  architecture/   Gegenereerde architectuurdocs
  workflow/       Werkproces documentatie
```

## Werken aan dit project

Dit project gebruikt Claude Code met agents en skills voor het volledige werkproces.

```bash
claude                    # Start Claude Code
/new-feature              # Nieuwe feature definiëren
/start-work               # Taak oppakken
/status                   # Overzicht van alle taken
```

Zie `/docs/workflow/task-workflow.md` voor het volledige werkproces.

## Beslissingen

Architectuurbeslissingen worden vastgelegd als ADRs in `/docs/decisions/`.
Zie [ADR-001](docs/decisions/ADR-001-stack-beslissingen.md) voor de initiële stack keuzes.
