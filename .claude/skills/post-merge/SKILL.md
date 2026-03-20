---
name: post-merge
description: Afronding na een gemerged PR. Verplaatst task doc naar done, verwijdert de branch lokaal en remote, ruimt de worktree op, en bevestigt dat main up-to-date is.
argument-hint: "[branch naam of taaknaam]"
user-invocable: true
---

# Post-Merge — Afronding na gemerged PR

Je rondt een taak af nadat de PR gemerged is. Dit omvat: task doc afsluiten, branch opruimen, worktree verwijderen, en main updaten.

---

## Huidige situatie

- **Repo:** !`basename "$(git rev-parse --show-toplevel)"`
- **Branch:** !`git branch --show-current`
- **Worktrees:** !`git worktree list`
- **Gemerged branches:** !`git branch --merged main`

---

## Stap 1 — Identificeer de gemerged branch

Als de gebruiker een argument meegeeft:
- Zoek een branch die matcht op naam (exact of partial match)
- Controleer of de branch daadwerkelijk gemerged is in main: `git branch --merged main | grep [branch]`

Als de gebruiker geen argument meegeeft:
- Toon de lijst van gemerged branches (exclusief main zelf)
- Laat de gebruiker kiezen

**Als de branch niet gemerged is:** meld dit en stop — deze skill is alleen voor afgeronde PRs.

---

## Stap 2 — Zoek de task doc

Zoek in `docs/work/` naar een doc met `Branch: [branch-naam]`:
```bash
grep -rl "Branch:.*[branch-naam]" docs/work/
```

Als er geen match is: meld dit en ga door met Stap 5 (branch cleanup) — niet elke branch heeft een task doc.

---

## Stap 3 — Wijzig task doc status

Open de task doc en wijzig de frontmatter:
```yaml
status: done
```

---

## Stap 4 — Verplaats task doc naar done

Bepaal het type (features, bugs, of chores) op basis van het huidige pad en verplaats:
```bash
# Maak done directory aan als die niet bestaat
mkdir -p docs/work/[type]/done

# Verplaats de doc
mv docs/work/[type]/[bestandsnaam] docs/work/[type]/done/[bestandsnaam]
```

Commit op main:
```bash
git add docs/work/
git commit -m "docs: sluit [taaknaam] af na merge"
```

---

## Stap 5 — Verwijder branch lokaal

```bash
git branch -d [branch-naam]
```

---

## Stap 6 — Verwijder branch remote

```bash
git push origin --delete [branch-naam]
```

---

## Stap 7 — Ruim worktree op

Bepaal het worktree pad:
```bash
REPO_NAME=$(basename $(git rev-parse --show-toplevel))
BRANCH_DASHES=$(echo [branch-naam] | tr '/' '-')
WORKTREE_PATH="../${REPO_NAME}--${BRANCH_DASHES}"
```

Als de worktree bestaat:
```bash
git worktree remove $WORKTREE_PATH
git worktree prune
```

Als de worktree niet bestaat: sla over — mogelijk al handmatig opgeruimd.

---

## Stap 8 — Pull main

```bash
git pull origin main
```

---

## Stap 9 — Bevestig aan de gebruiker

Geef een samenvatting:
- Welke task doc is afgesloten en verplaatst
- Welke branch is verwijderd (lokaal en remote)
- Welke worktree is opgeruimd
- Dat main up-to-date is
- Verwijs naar `/feature-planner` voor de volgende taak

---

## Foutafhandeling

Elke stap kan onafhankelijk falen. Bij een fout: **meld het en ga door met de volgende stap** — stop niet volledig.

Veelvoorkomende situaties:
- **Branch al verwijderd remote** (bijv. GitHub auto-delete na merge) — meld en ga door
- **Worktree bestaat niet** — meld en ga door
- **Task doc niet gevonden** — meld en ga door met branch cleanup
- **Branch niet lokaal aanwezig** — fetch eerst, dan verwijder remote

---

## Regels

- Draai deze skill ALLEEN voor branches die daadwerkelijk gemerged zijn — nooit voor open PRs
- Draai ALTIJD `git worktree prune` na worktree verwijdering
- Controleer ALTIJD dat je op main zit voordat je begint — checkout main als dat niet zo is
- Stop NOOIT volledig bij een fout in een enkele stap — meld en ga door
