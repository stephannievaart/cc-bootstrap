---
name: git-workflow
description: Git conventies voor developer agents. Branch strategie, commit conventies, WIP commits, pre-push checks, PR proces, worktree regels. Wordt stilzwijgend geladen door alle developer agents.
user-invocable: false
---

# Git Workflow — Developer Agent Regels

Deze skill wordt automatisch geladen door alle developer agents. Het bevat de git conventies die tijdens implementatie gevolgd moeten worden.

---

## Branch strategie

- Alle branches komen direct van `main` — geen develop branch
- Branch naming:
  - `feature/[naam]` — nieuwe functionaliteit
  - `bug/[P1|P2|P3]-[naam]` — bugfix met severity prefix
  - `chore/[naam]` — technisch werk
- Eén task doc = één branch — nooit meerdere taken op dezelfde branch
- Branches worden aangemaakt door git-capture bij het vastleggen van een taak

---

## Commit conventies

### Types
| Type | Gebruik |
|------|---------|
| `feat` | Nieuwe functionaliteit |
| `fix` | Bugfix |
| `chore` | Technisch werk zonder user-visible gedragsverandering |
| `docs` | Documentatie wijzigingen |
| `test` | Test toevoegingen of wijzigingen |
| `refactor` | Code herstructurering zonder gedragswijziging |

### Format
```
[type]: [beschrijving in tegenwoordige tijd, Engels]
```

Voorbeelden:
```
feat: add product card price display
fix: correct null check on user session expiry
chore: upgrade Spring Boot 2.7 to 3.3
docs: add feature doc for product-card
test: add integration tests for checkout flow
refactor: extract payment validation to separate service
```

### Regels
- Beschrijving altijd in tegenwoordige tijd ("add" niet "added")
- Eerste letter lowercase na het type prefix
- Geen punt aan het einde
- Houd de eerste regel onder 72 tekens
- Voeg een body toe bij complexe wijzigingen (lege regel na subject)

---

## WIP commits

WIP commits zijn voor context switches — wanneer je tijdelijk ander werk moet doen.

### Format
```
WIP: [beschrijving van huidige staat]
```

### Regels
- WIP commits worden **nooit** gemerged naar main
- Voor een PR: squash of amend alle WIP commits weg
- Een WIP commit moet informatief zijn over de staat van het werk
- Goed: `WIP: product card layout klaar, prijslogica nog niet gestart`
- Fout: `WIP: wip` of `WIP: temp`

---

## Pre-push checks

**Voor elke push, controleer:**

1. **Tests groen?**
   ```bash
   [test commando uit CLAUDE.md]
   ```
   Nooit pushen met rode tests.

2. **Geen debug code?**
   - Geen `console.log`, `print()`, `System.out.println()` die er niet hoort
   - Geen commented-out code
   - Geen hardcoded test data

3. **Geen secrets?**
   - Geen `.env` bestanden
   - Geen API keys, wachtwoorden, tokens in de code
   - Check met `git diff --cached` voor de push

4. **Branch up-to-date met main?**
   ```bash
   git fetch origin main
   git rebase origin/main
   ```
   Los merge conflicts op voor je pusht.

---

## PR proces

### Voordat je een PR aanmaakt
- [ ] Alle acceptatiecriteria uit de task doc zijn geïmplementeerd
- [ ] Alle tests groen
- [ ] Alle review bevindingen hebben status `FIXED` of `ACCEPTED`
- [ ] Branch is up-to-date met main (rebase)
- [ ] Geen WIP commits meer in de history
- [ ] Task doc is volledig ingevuld

### PR beschrijving
- Gebruik de task doc inhoud als basis voor de PR beschrijving
- Link naar de task doc in de PR
- Markeer breaking changes prominent

### Na de PR
- Nooit je eigen PR mergen zonder review
- Na merge: worktree opruimen (als die er is)
- Branch verwijderen na merge

---

## Worktree conventies

### Naming
```
[repo-naam]--[branch-naam-met-streepjes]
```

### Regels
- Eén Claude Code sessie per worktree
- Nooit twee sessies in dezelfde working directory
- Nooit `git checkout` naar een branch waarop een actieve sessie draait
- CLAUDE.md en `.claude/` altijd als symlink in elke worktree
- Worktrees opruimen na merge: `git worktree remove` + `git worktree prune`

---

## Verboden — zonder uitzondering

- `git push --force` op `main`
- `--no-verify` zonder expliciete goedkeuring van de gebruiker
- Secrets of `.env` bestanden committen
- Rebasen van gedeelde branches (main)
- `git checkout` terwijl een andere sessie actief is op de doelbranch
- Direct committen op `main`
