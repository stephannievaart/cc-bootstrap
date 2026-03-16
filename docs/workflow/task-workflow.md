# Task Workflow

Dit document beschrijft het verplichte werkproces voor elke feature, bug en chore die door het team wordt opgepakt. Alle agents kennen dit proces en volgen het zonder uitzondering.

---

## Principes

- **Niets wordt gebouwd zonder plan** — elke taak start met een doc in backlog
- **API Design-First** — interfaces worden vastgelegd voor implementatie begint, zodat parallel werken mogelijk is
- **Alles wordt gereviewd** — geen finding wordt stilzwijgend genegeerd
- **Agent-consensus** — review agents lossen conflicten onderling op. Alleen bij onoplosbaar conflict escaleert naar de mens
- **Bewust accepteren of fixen** — elke bevinding (ook INFO en LOW) wordt gefixed of expliciet geaccepteerd met motivatie in de doc

---

## Permission modes per fase

Elke fase heeft een vaste permission mode. Agents mogen deze niet overschrijven.

| Fase | Stap | Mode | Reden |
|------|------|------|-------|
| Planning | Stap 1 | `plan` | Denken en ontwerpen — niets schrijven in codebase |
| API Design | Stap 1b | `plan` | Contract voorleggen ter goedkeuring voor vastlegging |
| Test scenarios | Stap 2 | `plan` | Scenarios definiëren in doc — nog geen testcode |
| Tests bouwen (rode tests) | Stap 3 | `default` | Testcode schrijven op basis van scenarios — tests moeten FALEN (red) |
| Implementatie | Stap 4 | `default` | Bouwen om rode tests groen te maken |
| Tests draaien + refactor | Stap 5 | `default` | Uitvoeren, refactoren als alles groen is |
| Documentation | Stap 6 | `default` | Project docs bijwerken (ADR, README, architecture) |
| Review | Stap 7 | `plan` | Lezen en rapporteren — nooit code aanpassen |
| PR + finalisatie | Stap 8 | `default` | Task doc verplaatsen, PR aanmaken |

**Vuistregel:**
```
Plan mode   → Stap 1, 1b, 2, 7  (denken, ontwerpen, reviewen)
Normal mode → Stap 3, 4, 5, 6, 8   (testen, bouwen, documenteren, afronden)
```

Geen enkele review agent in Stap 7 mag code wijzigen — ook niet als de fix triviaal lijkt.
Bevindingen worden gerapporteerd. De developer agent fixt in een nieuwe iteratie van Stap 4.

---

## Het proces

### Stap 0 — Capture en branch
*Wie: capture skill + git-capture skill*

- Feature, bug of chore wordt gecaptured via de juiste capture skill
- Doc aangemaakt in `/docs/[type]/backlog/`
- Branch aangemaakt lokaal + remote
- Branchnaam in doc geschreven
- Terug naar vorige branch

---

### Stap 1 — Planning
*Wie: architect agent + API design agent*
*Mode: `plan` — geen codewijzigingen toegestaan*

**Altijd verplicht, ook voor bugs en chores.**

De architect agent leest de task doc en bepaalt:
- Welke lagen worden geraakt — frontend, backend, database, infra
- Welke andere services of consumers worden geraakt
- Of er API wijzigingen zijn — zo ja, direct door naar Stap 1b

#### Stap 1a — Interne planning
Als er geen API wijzigingen zijn:
- Architect legt aanpak vast in de task doc onder `## Aanpak`
- Beschrijft: welke componenten, welke patronen, welke risico's
- Beschrijft: wat parallel kan, wat sequentieel moet

#### Stap 1b — API Design-First
*Mode: `plan` — contract wordt ter goedkeuring voorgelegd aan de mens voor vastlegging*
*Alleen als de taak een API raakt — nieuw endpoint, gewijzigde response, nieuw event schema*

De API design agent:
- Ontwerpt het volledige contract — request/response shapes, error codes, status codes, event schemas
- Schrijft dit als een formeel contract in `/docs/architecture/api-contracts/[branch-naam].md`
- Checkt bestaande consumers — breekt dit contract bestaande afnemers?
- Legt vast: wat is backwards compatible, wat is breaking change

**Pas als het API contract goedgekeurd is gaat het team door naar Stap 2.**
Dit is het moment waarop parallel werken mogelijk wordt — backend en frontend kunnen tegelijk starten tegen hetzelfde contract.

---

### Stap 2 — Test scenarios definiëren
*Wie: test-planner agent*
*Mode: `plan` — scenarios worden in de task doc geschreven, nog geen testcode*

**Voor implementatie begint** definieert de test-planner agent:
- Acceptatiecriteria vertaald naar concrete test scenarios
- Happy path scenarios
- Unhappy path scenarios — wat gebeurt er als het fout gaat
- Edge cases uit de task doc

Deze scenarios worden toegevoegd aan de task doc onder `## Test scenarios`.

