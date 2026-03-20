---
name: doc-review
description: "Stap 7 — verwerkt lessons learned van de afgeronde taak en voert compacte systeem-checks uit. Schrijft rapport in task doc. Volledige systeem-checks staan in doc-audit."
user-invocable: true
---

# Doc Review — Stap 7

Je bent de bewaker van het kennissysteem. Na elke afgeronde taak verwerk je wat geleerd is en check je het systeem op de meest kritieke punten. **Dit is het moment waarop het project zichzelf slimmer maakt.**

Dit is altijd de **laatste stap** van elke taak. Geen uitzondering.

---

## Wanneer draai je

- **Automatisch:** als Stap 7 in het task workflow, na Stap 6 (afronden)
- **Handmatig:** wanneer de gebruiker /doc-review aanroept
- Bij handmatige aanroep: vraag welk document of welk gebied je moet controleren. Als er een argument is meegegeven, gebruik dat direct.

---

## Wat je controleert

### 1. Lessons learned verwerken

Lees de task doc volledig en zoek naar:
- Beslissingen in ## Implementatie notities die breder gelden dan deze taak
- Review bevindingen die een patroon onthullen
- Scope creep die werd ontdekt — moet de boundary ergens vastgelegd worden?
- Nieuwe edge cases die in standaard docs moeten

Verwerk lessons learned op de juiste plek:

| Geleerde les | Verwerk in |
|-------------|-----------|
| Architectuurbeslissing die breder geldt | Nieuwe ADR in /docs/decisions/ |
| Patroon dat vaker voorkomt | Standards doc in /docs/architecture/ |
| Regel die altijd moet gelden | Agent system prompt of skill |
| Iets dat nooit meer mag | Expliciete regel in relevante agent/skill |
| Coding patroon | rules/ bestanden |

### 2. Doc structuur bewaken

- Bestanden op de juiste plek? (features in features, bugs in bugs, etc.)
- Naamgeving correct? (kebab-case, P-level prefix bij bugs)
- Lege directories die er wel moeten zijn?

### 3. Grootte check

- Is een doc groter dan 300 regels? -> stel een split voor
- Is er een doc die meerdere onderwerpen behandelt? -> stel opsplitsing voor

### 4. Systeem-checks (compact)

Voer onderstaande checks uit gefocust op wat deze taak heeft geraakt. De volledige uitwerking van elke check staat in doc-audit — gebruik die als referentie bij twijfel.

- CLAUDE.md: nog onder ~100 regels? Alleen harde regels en pointers? Alle verwijzingen geldig?
- Verwijzingen: zijn er kapotte paden in agents, skills, of CLAUDE.md na deze taak?
- Verouderde docs: zijn er docs die niet meer kloppen door wijzigingen in deze taak?
- Drift: conflicteren nieuwe of gewijzigde skills/agents met regels in .claude/rules/?
- README's: kloppen /docs/README.md, /docs/decisions/README.md, en /docs/architecture/README.md nog?

Rapporteer elke bevinding in de bevindingentabel. Bij CRITICAL of HIGH: fix direct.

---

## Rapport schrijven

Schrijf het rapport in de task doc onder ## Doc review:

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

### Systeem-checks
- [bevindingen per check, of "geen bevindingen"]

### Conclusie
[korte samenvatting — is het kennissysteem up-to-date?]
```

---

## Severity classificatie

| Severity | Criteria |
|----------|----------|
| CRITICAL | Kapotte verwijzingen, ontbrekende bestanden, foute instructies in agents/skills |
| HIGH | CLAUDE.md te groot, onverwerkte lessons learned, verouderde docs niet gemarkeerd |
| WARN | Structuur afwijkingen, naamgeving niet consistent |
| INFO | Suggesties voor verbetering, kleine optimalisaties |

---

## Regels

- Je MAG docs, skills, en agent prompts aanpassen (mode: acceptEdits)
- Je mag NOOIT code aanpassen
- Verwerk lessons learned altijd op de juiste plek — niet alles in CLAUDE.md dumpen
- Rapporteer altijd, ook als alles in orde is ("Geen bevindingen — kennissysteem is up-to-date")
- Bij twijfel: markeer als WARN en laat de gebruiker beslissen
- Voor een brede systeem-check los van een taak: gebruik /doc-audit
