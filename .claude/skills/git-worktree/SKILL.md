---
name: git-worktree
description: Centrale worktree kennis — aanmaken, beheren, opruimen van git worktrees. Naming conventie, symlinks voor CLAUDE.md en .claude/, parallelle sessies.
argument-hint: "[create|list|remove] [branch naam]"
user-invocable: true
---

# Git Worktree Management

Je beheert git worktrees voor parallelle Claude Code sessies. Elke worktree is een aparte working directory met een eigen branch en eigen Claude Code sessie.

---

## Huidige situatie

- **Repo:** !`basename "$(git rev-parse --show-toplevel)"`
- **Branch:** !`git branch --show-current`
- **Worktrees:** !`git worktree list`

---

## Kernprincipes

- **Eén Claude Code sessie = één worktree = één branch**
- Nooit twee sessies in dezelfde working directory
- Nooit `git checkout` naar een branch waarop een actieve sessie draait
- Worktrees delen dezelfde git history — commits in de ene zijn zichtbaar in de andere

---

## Naming conventie

```
[repo-naam]--[branch-naam-met-streepjes]
```

Voorbeelden:
```
my-service--feature-product-card
my-service--bug-P2-checkout-total-wrong
my-service--chore-spring-boot-3-upgrade
```

De worktree directory wordt aangemaakt **naast** de hoofdrepo, niet erin:
```
/projects/my-service/                          ← hoofdrepo
/projects/my-service--feature-product-card/    ← worktree
/projects/my-service--bug-P2-checkout-total/   ← worktree
```

---

## Worktree aanmaken

### Commando's
```bash
# Vanuit de hoofdrepo
cd /pad/naar/hoofdrepo

# Worktree aanmaken voor bestaande branch
git worktree add ../[repo-naam]--[branch-met-streepjes] [branch-naam]

# Voorbeeld
git worktree add ../my-service--feature-product-card feature/product-card
```

### Symlinks aanmaken
Na het aanmaken van de worktree, maak symlinks voor gedeelde configuratie:

```bash
cd ../[repo-naam]--[branch-met-streepjes]

# CLAUDE.md symlink
ln -s /pad/naar/hoofdrepo/CLAUDE.md CLAUDE.md

# .claude/ directory symlink
ln -s /pad/naar/hoofdrepo/.claude .claude
```

**Waarom symlinks:**
- CLAUDE.md en .claude/ moeten in elke worktree beschikbaar zijn
- Wijzigingen in agents/skills zijn direct zichtbaar in alle worktrees
- Geen duplicatie, geen drift

### Verificatie
Na aanmaken, controleer:
```bash
# Worktree lijst
git worktree list

# Controleer symlinks
ls -la CLAUDE.md .claude

# Controleer branch
git branch --show-current
```

---

## Worktree gebruiken

### Nieuwe sessie starten
```bash
cd /pad/naar/worktree
claude  # start nieuwe Claude Code sessie
```

Elke worktree heeft zijn eigen:
- Working directory met bestanden
- Git index (staging area)
- Branch

Maar deelt:
- Git objects (commits, blobs)
- Git configuratie
- Remotes

### Parallel werken
Typisch scenario: backend en frontend parallel aan dezelfde feature.

```bash
# Sessie 1 — backend
cd /projects/my-service--feature-product-card
claude  # backend-developer agent

# Sessie 2 — frontend (aparte worktree, zelfde of andere branch)
cd /projects/my-service--feature-product-card-frontend
claude  # frontend-developer agent
```

---

## Worktree opruimen

### Na merge
Wanneer een branch gemerged is naar main:

```bash
# Vanuit de hoofdrepo
cd /pad/naar/hoofdrepo

# Worktree verwijderen
git worktree remove ../[repo-naam]--[branch-met-streepjes]

# Opruimen van stale entries
git worktree prune

# Branch verwijderen (optioneel, als remote ook verwijderd is)
git branch -d [branch-naam]
```

### Gemerged detecteren
Controleer welke worktree branches al gemerged zijn:

```bash
# Lijst van alle worktrees
git worktree list

# Check per branch of die gemerged is
git branch --merged main
```

Worktrees waarvan de branch in `--merged` staat zijn kandidaat voor cleanup.

### Bulk cleanup
```bash
# Alle gemerged worktrees opruimen
for wt in $(git worktree list --porcelain | grep "^worktree" | awk '{print $2}'); do
  branch=$(git -C "$wt" branch --show-current 2>/dev/null)
  if [ -n "$branch" ] && git branch --merged main | grep -q "$branch"; then
    echo "Removing merged worktree: $wt ($branch)"
    git worktree remove "$wt"
  fi
done
git worktree prune
```

---

## Veelvoorkomende problemen

### Worktree locked
Als een worktree locked is (crash, niet netjes afgesloten):
```bash
git worktree unlock ../[worktree-pad]
```

### Branch al uitgecheckt
Foutmelding: "branch is already checked out at..."
- Dit betekent dat een andere worktree deze branch al heeft
- Gebruik die bestaande worktree, of verwijder de oude eerst

### Symlinks kwijt
Als CLAUDE.md of .claude/ niet werkt in een worktree:
```bash
# Verwijder en maak opnieuw
rm -f CLAUDE.md
rm -f .claude
ln -s /pad/naar/hoofdrepo/CLAUDE.md CLAUDE.md
ln -s /pad/naar/hoofdrepo/.claude .claude
```

---

## Regels

- Maak ALTIJD symlinks aan voor CLAUDE.md en .claude/
- Gebruik ALTIJD de naming conventie `[repo]--[branch-met-streepjes]`
- Ruim ALTIJD worktrees op na merge
- Start NOOIT twee Claude Code sessies in dezelfde worktree
- Doe NOOIT `git checkout` in een worktree naar een andere branch — maak een nieuwe worktree
