# Claude Code Project Bootstrap — Session Summary
*Paste this at the start of a new session to resume with full context*

---

## What we designed

A complete Claude Code project bootstrap system for microservice development. The goal is to always start a new project from the same foundation — same agent team, same document structure, same workflow discipline, same git strategy.

---

## Core philosophy established

- **CLAUDE.md** stays lean — hard rules and pointers only, under ~100 lines
- **Skills** = reusable knowledge injected into context on demand (SKILL.md files)
- **Agents** = autonomous actors with their own context window, tools, permissions
- **One feature at a time** — nothing gets built without a feature doc
- **Never fix a bug or start a new idea mid-feature** — capture and park it
- **New feature = new branch = new session** — context stays clean
- **Chore** = technical work without user-visible behaviour change (upgrade, refactor, tech debt, infra, ci-cd, security-patch)
- **Small chores** (patch update, dead code, formatting) — no doc, just a `chore:` commit
- **Large chores** (major upgrade, cross-service refactor) — doc required, same pipeline as feature

---

## The agent pipeline

### Inception
- **Architect agent** — validates contracts, API interfaces, event schemas, system design before any code is written

### Implementation (can run in parallel when work is separated)
- **Backend developer agent** — business logic, data access, API contracts, service communication
- **Frontend developer agent** — component architecture, state management, API consumption
- **UI designer agent** — design system, accessibility, visual consistency
- **Test automation agent** — defines acceptance test scenarios BEFORE implementation, writes and runs tests AFTER

### Quality review — Stap 6 (plan mode, parallel, findings fed back to developer agents)

| Agent | Wanneer |
|-------|---------|
| API contract reviewer | Alleen als er contract is uit Stap 1b |
| DBA reviewer | Alleen als database geraakt wordt |
| Resilience reviewer | Altijd bij features en bugs |
| Security reviewer | Altijd |
| Logging & observability reviewer | Altijd bij features en bugs |
| Code quality reviewer | Altijd |
| Doc-reviewer | Altijd — als laatste van de groep |

**On-demand (niet in review team):**
- **Build-error-resolver** — alleen bij build fouten in Stap 3/4/5

**Later toe te voegen:**
- **E2e-runner** — Playwright, toe te voegen als project frontend heeft

---

## Volledige agent inventory

| Agent | Stap | Mode | Model | Conditioneel |
|-------|------|------|-------|-------------|
| architect | 1 | plan | opus | nee |
| api-design | 1b | plan | sonnet | ja — alleen bij API wijziging |
| test-automation | 2 (plan) / 4+5 (default) | plan→default | sonnet | nee |
| backend-developer | 3 | default | sonnet | ja — bij backend werk |
| frontend-developer | 3 | default | sonnet | ja — bij frontend werk | ✅ |
| ui-designer | 3 | default | sonnet | ja — bij UI werk | ✅ |
| api-contract-reviewer | 6 | plan | sonnet | ja — alleen bij API contract |
| dba-reviewer | 6 | plan | sonnet | ja — alleen bij DB wijziging |
| resilience-reviewer | 6 | plan | sonnet | altijd bij feat/bug |
| security-reviewer | 6 | plan | opus | altijd |
| logging-observability-reviewer | 6 | plan | sonnet | altijd bij feat/bug |
| code-quality-reviewer | 6 | plan | sonnet | altijd |
| doc-reviewer | 6 | acceptEdits | sonnet | altijd — als laatste |
| documentation | 7a | default | sonnet | altijd |
| architecture-updater | on-demand | acceptEdits | sonnet | na structuurwijzigingen |
| build-error-resolver | 3/4/5 | default | sonnet | on-demand bij build fouten |

**Gebaseerd op:** affaan-m/everything-claude-code (architect, security-reviewer, code-reviewer, database-reviewer, build-error-resolver, tdd-guide) + eigen ontwerp

### Closure
- **Documentation agent** — controleert en finaliseert task doc, maakt PR aan. Elke agent verwerkt zijn eigen beslissingen al tijdens de sessie
- **Doc-reviewer agent** — altijd laatste stap. Bewaakt het hele kennissysteem: CLAUDE.md cleanliness, verwijzingen valideren, lessons learned verwerken, verouderde docs markeren, skills en agent prompts bijwerken op basis van wat geleerd is, structuur bewaken. Dit is hoe het project zichzelf slimmer maakt.

