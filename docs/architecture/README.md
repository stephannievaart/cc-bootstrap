# Architectuur Documentatie

**Let op:** De docs in deze map worden gegenereerd door de `architecture-updater` agent.
Pas ze niet handmatig aan — wijzigingen worden overschreven bij de volgende update.

Voor handmatige architectuurbeslissingen: zie `/docs/decisions/` (ADRs).

---

## Documenten

| Document | Inhoud | Laatste update |
|----------|--------|---------------|
| [overview.md](overview.md) | Service beschrijving, lagen, verantwoordelijkheden | — |
| [components.md](components.md) | Modules, klassen, hun rol | — |
| [database-schema.md](database-schema.md) | Tabellen, kolommen, relaties | — |
| [dependencies.md](dependencies.md) | Externe systemen, libraries, services | — |
| [migration-standards.md](migration-standards.md) | Migratie standaarden en conventies | — |

---

## Wanneer bijwerken?

Roep de `architecture-updater` agent aan na:
- Nieuwe modules of packages aangemaakt
- Database migraties toegevoegd
- Nieuwe externe dependencies of services
- Significante refactoring van de structuur
- Na een sprint met meerdere features

Niet nodig na: kleine bug fixes, config wijzigingen, documentatie updates.

---

## API contracts

API contracts staan in `/docs/architecture/api-contracts/` en worden
aangemaakt door de `api-design` agent in Stap 1b van het werkproces.
Die worden wél handmatig bijgehouden — ze zijn contracten, geen gegenereerde docs.
