# Development Workflow Rules

Harde regels voor het werkproces. Geen uitzonderingen.
Voor het volledige proces zie: `/docs/workflow/task-workflow.md`

---

## Taak regels

- Elke taak heeft een doc in `/docs/[type]/` voor implementatie begint
- Nooit bouwen zonder task doc — geen uitzondering
- Één taak tegelijk in `/in-progress/` — nooit twee
- Scope buiten de task doc: STOP, rapporteer, wacht op beslissing
- Bugs gevonden buiten scope: `capture-bug` skill, niet direct fixen

## Permission mode regels

- Stap 1 (planning): altijd `plan` mode — architect en API design agent
- Stap 2 (test scenarios): altijd `plan` mode — test automation agent
- Stap 6 (review): altijd `plan` mode — alle review agents
- Review agents wijzigen nooit code — ook niet als de fix triviaal lijkt

## Review regels

- Alle bevindingen krijgen status: `FIXED` of `ACCEPTED` met motivatie
- Niets wordt stilzwijgend genegeerd — ook niet INFO en LOW
- Agent-consensus eerst bij conflicten — escaleer naar mens alleen bij impasse
- CRITICAL of HIGH zonder status: PR wordt niet aangemaakt

## Session regels

- Bij oppakken van nieuwe taak: altijd `/clear` voor een schone sessie
- Beslissingen verwerken in de juiste doc op het moment zelf — niet achteraf
- WIP commit voor context switch — nooit uncommitted werk achterlaten

## Doc regels

- Elke architectuurbeslissing → ADR in `/docs/decisions/`
- Elke patroon beslissing → relevante standards doc
- CLAUDE.md blijft onder ~100 regels — geen procedures, alleen harde regels en pointers