### Key rules for review agents
- All reviewers are **read-only** — they never change code
- Findings are appended to the feature doc
- Developer agent picks up all findings and incorporates them
- Database agent is especially important — migrations touch production data and should never be auto-rewritten

---

## Document structure

```
/docs
  /features
    /backlog          ← defined, not started
    /in-progress      ← one at a time only
    /done             ← completed
  /bugs
    /open             ← P1/P2/P3/P4 severity
    /in-progress
    /done
  /chores
    /backlog          ← large chores waiting
    /in-progress
    /done
  /decisions          ← ADRs (Architecture Decision Records)
  /workflow           ← task-workflow.md — het centrale werkproces
  /database           ← migration-standards.md
  /architecture
    README.md         ← index van gegenereerde docs + wanneer updaten
    overview.md       ← gegenereerd door architecture-updater
    components.md     ← gegenereerd door architecture-updater
    database-schema.md ← gegenereerd vanuit migraties
    dependencies.md   ← gegenereerd vanuit build files + code
    /api-contracts    ← handmatig door api-design agent (Stap 1b)
    api-conventions.md
    resilience-patterns.md
  /agents             ← long-term memory, accumulated decisions

.claude/
  /agents             ← all agent .md definition files
  /skills             ← all skill folders with SKILL.md
  /commands
    new-project.md    ← bootstrap interview + scaffold genereren
    status.md         ← project status overzicht
  /hooks
    hooks.json        ← hook configuratie
    /scripts
      check-review-complete.sh   ← blokkeert PR bij open CRITICAL/HIGH
      session-end-reminder.sh    ← herinnert aan WIP commit + doc updates
  /templates
    /features         ← feature-template.md
    /bugs             ← bug-template.md
    /chores           ← chore-template.md
.claude/rules/
  /common
    development-workflow.md  ← harde procesregels
    git-workflow.md          ← branch/commit/PR regels
    security.md              ← security standaarden
    testing.md               ← test strategie en regels
    error-handling.md        ← error handling standaarden
    coding-style.md          ← stijlregels naast linter
    patterns.md              ← patronen en anti-patronen
  /java                      ← paths: **/*.java
    conventions.md           ← Java specifieke regels
    spring-boot.md           ← Spring Boot structuur en regels
  /python                    ← paths: **/*.py
    conventions.md           ← Python specifieke regels
    django.md                ← Django structuur en regels
  /typescript                ← paths: **/*.ts, **/*.tsx, **/*.jsx
    conventions.md           ← TypeScript specifieke regels
    react.md                 ← React patterns en component regels
CLAUDE.md             ← lean, hard rules + pointers only
```

---

## Skills built

### new-feature
Interviews user in groups before creating feature doc. Enforces one-feature-at-a-time rule. Parks new ideas in /backlog without derailing current work. Auto-triggers on "I want to add", "we need a", "new feature".

### capture-bug
Captures bugs with severity classification (P1-P4). Parks in /bugs/open. P1 flags for possible work interruption. P3/P4 parks silently. Auto-triggers on "bug", "broken", "not working".

### capture-chore
Determines if a chore needs a doc (small = no doc, just commit; large = doc required). Classifies type (dependency-upgrade, refactor, tech-debt, infra, ci-cd, security-patch) and risk (low/medium/high). Parks large chores in /chores/backlog. Flags high-risk chores explicitly. Determines which review agents are needed based on what changes. Auto-triggers on "upgrade", "refactor", "tech debt", "deprecated", "CVE", "cleanup".

### feature-builder
Loaded by all developer agents. Before coding: reads feature doc, confirms one feature in progress, checks dependencies. During: updates implementation notes, stops if scope creep discovered. After: checks acceptance criteria, prepares handoff to reviewers.

### feature-planner
Status overview on demand. Shows in-progress, backlog, open bugs by severity. Helps prioritise. Enforces one-feature-at-a-time when starting new work.

### doc-review
Draait altijd als Stap 7b — laatste stap van elke taak. Controleert: CLAUDE.md cleanliness, verwijzingen, lessons learned verwerking, verouderde docs, skills bijwerken, agent prompts bijwerken, doc structuur. Schrijft rapport in task doc onder `## Doc review`. Kan ook expliciet aangeroepen worden met `/doc-review`.

### start-work
Kicks off the full task workflow for any feature, bug, or chore. Finds the task doc, checks nothing else is in-progress, moves doc to in-progress, checks out the branch, instructs /clear, then orchestrates all steps: planning → API design → test scenarios → implementation → tests → review → done. Auto-triggers on "ik ga aan X werken", "start", "oppakken", "begin met".

