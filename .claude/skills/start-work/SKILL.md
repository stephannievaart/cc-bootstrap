---
name: start-work
description: Start het volledige werkproces voor een feature, bug, of chore. Vindt de task doc, controleert status, wijzigt frontmatter naar in-progress, checkt branch uit, en orkestreert alle stappen.
argument-hint: "[taaknaam of nummer, bijv. F-001 of 'gebruiker login']"
user-invocable: true
---

# Start Work — Taak Workflow Orchestratie

Je start het volledige werkproces voor een taak. Dit is het centrale punt dat alle stappen orkestreert volgens `/docs/workflow/task-workflow.md`.

---

## Huidige situatie

- **Branch:** !`git branch --show-current`
- **In-progress taken:** !`grep -rl "status: in-progress" docs/work/ 2>/dev/null || echo "geen"`
- **Worktrees:** !`git worktree list`

---

## Stap 0 — Voorbereiding

### 1. Identificeer de taak
- Als de gebruiker een taaknaam noemt: zoek het document in `docs/work/features/`, `docs/work/bugs/`, of `docs/work/chores/` (filter op `status: backlog` in frontmatter)
- Als de gebruiker geen naam noemt: toon de opties via feature-planner logica en laat kiezen
- Als het document niet gevonden wordt: meld dit en stop

### 2. Controleer branch-based scoping
Bepaal de huidige branch en zoek in-progress taken:
```bash
CURRENT_BRANCH=$(git branch --show-current)
grep -rl "status: in-progress" docs/work/
```

**Scenario A — Huidige branch is al gekoppeld aan een in-progress taak:**
- Match de huidige branch met `Branch:` velden in de gevonden docs
- Als er een match is: **hervat die taak** — geen nieuwe starten
- Meld: "Je bent al bezig met [titel] op deze branch. Hervat het werk."

**Scenario B — De taak die je wilt starten is al in-progress (door een andere worktree):**
- Check of de gewenste taak al `status: in-progress` heeft en een andere `Branch:` dan de huidige
- **STOP** — meld: "Deze taak wordt al bewerkt in een andere worktree op branch [branch]. Open daar een sessie."

**Scenario C — Er zijn andere taken in-progress en je zit NIET in een worktree:**
- Check of je in een worktree zit: `git worktree list` — als je werkdirectory niet de hoofd-worktree is, zit je in een worktree
- Als je NIET in een worktree zit: adviseer: "Er zijn al [N] taken in progress. Maak een worktree aan met `/git-worktree` voor parallelle verwerking."
- Als je WEL in een worktree zit: ga gewoon door — worktrees zijn bedoeld voor parallel werk

**P1 bugs:** Geen speciale uitzondering meer. P1 bugs volgen dezelfde branch-based scoping regels. De gebruiker opent een nieuwe sessie of worktree om een P1 parallel op te pakken.

### 3. Wijzig status naar in-progress
Open de task doc en wijzig de frontmatter status:
```yaml
status: in-progress
```

Commit: `docs: start werk aan [taaknaam]`

### 4. Check branch uit
- Lees de branch naam uit de task doc (zoek naar `Branch:`)
- Check of er een worktree bestaat voor deze branch
  - Ja: meld aan gebruiker welke worktree te gebruiken
  - Nee: `git checkout [branch]`
- Pull laatste wijzigingen: `git pull origin [branch]` (als remote bestaat)

### 5. Instrueer /clear
Meld aan de gebruiker:
> "Doe nu `/clear` voor een schone sessie. Start daarna opnieuw en zeg 'ga verder met [taaknaam]'."

**Wacht hier — de volgende stappen gebeuren in een schone sessie.**

---

## Na /clear — Workflow stappen

Wanneer de gebruiker terugkomt na `/clear`, orkestreer de stappen:

### Stap 1 — Planning (plan mode)
- Roep de **architect agent** aan
- De architect leest de task doc en legt de aanpak vast onder `## Aanpak`
- Bepaalt welke lagen geraakt worden
- Bepaalt of er een API wijziging is → zo ja, Stap 1b

### Stap 1b — API Design-First (plan mode, conditioneel)
- Alleen als Stap 1 aangeeft dat er een interface geraakt wordt
- Roep de **api-design agent** aan
- Contract wordt geschreven in `/docs/architecture/api-contracts/[branch-naam].md`
- **Wacht op goedkeuring van de gebruiker voor je doorgaat**

