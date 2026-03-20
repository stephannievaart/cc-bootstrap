---
name: abandon-task
description: Abandon een vastgelopen taak. Markeert als abandoned, ruimt branch en worktree op. Vraagt altijd bevestiging.
argument-hint: "[taaknaam of branch naam]"
user-invocable: true
---

# Abandon Task — Vastgelopen taak veilig abandonen

Je abandont een taak die niet meer afgemaakt wordt. Dit markeert de task doc als abandoned, ruimt de branch en worktree op, en verplaatst de doc naar done/.

---

## Huidige situatie

- **Branch:** !`git branch --show-current`
- **Worktrees:** !`git worktree list`
- **In-progress taken:** !`grep -rl "status: in-progress" docs/work/ 2>/dev/null || echo "geen"`

---

## Stap 1 — Identificeer de taak

Als de gebruiker een argument meegeeft:
- Zoek in `docs/work/` naar een doc met `Branch:` dat matcht op de opgegeven naam (exact of partial match)
- Zoek ook op titel en bestandsnaam als Branch niet matcht

```bash
grep -rl "Branch:.*[argument]" docs/work/
```

Als de gebruiker geen argument meegeeft:
- Toon de in-progress taken en laat kiezen
- Als er geen in-progress taken zijn: meld dit en stop

**Als er geen match is:** meld dit en stop — er is geen taak om te abandonen.

---

## Stap 2 — Bevestiging vragen

Lees de task doc en toon:
- **Titel** van de taak
- **Huidige status** uit frontmatter
- **Branch** uit de doc
- **Aantal commits boven main:**
  ```bash
  git rev-list --count main..[branch-naam]
  ```

Controleer op uncommitted changes op de branch:
```bash
git stash list
git -C [worktree-pad] status --porcelain 2>/dev/null
```

**Als er uncommitted changes zijn:** waarschuw extra prominent:
> "LET OP: Er zijn uncommitted wijzigingen in de worktree. Deze gaan verloren bij abandon."

Toon altijd deze waarschuwing:
> "Dit abandont de taak. De branch en worktree worden verwijderd. Uncommitted wijzigingen gaan verloren. [N] commit(s) boven main gaan verloren."

**Als de gebruiker in de worktree van deze taak zit:**
> "Je zit momenteel in de worktree van deze taak. Navigeer eerst naar de hoofd-repo of een andere directory voordat je verdergaat."
Stop en wacht tot de gebruiker bevestigt dat ze elders zitten.

**Wacht op expliciete bevestiging — ga NOOIT automatisch door.**

---

## Stap 3 — Status wijzigen

Checkout de feature branch (als je er niet al op zit):
```bash
git checkout [branch-naam]
```

Wijzig de YAML frontmatter in de task doc van de huidige status naar `status: abandoned`:
```bash
sed -i '' 's/^status: in-progress/status: abandoned/' docs/work/[type]/backlog/[task-doc].md
```

Vraag de gebruiker om de reden van abandon.

Voeg een `## Abandoned` sectie toe aan het einde van de task doc:
```markdown
## Abandoned

- **Datum:** [YYYY-MM-DD]
- **Reden:** [reden van gebruiker]
- **Commits verloren:** [aantal]
```

Commit op de feature branch:
```bash
git add docs/work/[type]/backlog/[task-doc].md
git commit -m "docs: markeer [taaknaam] als abandoned"
```

---

## Stap 4 — Terugkeren naar main

```bash
git checkout main
git pull origin main
```

Als git checkout main faalt: meld dit aan de gebruiker en stop.

---

## Stap 5 — Branch en worktree opruimen

### Worktree verwijderen

Bepaal het worktree pad:
```bash
REPO_NAME=$(basename $(git rev-parse --show-toplevel))
BRANCH_DASHES=$(echo [branch-naam] | tr '/' '-')
WORKTREE_PATH="../${REPO_NAME}--${BRANCH_DASHES}"
```

Als de worktree bestaat:
```bash
git worktree remove --force $WORKTREE_PATH
git worktree prune
```

Als de worktree niet bestaat: meld en ga door.

### Branch lokaal verwijderen

```bash
git branch -D [branch-naam]
```

Force delete (`-D`) omdat de branch niet gemerged is.

### Branch remote verwijderen

```bash
git push origin --delete [branch-naam]
```

Als de remote branch niet bestaat (bijv. nooit gepusht): meld en ga door.

---

## Stap 6 — Task doc verplaatsen

Verplaats de task doc naar `docs/work/[type]/done/`:
```bash
mkdir -p docs/work/[type]/done
mv docs/work/[type]/backlog/[task-doc].md docs/work/[type]/done/[task-doc].md
```

Commit op main:
```bash
git add docs/work/
git commit -m "docs: verplaats abandoned taak [taaknaam] naar done"
```

---

## Stap 7 — Bevestig

Geef een samenvatting:
- Welke taak is abandoned (titel + reden)
- Hoeveel commits verloren zijn gegaan
- Welke branch is verwijderd (lokaal en remote)
- Welke worktree is opgeruimd
- Dat de task doc verplaatst is naar done/

Meld:
> "De taak kan opnieuw opgepakt worden door een nieuwe feature/bug/chore aan te maken op basis van de abandoned doc in docs/work/[type]/done/."

---

## Foutafhandeling

Elke stap kan onafhankelijk falen. Bij een fout: **meld het en ga door met de volgende stap** — stop niet volledig.

Veelvoorkomende situaties:
- **Branch bestaat niet lokaal** — fetch eerst, probeer opnieuw
- **Branch al verwijderd remote** — meld en ga door
- **Worktree bestaat niet** — meld en ga door
- **Task doc niet gevonden** — meld en stop (zonder doc is er niets te abandonen)
- **Geen commits boven main** — meld "0 commits" en ga gewoon door

---

## Regels

- Vraag ALTIJD bevestiging — ga NOOIT automatisch door met abandonen
- Waarschuw extra prominent bij uncommitted changes
- Als de gebruiker in de worktree van de taak zit: stop tot ze elders zitten
- Stop NOOIT volledig bij een fout in een enkele cleanup stap — meld en ga door
- Draai ALTIJD `git worktree prune` na worktree verwijdering
- Gebruik `git branch -D` (force) — de branch is niet gemerged
