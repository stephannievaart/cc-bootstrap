# Ronde 4 — User/Agent Toepasbaarheid Rapport

## Bevindingentabel

| # | Skill | Bevinding | Type | Actie |
|---|-------|-----------|------|-------|
| 1 | capture-bug | Interview (3 vragen) begint zonder fallback als info al beschikbaar is in het argument | Geen user-fallback | **FIXED** — Agent-fallback blok toegevoegd boven interviewsectie |
| 2 | capture-chore | "Vraag de gebruiker" in Stap 1 zonder fallback voor agent-context | Geen user-fallback | **FIXED** — Agent-fallback blok toegevoegd boven Stap 1 |
| 3 | capture-chore | Grootte-bepaling (klein vs. groot) vereist deels subjectieve inschatting ("risico op regressie") | Subjectieve beoordeling | **TWIJFEL** — Criteria zijn redelijk objectief (patch version, dead code, etc.) maar de grensgevallen vereisen menselijk oordeel. Niet gewijzigd. |
| 4 | new-feature | Interview (4 groepen, 12 vragen) zonder fallback als info al beschikbaar is | Geen user-fallback | **FIXED** — Agent-fallback blok toegevoegd boven interviewsectie |
| 5 | new-project | Volledig interactief interview (22 vragen, 5 groepen). Kan niet zonder gebruiker. | Inherent interactief | **TWIJFEL** — Bewust ontwerp: user-invocable: true en bootstrapping vereist per definitie menselijke input over stack en requirements. Niet gewijzigd. |
| 6 | quick-fix | "Vraag de gebruiker" in Stap 2 zonder fallback | Geen user-fallback | **FIXED** — Agent-fallback blok toegevoegd |
| 7 | quick-fix | "Laat de gebruiker de fix zelf uitvoeren, of voer het samen uit" — onduidelijk voor agent | Onduidelijke instructie | **FIXED** — Herschreven: agent voert fix direct uit |
| 8 | git-switch-feature | "Vraag de gebruiker kort: Wat is de huidige staat" voor WIP message — blokkeert agent | Geen user-fallback | **FIXED** — Fallback: genereer WIP message op basis van `git diff --stat` |
| 9 | git-switch-feature | "Vraag de gebruiker: Naar welke taak wil je switchen?" zonder argument-check | Geen user-fallback | **FIXED** — Argument-check: gebruik meegegeven argument als doel |
| 10 | git-worktree-cleanup | "Wacht op expliciete bevestiging — nooit automatisch verwijderen" — blokkeert agent | Geen user-fallback | **TWIJFEL** — Bewuste veiligheidsmaatregel voor destructieve operatie. user-invocable: true. Niet gewijzigd. |
| 11 | start-work | "/clear herinnering" stap blokkeert met "Wacht op bevestiging" — irrelevant in agent-context | Onduidelijke trigger | **FIXED** — Agent-context skip blok toegevoegd |
| 12 | start-work | "toon opties en laat kiezen" als geen taaknaam — blokkeert agent | Geen user-fallback | **FIXED** — Agent stopt met fout "Geen taaknaam meegegeven" |
| 13 | post-merge | "Laat de gebruiker kiezen" zonder argument — blokkeert agent | Geen user-fallback | **FIXED** — Fallback: bij 1 kandidaat automatisch, bij meerdere stop met fout |
| 14 | doc-review | "vraag welk document" bij handmatige aanroep — geen argument-check | Geen user-fallback | **FIXED** — Argument-check toegevoegd |
| 15 | doc-audit | "Na een grote refactoring" als trigger is subjectief | Subjectieve trigger | **TWIJFEL** — Trigger is bewust breed. Agent kan dit triggeren na significante changes in codebase. Niet gewijzigd. |
| 16 | feature-builder | Geen bevindingen — alle stappen zijn machine-verifieerbaar (branch matching, grep, doc lezen) | OK | Geen actie nodig |
| 17 | git-capture | Geen bevindingen — interne skill, volledig geautomatiseerd, geen user-interactie | OK | Geen actie nodig |
| 18 | git-workflow | Geen bevindingen — conventie-document voor agents, geen interactie | OK | Geen actie nodig |
| 19 | git-worktree | Geen bevindingen — commando's zijn concreet en objectief | OK | Geen actie nodig |
| 20 | feature-planner | "Laat de gebruiker beslissen" — bewust interactief advies-skill | OK (user-invocable) | Geen actie nodig |
| 21 | status | Geen bevindingen — puur data-ophaal, geen user-interactie vereist | OK | Geen actie nodig |

## Samenvatting

- **10 eenduidige fixes doorgevoerd** (bevindingen 1, 2, 4, 6, 7, 8, 9, 11, 12, 13, 14)
- **4 twijfelgevallen gerapporteerd, niet gewijzigd** (bevindingen 3, 5, 10, 15)
- **7 skills zonder bevindingen** (feature-builder, git-capture, git-workflow, git-worktree, feature-planner, status, doc-audit)

## Patroon van de fixes

Alle fixes volgen hetzelfde patroon: een `> **Agent-fallback:**` of `> **Agent-context:**` blok dat de instructie uitbreidt met een machine-uitvoerbaar alternatief. Dit laat de originele user-instructie intact voor interactief gebruik en voegt een expliciet pad toe voor wanneer de skill door een agent wordt geladen.