### Stap 2 — Test scenarios (plan mode)
- Roep de **test-planner agent** aan (plan mode)
- Scenarios worden geschreven in de task doc onder `## Test scenarios`
- Gebaseerd op acceptatiecriteria uit de doc

### Stap 3 — Tests bouwen — rode tests (normal mode)
- Roep de **test-automation agent** aan (default mode)
- Bouwt rode tests op basis van scenarios uit Stap 2
- Tests moeten FALEN — er is nog geen implementatie
- Dit is de TDD "red" fase: tests bewijzen dat ze iets nuttigs testen

### Stap 4 — Implementatie (normal mode)
- Roep de relevante **developer agents** aan:
  - Backend werk → backend-developer agent
  - Frontend werk → frontend-developer agent
  - UI werk → ui-designer agent
- Developer agents laden automatisch de feature-builder skill (scope bewaking) en git-workflow skill (commit conventies)
- Doel: alle rode tests uit Stap 3 groen maken
- Parallel indien API contract beschikbaar uit Stap 1b

### Stap 5 — Tests draaien + refactor (normal mode)
- Draai de volledige test suite
- **Bij rode tests:** terug naar Stap 4 — developer agents fixen
- **Bij groen:** refactor indien nodig, dan door naar Stap 6

### Stap 6 — Documentation (normal mode)
- Roep de **documentation agent** aan
- Finaliseert ADR indien aanwezig
- Bijwerken README.md indien relevant
- Triggert architecture-updater indien structuurwijzigingen
- **Geen PR, geen task doc verplaatsing** — dat gebeurt in Stap 8

### Stap 7 — Review (plan mode)
- Roep de review agents aan **parallel**:
  - API contract reviewer (als er een contract is)
  - DBA reviewer (als database geraakt)
  - Resilience reviewer (altijd bij features/bugs)
  - Security reviewer (altijd)
  - Logging & observability reviewer (altijd bij features/bugs)
  - Code quality reviewer (altijd)
  - **Doc-reviewer als laatste** — controleert ook het werk van de documentation agent uit Stap 6
- Bevindingen in task doc onder `## Review bevindingen`
- Bij CRITICAL/HIGH: terug naar Stap 4 (of Stap 1b als API geraakt)
- Bij alleen WARN/INFO/LOW: bespreek met gebruiker → fixen of accepteren

### Stap 8 — PR creation + task doc finalisatie (normal mode)
Dit wordt door start-work zelf georkestreerd (geen aparte agent):

1. **Task doc volledigheid controleren** — check dat alle verplichte secties ingevuld zijn:
   - `## Beschrijving`, `## Acceptatiecriteria`, `## Aanpak`, `## Test scenarios`, `## Implementatie notities`, `## Review bevindingen`
   - Als secties ontbreken of leeg zijn: **meld dit aan gebruiker** — vul ze niet zelf in
2. **Task doc status wijzigen** — wijzig frontmatter `status: in-progress` naar `status: done`
3. **PR aanmaken** — `gh pr create --title "[type]: [beschrijving]" --body "$(cat docs/work/[type]/[task-doc].md)"`
   - Controleer eerst of er nog open CRITICAL of HIGH bevindingen zijn — zo ja: **maak GEEN PR**

---

## Afwijkingen per type

**Check het type van de taak en pas de stappen aan volgens de afwijkingen.**

### Bug
- Stap 1b alleen als de fix een interface wijzigt — anders overslaan
- Test scenarios focussen op reproductie van de bug + verificatie van de fix
- P1 bugs: review (Stap 7) mag beperkt — alleen security en resilience als relevant

### Chore
- Stap 1b nooit — chores raken geen user-facing interfaces
- Test scenarios focussen op regressie — wat mag er niet kapot gaan
- Kleine chores: geen proces nodig, direct `chore:` commit

---

## Regels

- **Altijd /clear adviseren voor start** — schone context is essentieel
- **Elke taak mag maar door één worktree tegelijk bewerkt worden** — check via branch matching
- **Volg de stappen in volgorde** — sla er nooit een over
- **Plan mode stappen mogen nooit code schrijven**
- **Review agents mogen nooit code wijzigen**
- **Wacht op gebruiker goedkeuring** bij API contract (Stap 1b)