**De developer agents weten hierdoor exact wat "done" betekent.**

---

### Stap 3 — Tests bouwen (rode tests)
*Wie: test automation agent*
*Mode: `default` — testcode schrijven mag*

**TDD Red fase — tests worden geschreven VOOR de implementatie.**

De test automation agent:
- Bouwt tests op basis van de scenarios uit Stap 2
- Unit tests, integratietests, acceptatietests
- Zorgt voor coverage op alle acceptatiecriteria
- Schrijft ook negatieve tests — foute input, timeouts, unavailable dependencies
- Tests moeten compileren/parsen maar **FALEN** — er is nog geen implementatie
- Rode tests zijn het bewijs dat de tests iets nuttigs testen

---

### Stap 4 — Implementatie
*Wie: backend agent, frontend agent, UI agent — parallel waar mogelijk*
*Mode: `default` — bouwen mag*

**TDD Green fase — doel is alle rode tests uit Stap 3 groen maken.**

Elke developer agent:
- Laadt de task doc volledig
- Laadt het API contract indien aanwezig
- Leest en draait de rode tests uit Stap 3 — begrijpt wat er verwacht wordt
- Laadt de relevante skills (Java conventions, migration safety, etc.)
- Implementeert tot alle rode tests groen zijn
- Draait tests regelmatig tijdens implementatie — elke test die groen wordt is voortgang
- Voegt GEEN tests toe — dat is de verantwoordelijkheid van de test-automation agent
- Noteert beslissingen in de task doc onder `## Implementatie notities`
- Stopt en rapporteert als scope buiten de doc dreigt te gaan

**Parallel werken via worktrees:**
Backend en frontend kunnen parallel als het API contract uit Stap 1b klaar is.
Elke developer agent werkt in zijn eigen worktree + Claude Code sessie:

```bash
# Sessie 1 — backend
cd /projects/my-service--feature-product-card
claude  # backend-developer agent

# Sessie 2 — frontend (zelfde branch, aparte worktree)
# Of aparte branch per developer:
cd /projects/my-service--feature-product-card-frontend
claude  # frontend-developer agent
```

Zonder API contract: backend eerst, frontend daarna.

---

### Stap 5 — Tests draaien + refactor
*Wie: test automation agent*
*Mode: `default` — uitvoeren mag*

- Draait de volledige test suite
- Rapporteert: welke tests groen, welke rood
- Bij rode tests: rapporteert aan developer agent voor fix → terug naar Stap 4
- Bij groene tests: refactor indien nodig — code opschonen terwijl tests groen blijven
- Pas als alles groen: door naar Stap 6

---

### Stap 6 — Documentation
*Wie: documentation agent*
*Mode: `default` — project docs bijwerken mag*

De documentation agent werkt de project documentatie bij:

- Finaliseert ADR-concept → `/docs/decisions/`
- Bijwerken README.md indien de taak impact heeft
- Triggert architecture-updater indien structuurwijzigingen

**De documentation agent maakt geen PR en verplaatst geen task docs.** Dat gebeurt in Stap 8.

---

### Stap 7 — Review
*Wie: alle relevante review agents als groep*
*Mode: `plan` — lezen en rapporteren only, nooit code aanpassen*

De review agents draaien parallel en voegen bevindingen toe aan de task doc onder `## Review bevindingen`.

**Welke agents reviewen:**

| Agent | Wanneer |
|-------|---------|
| API contract reviewer | Alleen als er een contract is uit Stap 1b |
| DBA reviewer | Alleen als database geraakt wordt |
| Resilience reviewer | Altijd bij features en bugs |
| Security reviewer | Altijd |
| Logging & observability reviewer | Altijd bij features en bugs |
| Code quality reviewer | Altijd |
| Doc-reviewer | Altijd — altijd als laatste van de groep. Controleert ook het werk van de documentation agent uit Stap 6 (README correct? ADR correct?) |

**On-demand — geen vast review team lid:**
- **Build-error-resolver** — alleen aangeroepen als er build fouten zijn tijdens Stap 3, 4, of 5 (tests bouwen, implementatie, tests draaien). Niet tijdens review.

**Nog niet opgenomen — later toe te voegen:**
- **E2e-runner** — Playwright user flows, toe te voegen als project een frontend heeft

**Bevindingen worden geclassificeerd:**
```
CRITICAL  — moet gefixed, blokkeert merge
HIGH      — moet gefixed, blokkeert merge
WARN      — moet gefixed of bewust geaccepteerd met motivatie
INFO      — moet gefixed of bewust geaccepteerd met motivatie
LOW       — moet gefixed of bewust geaccepteerd met motivatie
```

**Niets wordt stilzwijgend genegeerd.** Elke bevinding krijgt één van twee uitkomsten:
- `FIXED` — aanpassing gemaakt, verwijs naar commit
- `ACCEPTED` — bewust geaccepteerd, motivatie verplicht

#### Stap 7.1 — Consensus bij conflicten
Als review agents tegenstrijdige bevindingen hebben:

1. Agents starten een groepsdiscussie in de task doc onder `## Review discussie`
2. Elke agent legt zijn standpunt uit met technische motivatie
3. Agents proberen consensus te bereiken
4. Bij consensus: gezamenlijke aanbeveling in doc, door naar Stap 7.2
5. Bij onoplosbaar conflict na discussie: **escaleert naar de mens**

De mens leest de discussie, beslist, noteert beslissing in de doc.

#### Stap 7.2 — Impact assessment na review
Na alle bevindingen bepaalt de architect agent:

- Raken de bevindingen de API interface? → terug naar **Stap 1b**
- Raken de bevindingen alleen implementatie? → terug naar **Stap 4**
- Is alles gefixed of geaccepteerd? → door naar **Stap 8**

#### Doc-reviewer — laatste in de review groep
*Wie: doc-reviewer agent*
*Mode: `acceptEdits` — mag docs, skills en agent prompts aanpassen*

**Altijd de laatste reviewer in Stap 7. Geen uitzondering.**

De doc-reviewer agent loopt het volledige kennissysteem na:

1. **Documentation agent werk controleren** — README wijzigingen correct? ADR correct?
2. **CLAUDE.md check** — nog clean en onder ~100 regels? Verwijzingen geldig?
3. **Alle verwijzingen** in agents en skills — bestaan de bestanden?
4. **Lessons learned** uit de sessie — verwerkt in de juiste standards docs, agent prompts, of skills?
5. **Verouderde docs** — gemarkeerd als `archived` of `superseded`?
6. **Skills bijwerken** — raken lessons learned bestaande skills?
7. **Agent prompts bijwerken** — raken lessons learned bestaande agents?
8. **Structuur bewaken** — bestanden op juiste plek, naamgeving correct?

Schrijft een kort `## Doc review` rapport in de task doc.

**Dit is het moment waarop het project zichzelf slimmer maakt.**
Elke afgeronde taak verbetert het kennissysteem voor de volgende.

---

### Stap 8 — PR creation + task doc finalisatie
*Wie: start-work orchestratie (geen aparte agent)*
*Mode: `default` — doc verplaatsen en PR aanmaken mag*

1. **Task doc volledigheid controleren** — check dat alle verplichte secties ingevuld zijn:
   - `## Beschrijving`, `## Acceptatiecriteria`, `## Aanpak`, `## Test scenarios`, `## Implementatie notities`, `## Review bevindingen`
   - Als secties ontbreken of leeg zijn: meld aan gebruiker — vul niet zelf in
2. **Task doc verplaatsen** naar `/docs/[type]/done/`
3. **PR aanmaken** met `gh pr create` — task doc als beschrijving
   - Controleer eerst of er nog open CRITICAL of HIGH bevindingen zijn — zo ja: **maak GEEN PR**

**Elke agent heeft zijn eigen beslissingen al verwerkt tijdens de sessie.**
Start-work controleert en finaliseert alleen.

---

## Samenvatting flow

```
Capture → Branch aangemaakt
    ↓
Stap 1   Architect plant — plan mode
    ↓
Stap 1b  API design indien interface geraakt — plan mode
    ↓
Stap 2   Test-planner definieert scenarios — plan mode
    ↓
Stap 3   Test agent bouwt rode tests — normal mode (TDD Red)
    ↓
Stap 4   Developer agents implementeren — normal mode (TDD Green)
         (parallel indien API contract beschikbaar)
    ↓
Stap 5   Tests draaien + refactor → rood: terug naar Stap 4
    ↓
Stap 6   Documentation agent → ADR, README, architecture
    ↓
Stap 7   Review agents als groep — plan mode
         (doc-reviewer als laatste, checkt ook Stap 6)
    ↓        ↑
    |    API geraakt? → terug naar Stap 1b
    |    Implementatie geraakt? → terug naar Stap 4
    ↓
Stap 8   Task doc finalisatie + PR aanmaken
```

---

## Afwijkingen per type

### Bug
- Stap 1b (API Design) alleen als de fix een interface wijzigt
- Stap 2 test scenarios focussen op reproductie van de bug + verificatie van de fix
- P1 bugs: Stap 7 review mag beperkt — alleen security en resilience als relevant

### Chore
- Stap 1b (API Design) nooit — chores raken geen user-facing interfaces
- Stap 2 test scenarios focussen op regressie — wat mag er niet kapot gaan
- Kleine chores (geen doc): direct uitvoeren als `chore:` commit, geen proces nodig

---

## Waar dit document naar verwijst

- API contract template: `/docs/architecture/api-contracts/`
- Feature template: `.claude/skills/new-feature/feature-template.md`
- Bug template: `.claude/skills/capture-bug/bug-template.md`
- Chore template: `.claude/skills/capture-chore/chore-template.md`
- Agent definities: `.claude/agents/`
- Review standards per agent: `/docs/architecture/`