### git-worktree
Centrale worktree kennis. Aanmaken, beheren, opruimen van worktrees. Naming conventie, symlinks voor CLAUDE.md en .claude/, parallelle sessies. Triggers: "parallel sessie", "worktree", "tweede sessie", "meerdere taken tegelijk".

### git-workflow
Loaded silently into all developer agents (user-invocable: false). Branch strategy, commit conventions, WIP commits, pre-push checks, PR process, worktree conventies.

### git-switch-feature
Handles context switches safely when explicitly switching between existing parked items. Assesses current git state, WIP commits current work, switches branch, recommends /clear for fresh session.

### git-capture
Internal skill (user-invocable: false). Called by all three capture skills (new-feature, capture-bug, capture-chore). Handles: auto WIP commit, switch to main + pull, write doc, create branch locally + remote, write branch name into doc, return to previous branch. Single place for all git capture logic — not duplicated across capture skills.

---

## Git strategy

### In CLAUDE.md (hard rules)
- Never commit directly to main
- Always work on a feature/bug/chore branch
- Branch naming: feature/[name], bug/[P1|P2|P3]-[name], chore/[name]
- Never push without tests passing
- All branches come directly from main — no develop branch

### Branch naming
```
feature/product-card
feature/user-management
bug/P2-checkout-total-wrong
bug/P1-payment-service-down
chore/spring-boot-3-upgrade
chore/refactor-service-layer
```

### Commit convention
```
feat: add product card price display
fix: correct null check on user session expiry
chore: upgrade Spring Boot 2.7 to 3.3
docs: voeg feature doc toe voor product-card
WIP: product card layout done, price logic not started
```

### Capture flow (new-feature / capture-bug / capture-chore)
All three capture skills automatically invoke git-capture which:
```
1. WIP commit current work automatically (no confirmation needed)
2. git checkout main && git pull
3. Write doc file on main
4. git checkout -b [branch_name]
5. git push -u origin [branch_name]  — direct lokaal + remote
6. Write branch name into doc under Branch:
7. git checkout [previous_branch]    — terug naar waar je was
```

### Starting parked work

**Via worktree (aanbevolen voor parallel werk):**
```
# Worktree bestaat al (aangemaakt door git-capture)
cd [repo]--[branch]
claude  ← nieuwe Claude Code sessie
→ start-work skill
```

**Via checkout (één sessie):**
```
git checkout [branch_name from doc]
/clear — fresh session
→ start-work skill
```

### Worktree lifecycle
```
git-capture skill    → worktree aanmaken + symlinks
start-work skill     → worktree detecteren en gebruiken
Na merge            → git worktree remove [pad] && git worktree prune
session-end hook    → gemerged worktrees signaleren voor cleanup
```

### P1 hotfix
P1 bugs branch from main (same as everything else).
PR direct to main. No develop branch, no cherry-pick needed.

---

## Project bootstrap repo structure

```
/bootstrap
  /commands
    new-project.md          ← interview command, generates full scaffold
  /templates
    CLAUDE.md.template
    /agents                 ← all agent templates
    /skills                 ← all skill templates
    /docs                   ← ADR template, standards docs
  /hooks
    post-review.md          ← triggers documentation agent after reviews
```

### Bootstrap interview covers
- Service responsibility and role in the system
- What it talks to (databases, APIs, other services)
- Non-functional requirements (load, latency, uptime)
- Tech stack and framework
- Deployment target
- Integrations (message broker, cache, observability)

Interview answers flow directly into agent system prompts. ADR-001 is auto-generated from the stack decisions made during the interview.

---

## CLAUDE.md content guidelines

**Keep in CLAUDE.md:**
- Project identity — one sentence
- Build, test, run commands
- Repo structure overview
- Hard conventions not enforced by tooling
- Git hard rules
- Pointers to deeper docs — *when and why* to read them, not just paths

**Move out of CLAUDE.md:**
- Architecture decisions → /docs/decisions/ (ADRs)
- API documentation → /docs/architecture/
- Resilience/security rules → specialist agent system prompts + skills
- Code style guidelines → linter config (never in CLAUDE.md)
- Anything longer than a few lines on a single topic

---

## Where Claude.ai vs Claude Code CLI fits

