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

### 4. Check branch uit (worktree enforcement)
- Lees de branch naam uit de task doc (zoek naar `Branch:`)
- Elke branch heeft altijd een worktree (aangemaakt door git-capture)
- Detecteer het pad:
  ```bash
  REPO_NAME=$(basename $(git rev-parse --show-toplevel))
  BRANCH_DASHES=$(echo [branch] | tr '/' '-')
  WORKTREE_PATH="../${REPO_NAME}--${BRANCH_DASHES}"
  ```
- **Als de worktree bestaat én de huidige working directory is NIET die worktree:**
  STOP. Meld expliciet:
  > "Deze taak hoort in de worktree op `[WORKTREE_PATH]`.
  > Open daar een nieuwe Claude Code sessie en voer `/start-work` opnieuw uit."
- **Als de huidige working directory WEL de juiste worktree is:** ga door.
- **Als de worktree niet bestaat** (edge case: handmatig verwijderd):
  Maak hem aan met `git worktree add [WORKTREE_PATH] [branch]`
  en meld daarna hetzelfde als hierboven (open sessie in de worktree).
- Pull laatste wijzigingen: `git pull origin [branch]` (als remote bestaat)

### 5. /clear herinnering
Meld aan de gebruiker:
> "Is dit je eerste actie in deze sessie? Dan kun je doorgaan.
> Heb je al eerder werk gedaan in deze sessie? Doe dan eerst `/clear`
> en zeg daarna 'ga verder met [taaknaam]'."

**Wacht op bevestiging — ga niet door tot de gebruiker antwoordt.**

---

## Na /clear — Workflow stappen

Wanneer de gebruiker terugkomt na `/clear`, orkestreer de stappen:

### Algemene regel voor agent-aanroepen
Als een agent-aanroep geen bruikbare output oplevert (lege response, foutmelding, of agent stopt zonder resultaat):
- Meld aan de gebruiker welke agent faalde en in welke stap.
- Vraag of de stap handmatig uitgevoerd moet worden of opnieuw geprobeerd moet worden.
- Ga nooit automatisch door naar de volgende stap als de output van de vorige stap ontbreekt — vervolgstappen bouwen hierop voort.

### Stap 1 — Planning (plan mode)
- Roep de **architect agent** aan
- De architect leest de task doc en legt de aanpak vast onder `## Aanpak`
- Bepaalt welke lagen geraakt worden
- Bepaalt of er een API wijziging is → zo ja, Stap 1b

### Stap 1b — API Design-First (plan mode, conditioneel)
- Alleen als Stap 1 aangeeft dat er een interface geraakt wordt
- Roep de **api-design agent** aan
- Contract wordt geschreven in `/docs/architecture/api-contracts/[branch-naam].md`
- **Wacht op goedkeuring van de gebruiker voor je doorgaat.**
  Als de gebruiker aangeeft te willen overslaan of geen API wijziging nodig is: sla Stap 1b over en ga door naar Stap 2. Leg dit vast in de task doc onder ## Aanpak: "Stap 1b overgeslagen: [reden]."

### Stap 2 — Test scenarios (plan mode)
- Roep de **test-automation agent** aan in **plan mode** (nog geen testcode schrijven, alleen scenarios vastleggen in de task doc onder `## Test scenarios`)
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
- **Na 3 iteraties nog steeds rood:** stop. Meld aan de gebruiker: "De tests blijven rood na 3 iteraties. Beoordeel handmatig of de aanpak herzien moet worden, of accepteer de rode tests bewust voor de PR." Ga niet verder terug naar Stap 4 — wacht op gebruikersinput.
- **Bij groen:** refactor indien nodig, dan door naar Stap 6

### Stap 6 — Documentation (normal mode)
- Roep de **documentation agent** aan
- Finaliseert ADR indien aanwezig
- Bijwerken README.md indien relevant
- Meldt aan de documentation agent welke structuurwijzigingen er zijn zodat die ze kan verwerken in de relevante architecture docs
- **Geen PR, geen task doc verplaatsing** — dat gebeurt in Stap 8

### Stap 7 — Review (plan mode)
- Roep de review agents aan. In Claude Code betekent parallel: start elke agent in een aparte subagent-aanroep binnen dezelfde sessie, of roep ze sequentieel aan als parallelle aanroep niet beschikbaar is. Volgorde bij sequentieel: security reviewer eerst, dan de overige reviewers, doc-reviewer altijd als laatste.
  - API contract reviewer (als er een contract is)
  - DBA reviewer (als database geraakt)
  - Non-functional reviewer (resilience + observability, altijd bij features/bugs)
  - Security reviewer (altijd)
  - **Doc-reviewer als laatste** — controleert ook het werk van de documentation agent uit Stap 6
- Bevindingen in task doc onder `## Review bevindingen`
- Bij CRITICAL/HIGH: terug naar Stap 4 (of Stap 1b als API geraakt)
- Bij alleen WARN/INFO/LOW: bespreek met gebruiker → fixen of accepteren

### Stap 8 — PR creation + task doc finalisatie (normal mode)
Dit wordt door start-work zelf georkestreerd (geen aparte agent):

1. **Task doc volledigheid controleren** — check dat alle verplichte secties ingevuld zijn:
   - `## Beschrijving`, `## Acceptatiecriteria`, `## Aanpak`, `## Test scenarios`, `## Implementatie notities`, `## Review bevindingen`
   - Als secties ontbreken of leeg zijn: **meld dit aan gebruiker** — vul ze niet zelf in
2. **Task doc status wijzigen** — wijzig frontmatter `status: in-progress` naar `status: done` en commit op de feature branch:
   ```bash
   git add docs/work/[type]/[task-doc].md
   git commit -m "docs: markeer [taaknaam] als done"
   ```
   De statuswijziging zit bewust in de PR commit — zo is done alleen effectief op main na een echte merge. Als de PR geweigerd wordt, blijft main ongewijzigd.
3. **PR aanmaken** — `gh pr create --title "[type]: [beschrijving]" --body "$(cat docs/work/[type]/[task-doc].md)"`
   - Controleer eerst of er nog open CRITICAL of HIGH bevindingen zijn — zo ja: **maak GEEN PR**
4. Meld aan de gebruiker: "Na merge, voer `/post-merge` uit om branch, worktree, en task doc op te ruimen."

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

- **Altijd vragen of sessie vers is** — gebruiker bevestigt zelf of /clear nodig is
- **Elke taak mag maar door één worktree tegelijk bewerkt worden** — check via branch matching
- **Volg de stappen in volgorde** — sla er nooit een over
- **Plan mode stappen mogen nooit code schrijven**
- **Review agents mogen nooit code wijzigen**
- **Wacht op gebruiker goedkeuring** bij API contract (Stap 1b)
