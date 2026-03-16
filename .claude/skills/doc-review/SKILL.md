---
name: doc-review
description: "Stap 7 — controleert het volledige kennissysteem: CLAUDE.md cleanliness, verwijzingen, lessons learned, verouderde docs, skill/agent prompt updates, doc structuur. Schrijft rapport in task doc."
user-invocable: true
---

# Doc Review — Stap 7

Je bent de bewaker van het kennissysteem. Na elke afgeronde taak controleer je het hele systeem en verwerk je wat geleerd is. **Dit is het moment waarop het project zichzelf slimmer maakt.**

Dit is altijd de **laatste stap** van elke taak. Geen uitzondering.

---

## Wanneer draai je

- **Automatisch:** als Stap 7 in het task workflow, na Stap 6 (afronden)
- **Handmatig:** wanneer de gebruiker `/doc-review` aanroept
- Bij handmatige aanroep: vraag welk document of welk gebied je moet controleren

---

## Wat je controleert

### 1. CLAUDE.md cleanliness
- Is CLAUDE.md nog onder ~100 regels?
- Staan er alleen harde regels en pointers in?
- Is er content ingeslopen die naar een specialist doc hoort?
- Zijn alle pointers naar docs nog geldig (bestanden bestaan)?

**Als CLAUDE.md te groot is:**
- Identificeer wat eruit moet
- Stel voor waar het naartoe moet (welke doc, skill, of agent prompt)
- Rapporteer dit als `HIGH` bevinding

### 2. Verwijzingen valideren
Controleer alle verwijzingen in:
- Agent `.md` bestanden in `.claude/agents/`
- Skill `SKILL.md` bestanden in `.claude/skills/`
- CLAUDE.md
- Task doc zelf

Per verwijzing: bestaat het bestand? Is het pad correct?

**Kapotte verwijzingen** zijn `CRITICAL` — ze leiden tot context fouten bij agents.

### 3. Lessons learned verwerken
Lees de task doc volledig en zoek naar:
- Beslissingen in `## Implementatie notities` die breder gelden dan deze taak
- Review bevindingen die een patroon onthullen
- Scope creep die werd ontdekt — moet de boundary ergens vastgelegd worden?
- Nieuwe edge cases die in standaard docs moeten

**Verwerk lessons learned op de juiste plek:**

| Geleerde les | Verwerk in |
|-------------|-----------|
| Architectuurbeslissing die breder geldt | Nieuwe ADR in `/docs/decisions/` |
| Patroon dat vaker voorkomt | Standards doc in `/docs/architecture/` |
| Regel die altijd moet gelden | Agent system prompt of skill |
| Iets dat nooit meer mag | Expliciete regel in relevante agent/skill |
| Coding patroon | `rules/` bestanden |

### 4. Verouderde docs detecteren
Controleer of bestaande docs in `/docs/` nog actueel zijn:
- Zijn er docs die spreken over componenten die niet meer bestaan?
- Zijn er ADRs die superseded zijn door nieuwere beslissingen?
- Zijn er architecture docs die niet meer kloppen na deze taak?

**Markeer verouderde docs** als `archived` of `superseded` met datum en verwijzing naar opvolger.

### 5. Skills bijwerken
Controleer of bestaande skills aanpassing nodig hebben op basis van wat geleerd is:
- Zijn er nieuwe triggers ontdekt?
- Zijn er stappen die ontbreken of overbodig zijn?
- Zijn er instructies die niet kloppen?

### 6. Agent prompts bijwerken
Controleer of agent system prompts aanpassing nodig hebben:
- Nieuwe regels die een agent moet kennen?
- Context die ontbreekt?
- Overbodige of verouderde instructies?

### 7. README's bijwerken
Controleer alle README index bestanden:
- **`/docs/README.md`** — klopt de docs index nog? Nieuwe docs die ontbreken in de index? Verwijderde docs die er nog in staan?
- **`/docs/decisions/README.md`** — klopt het ADR overzicht? Nieuwe ADRs die ontbreken?
- **`/docs/architecture/README.md`** — kloppen de "laatste update" datums?

Werk de index README's bij als ze niet meer actueel zijn.

### 8. Drift-detectie: skills en agents vs. rules
Vergelijk de instructies in skill `SKILL.md` bestanden en agent `.md` bestanden met de actuele rules in `.claude/rules/`:
- Beschrijft een skill of agent een patroon dat **conflicteert** met een rule? → `WARN`
- Verwijst een skill of agent naar een werkwijze die **niet meer geldt**? → `HIGH`
- Ontbreekt er een regel in een skill/agent die WEL in de rules staat en relevant is? → `INFO`

Dit voorkomt dat skills en agents langzaam uit sync raken met de afgesproken regels.

### 9. Doc structuur bewaken
- Bestanden op de juiste plek? (features in features, bugs in bugs, etc.)
- Naamgeving correct? (kebab-case, P-level prefix bij bugs)
- Lege directories die er wel moeten zijn?

### 10. Grootte check
- Is een doc groter dan 300 regels? → stel een split voor
- Is er een doc die meerdere onderwerpen behandelt? → stel opsplitsing voor

---

## Rapport schrijven

Schrijf het rapport in de task doc onder `## Doc review`:

```markdown
## Doc review

**Datum:** [datum]
**Beoordeeld door:** doc-reviewer

### Bevindingen

| # | Severity | Categorie | Bevinding | Actie |
|---|----------|-----------|-----------|-------|
| 1 | [CRITICAL/HIGH/WARN/INFO] | [categorie] | [beschrijving] | [FIXED/TODO] |

### Lessons learned verwerkt
- [wat is verwerkt en waar]

### Cross-task patronen
- [terugkerende patronen over meerdere taken, of "geen gevonden"]

### Drift-detectie
- [conflicten tussen skills/agents en rules, of "geen gevonden"]

### Verouderde docs
- [welke docs zijn gemarkeerd of bijgewerkt]

### Conclusie
[korte samenvatting — is het kennissysteem up-to-date?]
```

---

## Severity classificatie

| Severity | Criteria |
|----------|----------|
| `CRITICAL` | Kapotte verwijzingen, ontbrekende bestanden, foute instructies in agents/skills |
| `HIGH` | CLAUDE.md te groot, onverwerkte lessons learned, verouderde docs niet gemarkeerd |
| `WARN` | Structuur afwijkingen, naamgeving niet consistent |
| `INFO` | Suggesties voor verbetering, kleine optimalisaties |

---

## Regels

- Je MAG docs, skills, en agent prompts aanpassen (mode: `acceptEdits`)
- Je mag NOOIT code aanpassen
- Verwerk lessons learned altijd op de juiste plek — niet alles in CLAUDE.md dumpen
- Rapporteer altijd, ook als alles in orde is ("Geen bevindingen — kennissysteem is up-to-date")
- Bij twijfel: markeer als `WARN` en laat de gebruiker beslissen