**Claude.ai** (this tool) — designing, thinking through architecture, discussing tradeoffs, generating templates and skills. Conversational, no filesystem access.

**Claude Code CLI** — running the bootstrap against a real repo, day-to-day feature/bug/git workflow, testing and iterating on skills with real code tasks, anything that touches files or runs commands.

**Recommended next step:** Take this design into Claude Code and have it generate the complete bootstrap repo from this summary.

---

## Task workflow (feat/bug/chore)

Volledig beschreven in `/docs/workflow/task-workflow.md`. Samenvatting:

### Permission modes per fase
```
Plan mode   → Stap 1, 1b, 2, 6  (denken, ontwerpen, reviewen)
Normal mode → Stap 3, 4, 5, 7   (bouwen, testen, afronden)
```
Review agents in Stap 6 mogen nooit code aanpassen — ook niet als de fix triviaal lijkt.

### Stap 0 — Capture + branch
`plan` — capture skill → git-capture → doc in backlog + branch lokaal & remote

### Stap 1 — Planning `plan mode`
Architect agent bepaalt aanpak en geraakt lagen. Niets wordt geschreven in codebase.

### Stap 1b — API Design-First `plan mode`
Alleen indien interface geraakt. API design agent schrijft contract ter goedkeuring in `/docs/architecture/api-contracts/`. Mens keurt goed voor implementatie begint. Maakt parallel werken mogelijk.

### Stap 2 — Test scenarios `plan mode`
Test automation agent definieert scenarios op basis van acceptatiecriteria. Nog geen testcode.

### Stap 3 — Implementatie `normal mode`
Developer agents implementeren tegen contract + test scenarios. Parallel indien API contract beschikbaar.

### Stap 4+5 — Tests bouwen en draaien `normal mode`
Test automation agent bouwt en draait tests. Rood → terug naar Stap 3. Pas bij groen: door.

### Stap 6 — Review (groep) `plan mode`
Review agents draaien parallel. Doc-reviewer altijd als laatste. Bevindingen in task doc:
- `CRITICAL` / `HIGH` — altijd fixen, blokkeert merge
- `WARN` / `INFO` / `LOW` — fixen of bewust accepteren met motivatie
- Niets wordt stilzwijgend genegeerd
- Conflicten: agents zoeken eerst consensus. Onoplosbaar → escaleert naar mens
- Na review: architect bepaalt impact → API geraakt: terug Stap 1b, implementatie: terug Stap 3

Reviewers: API contract (conditioneel), DBA (conditioneel), Resilience, Security, Logging & observability, Code quality, Doc-reviewer

### Stap 7a — Afronden `normal mode`
Documentatie agent: controleert task doc volledigheid, finaliseert ADR, doc naar /done/, PR aanmaken.

### Stap 7b — Doc review `acceptEdits`
Doc-reviewer agent: CLAUDE.md check, verwijzingen valideren, lessons learned verwerken in standards/skills/agents, verouderde docs markeren, structuur bewaken. Schrijft rapport in task doc. **Dit is het moment waarop het project zichzelf slimmer maakt.**

### Afwijkingen
- **Bug**: API design alleen als fix interface raakt
- **Chore**: geen API design stap, test scenarios focussen op regressie
- **Kleine chore**: geen proces, direct `chore:` commit

### Start-werk regel
Bij oppakken van een taak: altijd eerst `/clear` voor een schone sessie.
`start-work` skill handelt dit af en wacht expliciet op /clear voor het proces start.

---

## Open threads / things to continue

- ✅ Frontend developer en UI designer agent definities geschreven
- ✅ `/status` command geschreven
- ✅ `feature-planner` skill bijgewerkt met chores
- ✅ `/new-project` bootstrap command geschreven
- ✅ Hooks geschreven (post-review check + session-end reminder)
- ✅ Framework-specifieke rules: spring-boot.md, react.md, django.md
- ✅ Skill descriptions verfijnd voor auto-discovery
- ✅ Build out individual agent .md definition files with correct frontmatter

**Nog open:**
- E2e-runner toevoegen wanneer project een frontend heeft
- Agent definities verfijnen met projectspecifieke skills zodra tech stack bekend is
- Test het volledige systeem op een echt klein project om gaps te vinden
- ✅ Worktree support toegevoegd aan alle relevante skills, rules, agents, en docs
- ✅ architecture-updater agent geschreven
- ✅ doc-reviewer uitgebreid met grootte check, splits voorstel, en staleness check
