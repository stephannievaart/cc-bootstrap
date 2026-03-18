# Project Bootstrap

Dit is een Claude Code project bootstrap repo. Het bevat agents, skills, rules, en documentatie structuur om elk nieuw microservice project vanuit dezelfde basis te starten.

---

## Git waarschuwing

**Push NIET naar remote voordat je `/new-project` hebt gedraaid.** De huidige remote verwijst naar de bootstrap repo. `/new-project` herinitialisert git en stelt een nieuwe remote in.

## Eerste stap

Draai `/new-project` om het bootstrap interview te starten. Dit genereert:
- Een project-specifieke `CLAUDE.md` (vervangt dit bestand)
- Een project `README.md`
- ADR-001 met je stack beslissingen
- Geconfigureerde agents en skills voor jouw tech stack
- Schone git history met nieuwe remote

---

## Wat zit erin

- **12 agents** — architect, developers, reviewers, documentation
- **14 skills** — feature capture, bug capture, git workflow, worktree beheer
- **Rules** — coding style, security, testing, git workflow + stack-specifiek (Java/Python/TypeScript)
- **Doc structuur** — features, bugs, chores, ADRs, architecture docs

Zie `README.md` voor het volledige overzicht.
Zie `SESSION-SUMMARY.md` voor alle ontwerpbeslissingen.

---

## Werkproces

Alle taken volgen: capture → plan → implement → test → review → done
Details: `/docs/workflow/task-workflow.md`
