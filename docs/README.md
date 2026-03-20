# Documentatie Index

Overzicht van alle projectdocumentatie en waar je wat vindt.

---

## Werkproces

| Document | Beschrijving |
|----------|-------------|
| [workflow/task-workflow.md](workflow/task-workflow.md) | Het volledige werkproces — capture, plan, implement, test, review, done |

## Taken

Alle task docs staan in `work/` met status in frontmatter (`status: backlog | in-progress | done`).

| Map | Wat staat erin |
|-----|---------------|
| [work/features/](work/features/) | Feature docs (status in frontmatter) |
| [work/bugs/](work/bugs/) | Bug docs met severity (P1-P4) en status |
| [work/chores/](work/chores/) | Chore docs met type, risico en status |

## Architectuur

| Document | Beschrijving | Beheerd door |
|----------|-------------|-------------|
| [architecture/README.md](architecture/README.md) | Index van architectuurdocs | architecture-updater agent |
| [architecture/overview.md](architecture/overview.md) | Systeem overzicht en lagen | architecture-updater agent |
| [architecture/components.md](architecture/components.md) | Component beschrijvingen | architecture-updater agent |
| [architecture/database-schema.md](architecture/database-schema.md) | Database schema uit migraties | architecture-updater agent |
| [architecture/dependencies.md](architecture/dependencies.md) | Dependencies en externe services | architecture-updater agent |
| [architecture/api-contracts/](architecture/api-contracts/) | API contracten per feature | api-design agent |

## Beslissingen

| Document | Beschrijving |
|----------|-------------|
| [decisions/](decisions/) | Architecture Decision Records (ADRs) |

Elke significante technische beslissing wordt vastgelegd als ADR. Zie de map voor alle beslissingen.

## Standaarden

| Document | Beschrijving |
|----------|-------------|
| [architecture/database-standards.md](architecture/database-standards.md) | Database standaarden en migratie conventies |
