# Skills Index

## Overzicht

| Naam | Aanroepbaar door gebruiker | Doel | Roept aan |
|------|---------------------------|------|-----------|
| abandon-task | ja | Abandon een vastgelopen taak — markeert als abandoned, ruimt branch en worktree op. | — |
| capture-bug | ja | Vangt bugs op met P1–P4 severity classificatie en parkeert ze in docs/work/bugs/. | git-capture |
| capture-chore | ja | Registreert technische chores, bepaalt grootte (klein=direct, groot=via pipeline) en parkeert grote chores in docs/work/chores/. | git-capture |
| doc-audit | ja | Periodieke audit van het volledige kennissysteem — architecture vs. codebase, ADR status, cross-task patronen, systeem-checks. | — |
| doc-review | ja | Stap 7 — verwerkt lessons learned van de afgeronde taak en voert compacte systeem-checks uit. | — |
| feature-builder | nee | Bewaakt het bouwproces voor developer agents — vindt task doc, detecteert scope creep, checkt acceptatiecriteria. | — |
| feature-planner | ja | Toont backlog status en helpt bij prioritering van features, bugs en chores. | — |
| git-capture | nee | Interne git logica: WIP commit, checkout main, doc schrijven, branch aanmaken, push, worktree aanmaken, terug naar vorige branch. | — |
| git-switch-feature | ja | Veilig wisselen tussen taken met WIP commit en worktree-detectie. | — |
| git-workflow | nee | Git conventies voor developer agents: branch strategie, commit formats, WIP regels, PR proces, worktree regels. | — |
| git-worktree | ja | Centrale worktree kennis — aanmaken, beheren, naming conventie, symlinks voor CLAUDE.md en .claude/. | — |
| git-worktree-cleanup | ja | Ruimt worktrees op van gemerged branches na bevestiging. | — |
| new-feature | ja | Definieert een nieuwe feature via een gestructureerd interview en maakt een feature doc + branch aan. | git-capture |
| new-project | ja | Bootstrap interview voor een nieuw project — genereert CLAUDE.md, ADR-001, configureert agents en rules. | — |
| post-merge | ja | Afronding na een gemerged PR — verplaatst task doc naar done, verwijdert branch, ruimt worktree op. | — |
| quick-fix | ja | Lichtgewicht pad voor triviale wijzigingen (typo's, config) — direct commit, geen task doc. | — |
| start-work | ja | Orkestreert het volledige werkproces: planning → API design → tests → implementatie → review → PR. | doc-review |
| status | ja | Toont een compleet overzicht van de projectstatus — in-progress, backlog, bugs per severity, worktrees. | — |

**Noot bij "Roept aan":** Alleen directe skill-aanroepen zijn vermeld. start-work roept daarnaast diverse agents aan (architect, api-design, test-automation, developers, documentation, doc-reviewer, reviewers) die op hun beurt feature-builder en git-workflow laden.

---

## Skill-ketens

De skills vormen samen een end-to-end workflow van idee tot opgeruimde branch. Hieronder de volledige flow.

### Hoofdflow: Capture → Start → Build → Merge → Cleanup

```
 ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
 │ new-feature  │    │ capture-bug  │    │capture-chore│
 │ (interview)  │    │ (interview)  │    │ (interview)  │
 └──────┬───────┘    └──────┬───────┘    └──────┬───────┘
        │                   │                   │
        └───────────┬───────┘───────────────────┘
                    ▼
             ┌──────────────┐
             │  git-capture  │  WIP commit → main → doc schrijven
             │  (intern)     │  → branch → push → worktree → terug
             └──────┬───────┘
                    ▼
           docs/work/ + branch + worktree klaar
                    │
                    ▼
          ┌──────────────────┐
          │  feature-planner  │  Prioriteer backlog → kies volgende taak
          └──────────┬───────┘
                     ▼
            ┌────────────────┐
            │   start-work    │  Orkestreert 8 stappen:
            │                 │
            │  Stap 1: architect (planning)
            │  Stap 1b: api-design (conditioneel)
            │  Stap 2: test-automation (scenarios)
            │  Stap 3: test-automation (rode tests)
            │  Stap 4: developers + feature-builder + git-workflow
            │  Stap 5: tests draaien + refactor
            │  Stap 6: documentation agent
            │  Stap 7: reviewers + doc-review
            │  Stap 8: PR creation
            └────────┬───────┘
                     ▼
            ┌────────────────┐
            │   post-merge    │  Task doc → done/, branch delete,
            │                 │  worktree cleanup, pull main
            └────────────────┘
```

### Ondersteunende skills (parallel beschikbaar)

| Skill | Wanneer | Relatie tot hoofdflow |
|-------|---------|---------------------|
| abandon-task | Vastgelopen taak abandonen — branch, worktree, doc opruimen | Alternatief einde — taak wordt abandoned i.p.v. gemerged |
| quick-fix | Triviale wijzigingen die het volledige proces niet rechtvaardigen | Bypass — geen task doc, geen agents |
| status | Op elk moment — projectoverzicht | Informatief — geen wijzigingen |
| git-switch-feature | Tijdens werk — wisselen naar andere taak | WIP commit + checkout of worktree-verwijzing |
| git-worktree | Parallelle sessies opzetten | Wordt ook door git-capture aangemaakt |
| git-worktree-cleanup | Na post-merge of periodiek | Ruimt verlopen worktrees op |
| doc-audit | Periodiek (elke ~5 taken) of op aanvraag | Brede kennissysteem-check, los van taakflow |
| new-project | Eenmalig bij project bootstrap | Zet de volledige structuur op (CLAUDE.md, agents, rules, ADR-001) |

### Impliciete skill-lading door agents

De developer agents (backend-developer, frontend-developer, ui-designer) laden automatisch twee skills wanneer ze door start-work worden aangeroepen:
- **feature-builder** — scope bewaking, task doc lezen, acceptatiecriteria checken
- **git-workflow** — commit conventies, branch regels, PR checklist

De documentation agent laadt **git-workflow** voor commit conventies.
