---
name: git-workflow
description: Git conventies voor developer agents. Branch strategie, commit conventies, WIP commits, PR proces, worktree regels. Wordt stilzwijgend geladen door alle developer agents.
user-invocable: false
---

# Git Workflow — Developer Agent Regels

Deze skill wordt automatisch geladen door alle developer agents.

---

## Branch strategie

- Alle branches komen direct van `main` — geen develop branch
- Branch naming:
  - `feature/[naam]` — nieuwe functionaliteit
  - `bug/[naam]` — bugfix (optioneel severity prefix: `bug/P1-[naam]`)
  - `chore/[naam]` — technisch werk
- Eén task doc = één branch — nooit meerdere taken op dezelfde branch

---

## Commit conventies

| Type | Gebruik |
|------|---------|
| `feat` | Nieuwe functionaliteit |
| `fix` | Bugfix |
| `chore` | Technisch werk zonder user-visible gedragsverandering |
| `docs` | Documentatie wijzigingen |
| `test` | Test toevoegingen of wijzigingen |
| `refactor` | Code herstructurering zonder gedragswijziging |

Format: `[type]: [beschrijving]`
- Houd de eerste regel onder 80 tekens
- Body toevoegen bij complexe wijzigingen (lege regel na subject)

---

## WIP commits

Format: `WIP: [beschrijving van huidige staat]`

- WIP commits worden **nooit** gemerged naar main — squash of amend voor PR
- Informatief over de staat: `WIP: product card layout klaar, prijslogica nog niet gestart`
- Nooit: `WIP: wip` of `WIP: temp`

---

## Merge strategie

- Squash merge als default — houdt main history schoon
- Merge commit alleen bij grote features waar individuele commits informatief zijn
- Rebase merge niet gebruiken op gedeelde branches

---

## Pre-push checks

Voor elke push:
1. Tests groen — nooit pushen met rode tests
2. Geen debug logging die er niet hoort
3. Branch up-to-date met main (rebase)

---

## PR proces

### Voordat je een PR aanmaakt
- [ ] Alle acceptatiecriteria uit de task doc zijn geïmplementeerd
- [ ] Alle tests groen
- [ ] Alle review bevindingen hebben status `FIXED` of `ACCEPTED`
- [ ] Geen WIP commits meer in de history
- [ ] Task doc is volledig ingevuld

### PR beschrijving
- Gebruik de task doc inhoud als basis
- Link naar de task doc
- Markeer breaking changes prominent

### Na de PR
- Nooit je eigen PR mergen zonder review
- Na merge: worktree opruimen, branch verwijderen

---

## Worktree conventies

Naming: `[repo-naam]--[branch-naam-met-streepjes]`

- Eén Claude Code sessie per worktree
- Nooit twee sessies in dezelfde working directory
- CLAUDE.md en `.claude/` altijd als symlink in elke worktree
- Opruimen na merge: `git worktree remove` + `git worktree prune`

---

## Verboden

- Rebasen van gedeelde branches (main)
- `git checkout` naar een branch waarop een actieve sessie draait
