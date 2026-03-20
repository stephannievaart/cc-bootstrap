---
name: git-capture
description: Interne git capture logica. Handelt WIP commit, checkout main, doc schrijven, branch aanmaken, push, branch in doc schrijven, en terugkeren naar vorige branch af. Aangeroepen door capture skills.
user-invocable: false
---

# Git Capture — Interne Capture Logica

Deze skill wordt aangeroepen door de drie capture skills (new-feature, capture-bug, capture-chore). Het handelt alle git operaties af zodat de capture skills zich kunnen focussen op het interview en de doc generatie.

**Nooit direct aanroepen door de gebruiker.**

---

## Input van de capture skill

De capture skill levert:
- **doc_path** — volledig pad waar de doc moet komen (bijv. `docs/work/features/product-card.md`)
- **doc_content** — de volledige inhoud van de gegenereerde doc
- **branch_name** — de branchnaam (bijv. `feature/product-card`)

---

## Uitvoering — stap voor stap

### Stap 1 — Huidige staat opslaan
```bash
# Onthoud de huidige branch
PREVIOUS_BRANCH=$(git branch --show-current)
```

### Stap 2 — WIP commit (automatisch, geen confirmatie)
```bash
# Check of er uncommitted changes zijn
git status --porcelain
```

Als er wijzigingen zijn:
```bash
git add -A
git commit -m "WIP: auto-capture — werk geparkeerd voor [branch_name]"
```

Als er geen wijzigingen zijn: sla deze stap over.

**Geen confirmatie vragen — dit is automatisch.**

Als de WIP commit faalt (bijv. geen git user.name of user.email geconfigureerd):
- Meld aan de gebruiker: "WIP commit mislukt. Controleer of git user.name en user.email geconfigureerd zijn: git config user.name '[naam]' && git config user.email '[email]'"
- Stop hier — ga niet door met Stap 3 totdat de commit gelukt is.

### Stap 3 — Checkout main en pull
```bash
git checkout main
git pull origin main
```

### Stap 4 — Doc schrijven
Maak de benodigde directories aan als die niet bestaan:
```bash
mkdir -p $(dirname [doc_path])
```

Schrijf de doc content naar het bestand:
```bash
# Schrijf doc_content naar doc_path
```

Als het schrijven van de doc mislukt (directory aanmaken of bestand schrijven faalt):
- Meld aan de gebruiker welk pad niet aangemaakt kon worden.
- Stop hier — ga niet door met Stap 5. Zonder doc heeft de branch geen context.

### Stap 5 — Branch aanmaken
```bash
git checkout -b [branch_name]
```

### Stap 6 — Branch naam in doc schrijven
Update de doc om de branch naam in te vullen:
- Zoek naar `**Branch:**` in de doc
- Vervang `[wordt ingevuld door git-capture]` met de daadwerkelijke branchnaam

```bash
# Commit de doc met branchnaam
git add [doc_path]
git commit -m "docs: voeg [type] doc toe voor [korte-naam]"
```

De branch naam staat nu in de doc, ongeacht of de push in de volgende stap slaagt.

### Stap 7 — Push naar remote
```bash
git push -u origin [branch_name]
```

Dit zorgt ervoor dat de branch direct op de remote staat. Andere sessies/worktrees kunnen de branch zien.

Als de push faalt: **STOP** — ga niet door naar Stap 8.

### Stap 8 — Worktree aanmaken

Maak een worktree aan voor de nieuwe branch:

```bash
# Bepaal repo naam
REPO_NAME=$(basename $(git rev-parse --show-toplevel))

# Bepaal worktree pad
BRANCH_DASHES=$(echo [branch_name] | tr '/' '-')
WORKTREE_PATH="../${REPO_NAME}--${BRANCH_DASHES}"

# Maak worktree aan
git worktree add $WORKTREE_PATH [branch_name]

# Maak symlinks
ln -s $(git rev-parse --show-toplevel)/CLAUDE.md ${WORKTREE_PATH}/CLAUDE.md
ln -s $(git rev-parse --show-toplevel)/.claude ${WORKTREE_PATH}/.claude
```

### Stap 9 — Terug naar vorige branch
```bash
git checkout $PREVIOUS_BRANCH
```

Als de vorige branch `main` was en er was een WIP commit, dan is er niets om naar terug te keren — de gebruiker was al op main.

---

## Foutafhandeling

### Push faalt
Als `git push` faalt:
- Schrijf bovenaan de task doc:
  `> TODO: Push naar remote mislukt — draai 'git push -u origin [branch_name]' voor je verdergaat. Branch bestaat alleen lokaal en is niet zichtbaar op andere machines.`
- Meld aan de gebruiker:
  > "Push naar remote mislukt. De branch bestaat alleen lokaal — niet zichtbaar op andere machines. Fix de remote verbinding en draai handmatig:
  > `git push -u origin [branch_name]`
  > Ga daarna pas verder."
- **Stop hier — maak geen worktree aan en ga niet terug naar de vorige branch.**

### Worktree aanmaken faalt
Als `git worktree add` faalt:
- Schrijf bovenaan de task doc:
  `> TODO: Worktree aanmaak mislukt — maak handmatig een worktree aan voor je /start-work uitvoert. Draai: git worktree add [WORKTREE_PATH] [branch_name] && ln -s $(git rev-parse --show-toplevel)/CLAUDE.md [WORKTREE_PATH]/CLAUDE.md && ln -s $(git rev-parse --show-toplevel)/.claude [WORKTREE_PATH]/.claude`
- Meld aan de gebruiker:
  > "Worktree aanmaak mislukt. `/start-work` vereist een worktree. Maak deze handmatig aan:
  > `git worktree add [WORKTREE_PATH] [branch_name]`
  > en maak daarna de symlinks voor CLAUDE.md en .claude/."
- **Ga wel door naar Stap 9** (terug naar vorige branch) — de branch en push zijn gelukt.

### Branch bestaat al
Als `git checkout -b` faalt omdat de branch al bestaat:
- Meld: "Branch [naam] bestaat al. Gebruik de bestaande branch."
- Checkout de bestaande branch: `git checkout [branch_name]`
- Ga door met Stap 6

### Merge conflicts op main
Als `git pull origin main` merge conflicts geeft:
- Dit zou niet moeten gebeuren (main is shared, geen lokale commits)
- Als het toch gebeurt: `git merge --abort` en meld het aan de gebruiker
- **Los dit NIET automatisch op**

---

## Regels

- **Altijd WIP commit** bij uncommitted changes — nooit changes laten liggen
- **Geen confirmatie** voor de WIP commit — het is automatisch
- **Altijd pushen** naar remote — de branch moet zichtbaar zijn voor andere sessies
- **Altijd terug naar vorige branch** — de gebruiker werkt door waar die was
- **Nooit doc content wijzigen** — dat is de verantwoordelijkheid van de capture skill
- **Nooit doorgaan bij push-fout** — hard stoppen en gebruiker dwingen te fixen
