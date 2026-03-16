# Project Bootstrap

Een complete Claude Code project bootstrap met agents, skills, rules,
hooks, en documentatie structuur. Start elk nieuw project vanuit dezelfde basis.

---

## Gebruik

### Nieuw project bootstrappen

```bash
git clone [dit repo] mijn-nieuwe-service
cd mijn-nieuwe-service
claude
/new-project
```

De `/new-project` skill interviewt je over het project en genereert de
volledige structuur — CLAUDE.md, README.md, agents, skills, rules, doc structuur, en ADR-001.

---

## Wat zit erin

### `.claude/agents/` — 17 agents

| Agent | Rol | Stap |
|-------|-----|------|
| architect | Planning en impact analyse | 1 |
| api-design | API contract ontwerp | 1b |
| test-planner | Test scenarios definiëren (plan mode) | 2 |
| test-automation | Rode tests bouwen + tests draaien | 3/5 |
| backend-developer | Backend implementatie | 4 |
| frontend-developer | Frontend implementatie | 4 |
| ui-designer | UI en accessibility | 4 |
| documentation | Project docs bijwerken (ADR, README, architecture) | 6 |
| api-contract-reviewer | Contract compliance | 7 |
| dba-reviewer | Database en migraties | 7 |
| resilience-reviewer | Timeouts, retries, circuit breakers | 7 |
| security-reviewer | OWASP, auth, secrets | 7 |
| logging-observability-reviewer | Logging en tracing | 7 |
| code-quality-reviewer | Duplicatie, complexiteit | 7 |
| doc-reviewer | Kennissysteem kwaliteit (laatste reviewer) | 7 |
| architecture-updater | Architectuurdocs genereren | on-demand |
| build-error-resolver | Build fouten oplossen | on-demand |

### `.claude/skills/` — 14 skills

| Skill | Doel | Slash command |
|-------|------|-------------|
| new-project | Project bootstrap interview + scaffold | `/new-project` |
| status | Volledig project status overzicht | `/status` |
| new-feature | Feature definiëren + doc aanmaken | `/new-feature` |
| capture-bug | Bug captureen + doc aanmaken | `/capture-bug` |
| capture-chore | Chore registreren + doc aanmaken | `/capture-chore` |
| feature-builder | Implementatie starten vanuit doc | intern |
| feature-planner | Status overzicht + prioritering | `/feature-planner` |
| doc-review | Kennissysteem kwaliteitscheck | `/doc-review` |
| start-work | Taak opstarten via volledig werkproces | `/start-work` |
| git-worktree | Worktree beheer voor parallelle sessies | `/git-worktree` |
| git-switch-feature | Veilig switchen tussen taken | `/git-switch-feature` |
| git-workflow | Git conventies voor alle developer agents | intern |
| git-capture | Branch + worktree aanmaken bij capture | intern |

### `.claude/hooks/`

- `check-review-complete.sh` — blokkeert PR bij open CRITICAL/HIGH bevindingen
- `session-end-reminder.sh` — WIP commit reminder + verouderde worktrees signaleren

### `.claude/rules/`

```
common/     coding-style, development-workflow, error-handling,
            git-workflow, patterns, security, testing
java/       conventions, spring-boot       (paths: **/*.java)
python/     conventions, django            (paths: **/*.py)
typescript/ conventions, react             (paths: **/*.ts, **/*.tsx, **/*.jsx)
```

Stack-specifieke rules laden alleen wanneer je in bestanden van die taal werkt.

### `docs/`

```
workflow/         task-workflow.md — volledig werkproces
architecture/     gegenereerde docs (architecture-updater agent)
decisions/        ADRs
database/         migration-standards.md
features/         backlog / in-progress / done
bugs/             open / in-progress / done
chores/           backlog / in-progress / done
agents/           langetermijn geheugen van het project
```

---

## Werkproces

```
Capture (new-feature/capture-bug/capture-chore)
    → git-capture: branch + worktree aanmaken
    → doc in backlog

start-work skill
    → doc naar in-progress
    → worktree detecteren of aanmaken
    → /clear — schone sessie

Stap 1   architect (plan mode)
Stap 1b  api-design (plan mode) — conditioneel
Stap 2   test-planner: scenarios (plan mode)
Stap 3   test-automation: rode tests bouwen (TDD Red)
Stap 4   developer agents: implementatie (TDD Green) — parallel via worktrees
Stap 5   tests draaien + refactor → rood: terug naar Stap 4
Stap 6   documentation: project docs bijwerken (ADR, README, architecture)
Stap 7   review team parallel (plan mode) — doc-reviewer als laatste
Stap 8   PR aanmaken + task doc finalisatie
```

---

## Sessie summary

Zie `SESSION-SUMMARY.md` voor de volledige ontwerp beslissingen en context
van deze bootstrap — te gebruiken als startpunt voor nieuwe sessies.
