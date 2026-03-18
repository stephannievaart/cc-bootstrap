---
name: git-worktree-cleanup
description: Ruimt worktrees op van gemerged branches. Toont overzicht, vraagt bevestiging, verwijdert veilig.
user-invocable: true
---

# Git Worktree Cleanup

Je ruimt worktrees op die niet meer nodig zijn — branches die al gemerged zijn naar main.

---

## Huidige situatie

- **Repo:** !`basename "$(git rev-parse --show-toplevel)"`
- **Branch:** !`git branch --show-current`
- **Worktrees:** !`git worktree list`
- **Gemerged branches:** !`git branch --merged main`

---

## Stap 1 — Overzicht tonen

Combineer de worktree lijst met de gemerged branches:
- Toon alle worktrees met hun branch
- Markeer welke worktrees bij een gemerged branch horen — dit zijn kandidaten voor cleanup
- Toon welke worktrees NIET in aanmerking komen (niet gemerged, of de hoofdworktree)

---

## Stap 2 — Bevestiging vragen

Toon de lijst van te verwijderen worktrees aan de gebruiker:

```
De volgende worktrees zijn kandidaat voor cleanup:
- /pad/naar/worktree (branch: feature/xyz) — gemerged in main
- /pad/naar/worktree (branch: bug/abc) — gemerged in main

Wil je deze verwijderen? (ja/nee)
```

**Wacht op expliciete bevestiging** — nooit automatisch verwijderen.

---

## Stap 3 — Cleanup uitvoeren

Voor elke bevestigde worktree:

```bash
git worktree remove [pad]
```

Als een worktree uncommitted changes heeft: sla deze over en meld dit aan de gebruiker.

Daarna altijd:

```bash
git worktree prune
```

---

## Stap 4 — Rapporteer resultaat

- Toon welke worktrees succesvol verwijderd zijn
- Toon welke worktrees overgeslagen zijn (met reden)
- Toon de huidige `git worktree list` na cleanup

---

## Regels

- Verwijder NOOIT de hoofdworktree (main checkout)
- Verwijder NOOIT een worktree met uncommitted changes — meld dit en sla over
- Draai ALTIJD `git worktree prune` na cleanup
- Vraag ALTIJD bevestiging voor verwijdering — nooit automatisch
- Als er geen kandidaten zijn: meld dit en stop
