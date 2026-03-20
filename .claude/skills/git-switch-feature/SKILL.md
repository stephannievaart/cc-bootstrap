---
name: git-switch-feature
description: Veilig wisselen tussen taken. Beoordeelt git status, maakt WIP commit, schakelt over naar andere branch, adviseert /clear voor schone sessie.
argument-hint: "[branch naam of taaknaam]"
user-invocable: true
---

# Git Switch Feature — Veilig Context Wisselen

Je helpt de gebruiker veilig te wisselen van de huidige taak naar een andere. Niets gaat verloren, alles wordt netjes geparkeerd.

---

## Huidige situatie

- **Branch:** !`git branch --show-current`
- **Status:** !`git status --short`
- **Worktrees:** !`git worktree list`

---

## Stap 1 — Huidige status beoordelen

Gebruik de informatie hierboven om te beoordelen:
- **Uncommitted changes?** — er zijn wijzigingen die nog niet gecommit zijn
- **Staged changes?** — er zijn wijzigingen die staged zijn maar niet gecommit
- **Clean working tree?** — alles is gecommit

### Huidige taak identificeren
- Zoek welk document met `status: in-progress` in `docs/work/` hoort bij de huidige branch
- Toon de titel en status aan de gebruiker

---

## Stap 2 — Huidig werk veiligstellen

### Bij uncommitted/staged changes
Maak automatisch een WIP commit:

```bash
git add -A
git commit -m "WIP: [beschrijving van huidige staat]"
```

De WIP beschrijving moet informatief zijn:
- Goed: `WIP: product card layout klaar, prijslogica nog niet gestart`
- Fout: `WIP: work in progress`

**Vraag de gebruiker kort:** "Wat is de huidige staat van je werk?" — gebruik dit voor het WIP message.
Als er geen gebruiker beschikbaar is of het antwoord uitblijft: genereer het WIP message op basis van `git diff --stat` (gewijzigde bestanden en hun aard).

### Bij clean working tree
Meld: "Geen uncommitted changes — alles is al veilig."

### Push naar remote
```bash
git push origin [huidige-branch]
```

---

## Stap 3 — Doel bepalen

Als de gebruiker een argument heeft meegegeven (branch naam of taaknaam): gebruik dat direct als doel. Vraag alleen als er geen argument is:
"Naar welke taak wil je switchen?"

### Optie A — Naar een bestaande taak
- Zoek het document in `docs/work/features/`, `docs/work/bugs/`, of `docs/work/chores/`
- Lees de branch naam uit de doc
- Check of er een worktree bestaat voor deze branch (`git worktree list`)
- **Als er een worktree bestaat:** verwijs naar die worktree — doe GEEN checkout
- **Als er geen worktree bestaat:** bied twee opties aan:
  1. Maak een worktree aan via `/git-worktree` (aanbevolen voor parallel werk)
  2. Switch in huidige repo met WIP commit (voor sequentieel werk)

### Optie B — Naar main
- Gewoon `git checkout main && git pull`
- Geen task doc nodig

### Optie C — Gebruiker weet het niet
- Verwijs naar `/feature-planner` om te kiezen

---

## Stap 4 — Overschakelen

### Als er een worktree bestaat voor de doelbranch
```
Meld: "Er bestaat al een worktree voor deze branch: [pad]. Open daar een nieuwe Claude Code sessie."
```
**Doe GEEN checkout** — gebruik de worktree.

### Als er geen worktree bestaat — en gebruiker kiest voor switch in huidige repo
```bash
git checkout [doel-branch]
git pull origin [doel-branch]
```

### Als er geen worktree bestaat — en gebruiker kiest voor worktree
Verwijs naar `/git-worktree` om een worktree aan te maken voor de doelbranch. Dit is de aanbevolen aanpak als de gebruiker parallel aan meerdere taken wil werken.

### Task doc status
- Als het een nieuw op te pakken taak is: wijzig frontmatter naar `status: in-progress` (via start-work logica)
- Als het een taak is waar je aan terugkeert: doc heeft al `status: in-progress`

---

## Stap 5 — Schone sessie adviseren

Meld aan de gebruiker:

> "Je bent nu op branch `[doel-branch]`. Doe `/clear` voor een schone sessie met de juiste context."

**Dit is essentieel** — de vorige context (andere feature, andere code) zit nog in het context window. Een schone sessie voorkomt verwarring.

---

## Regels

- Maak ALTIJD een WIP commit bij uncommitted changes — vraag niet of het moet
- Vraag WEL wat de huidige staat is voor een informatief WIP message
- Doe NOOIT `git checkout` als er een worktree bestaat voor de doelbranch
- Adviseer ALTIJD `/clear` na de switch
- Verlies NOOIT werk — alles moet gecommit en gepusht zijn voor de switch
- WIP commits worden later gesquashed of geamend voor de PR — dat is normaal
