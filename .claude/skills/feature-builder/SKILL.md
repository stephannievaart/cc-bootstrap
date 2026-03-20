---
name: feature-builder
description: Geladen door developer agents. Bewaakt het bouwproces — vindt task doc via branch matching, stopt bij scope creep, checkt acceptatiecriteria na afloop.
user-invocable: false
---

# Feature Builder

Deze skill wordt geladen door alle developer agents (backend-developer, frontend-developer, ui-designer). Het bewaakt de discipline tijdens implementatie.

---

## Voor het coderen begint

### 1. Lees de task doc via branch matching
- Bepaal de huidige branch: `git branch --show-current`
- Zoek de task doc waarvan `Branch:` matcht met de huidige branch:
  ```bash
  CURRENT_BRANCH=$(git branch --show-current)
  grep -rl "Branch: .*${CURRENT_BRANCH}" docs/work/
  ```
- Als er geen match is: **STOP** — "Je zit op branch [branch] maar er is geen in-progress task doc voor deze branch. Gebruik `/start-work` om een taak te starten."
- Als er een match is: lees het HELE document — niet alleen de titel
- Noteer specifiek:
  - **Acceptatiecriteria** — dit definieert "done"
  - **Scope (wel/niet)** — dit definieert de grenzen
  - **Aanpak** — het plan van de architect (sectie ## Aanpak)
  - **API contract** — indien aanwezig in docs/architecture/api-contracts/[branch-naam].md — implementeer hier tegenaan
  - **Test scenarios** — je code moet deze scenarios dekken (sectie ## Test scenarios)

### 2. Controleer dat de taak in-progress is
- De gevonden task doc moet `status: in-progress` hebben
- Als de status anders is (bijv. `backlog` of `done`): **STOP** en meld dit aan de gebruiker
- Meerdere taken mogen tegelijk in-progress zijn — dat is normaal bij worktree-gebaseerd werken

### 3. Controleer afhankelijkheden
- Lees het `## Afhankelijkheden` sectie in de task doc
- Als er afhankelijkheden zijn die nog niet klaar zijn: **meld dit**
- De gebruiker beslist of het werk toch kan starten

### 4. Laad relevante context
- Lees het API contract als dat er is (`docs/architecture/api-contracts/[branch-naam].md`)
- Lees relevante architecture docs als het plan daarnaar verwijst
- Lees relevante ADRs als die worden genoemd in de aanpak

---

## Tijdens het coderen

### 5. Implementatie notities bijwerken
Schrijf je beslissingen direct in de task doc onder `## Implementatie notities`:
- Waarom je iets op een bepaalde manier hebt gebouwd
- Afwijkingen van het plan (met motivatie)
- Technische keuzes die later relevant zijn voor reviewers
- Onverwachte complexiteit die je bent tegengekomen

**Doe dit TIJDENS het bouwen, niet achteraf.**

### 6. Scope creep detectie
Bij elke wijziging die je maakt, controleer:
- Valt dit binnen de `## Scope → Wel` sectie?
- Staat dit NIET in de `## Scope → Niet` sectie?
- Past dit bij de acceptatiecriteria?

**Als je iets bouwt dat buiten scope valt:**
1. **STOP onmiddellijk**
2. Meld aan de gebruiker: "Dit valt buiten de scope van deze feature: [wat je wilde doen]"
3. Suggereer: "Dit kan als aparte feature worden vastgelegd via `/new-feature`"
4. Ga NIET verder met het buiten-scope werk

### 7. Build fouten
- Als de build faalt tijdens implementatie: probeer het eerst zelf op te lossen
- Als het niet lukt na 2 pogingen: roep de build-error-resolver agent aan
- Noteer de fout en oplossing in de implementatie notities

---

## Na het coderen

### 8. Implementatie notities gate
Controleer de task doc `## Implementatie notities` sectie voordat je verder gaat:
- Als de sectie **leeg is of ontbreekt** → **STOP** — "Implementatie notities zijn verplicht. Documenteer minimaal: (1) afwijkingen van het plan of bevestiging dat er geen zijn, (2) technische keuzes die niet obvious zijn uit de code."
- Als de sectie **alleen een placeholder of TODO bevat** → behandel als leeg
- Pas als er inhoudelijke notities staan → ga verder met acceptatiecriteria

### 9. Acceptatiecriteria checken
Loop elk acceptatiecriterium uit de task doc na:
- Is het geïmplementeerd? → markeer als gedaan
- Is het niet geïmplementeerd? → meld dit expliciet
- Is het gedeeltelijk geïmplementeerd? → beschrijf wat er nog mist

### 10. Handoff voorbereiden
Bereid de handoff voor naar de test automation agent:
- Zijn alle scenarios uit `## Test scenarios` adresseerbaar?
- Zijn er nieuwe edge cases ontdekt tijdens implementatie? → voeg toe aan de doc
- Zijn er specifieke test configuraties nodig?

### 11. Controleer of alles gecommit is
- Geen uncommitted changes mogen achterblijven
- Gebruik descriptieve commit messages: `feat: [wat]`, `fix: [wat]`, etc.
- Geen WIP commits laten staan (tenzij je expliciet switcht)

---

## Regels — ononderhandelbaar

- **Lees altijd eerst de volledige task doc** — begin nooit blind
- **Bouw nooit buiten scope** — meld en park het
- **Schrijf implementatie notities tijdens het bouwen** — niet achteraf
- **Wijzig nooit het API contract** — als het contract niet klopt, meld het en wacht
- **Negeer nooit test scenarios** — je code moet ze allemaal dekken
- **De architect bepaalt de aanpak** — volg het plan, of motiveer afwijkingen in de doc
