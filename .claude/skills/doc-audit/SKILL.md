---
name: doc-audit
description: Periodieke audit van het kennissysteem — los van het taakproces. Voert systeem-checks uit (CLAUDE.md, verwijzingen, drift, verouderde docs) plus brede checks die doc-review niet doet (architecture vs. codebase, ADR status, cross-task patronen).
user-invocable: true
---

# Doc Audit — Periodieke kennissysteem check

Een standalone audit die je draait los van het taakproces. Gebruik dit na meerdere afgeronde taken, of wanneer je twijfelt of het kennissysteem nog klopt.

**Verschil met /doc-review:** doc-review draait per taak (Stap 7) en focust op lessons learned van die taak. Doc-audit kijkt breed naar het hele systeem zonder taakcontext, en voert de volledige systeem-checks uit waarvan doc-review alleen een checklist gebruikt.

---

## Wanneer draai je dit

- Na elke 5 afgeronde taken (vuistregel)
- Wanneer de gebruiker /doc-audit aanroept
- Na een grote refactoring of architectuurwijziging
- Bij onboarding van een nieuw teamlid (verificatie dat docs kloppen)

---

## Wat je controleert

### 1. Architecture docs vs. codebase

Vergelijk de documentatie in /docs/architecture/ met de actuele codebase:
- Mappenstructuur — komen de beschreven modules/packages overeen met wat er daadwerkelijk bestaat?
- Dependencies — kloppen de beschreven dependencies met package.json, pom.xml, requirements.txt, of equivalent?
- Componenten — bestaan alle beschreven componenten nog? Zijn er nieuwe componenten die niet gedocumenteerd zijn?
- Integraties — kloppen de beschreven externe integraties nog?

Rapporteer afwijkingen met concrete voorstellen.

### 2. ADR status review

Loop alle ADRs in /docs/decisions/ na:
- Zijn er ADRs met status accepted die feitelijk al superseded zijn door latere beslissingen?
- Zijn er ADRs die verwijzen naar componenten of patronen die niet meer bestaan?
- Zijn er architectuurbeslissingen in de code die geen ADR hebben maar er wel een verdienen?
- Is de nummering consistent en zonder gaten?

### 3. Cross-task patronen (retrospectief)

Lees alle afgeronde task docs (uit /docs/work/*/done/) sinds de laatste audit:
- Terugkerende problemen of beslissingen
- Patronen die in de praktijk ontstaan zijn maar niet vastgelegd
- Herhaalde review bevindingen die op structurele problemen wijzen
- Onverwerkte lessons learned die gemist zijn door de per-taak doc-reviewer

### 4. Systeem-checks

Voer onderstaande checks uit op het volledige kennissysteem. Doc-review gebruikt een verkorte versie van deze checks per taak — hier voer je ze breed en grondig uit.

#### 4a. CLAUDE.md gezondheidscheck
- Onder ~100 regels?
- Alleen harde regels en pointers?
- Alle verwijzingen geldig (bestanden bestaan)?
- Geen content die naar specialist docs hoort?

Als CLAUDE.md te groot is: identificeer wat eruit moet en stel voor waar het naartoe moet. Rapporteer als HIGH.

#### 4b. Verwijzingen valideren
Controleer alle verwijzingen in:
- Agent .md bestanden in .claude/agents/
- Skill SKILL.md bestanden in .claude/skills/
- CLAUDE.md

Per verwijzing: bestaat het bestand? Is het pad correct?
Kapotte verwijzingen zijn CRITICAL — ze leiden tot context fouten bij agents.

#### 4c. Drift-detectie: skills en agents vs. rules
Vergelijk de instructies in skill SKILL.md bestanden en agent .md bestanden met de actuele rules in .claude/rules/:
- Beschrijft een skill of agent een patroon dat conflicteert met een rule? -> WARN
- Verwijst een skill of agent naar een werkwijze die niet meer geldt? -> HIGH
- Ontbreekt er een regel in een skill/agent die WEL in de rules staat en relevant is? -> INFO

#### 4d. Verouderde en wees-docs
- Docs in /docs/ die spreken over componenten die niet meer bestaan
- Docs die nergens naar verwezen worden
- ADRs die superseded zijn maar nog accepted als status hebben
- README index bestanden die niet meer kloppen
- Lege directories die opgeruimd kunnen worden

Markeer verouderde docs als archived of superseded met datum en verwijzing naar opvolger.

#### 4e. README's bijwerken
- /docs/README.md — klopt de docs index nog? Nieuwe docs die ontbreken? Verwijderde docs die er nog in staan?
- /docs/decisions/README.md — klopt het ADR overzicht?
- /docs/architecture/README.md — kloppen de laatste update datums?

---

## Rapport schrijven

Schrijf het rapport naar /docs/audits/audit-[datum].md:

```markdown
# Kennissysteem Audit — [datum]

## Samenvatting
[1-2 zinnen: algehele gezondheid van het kennissysteem]

## Bevindingen

| # | Severity | Categorie | Bevinding | Actie |
|---|----------|-----------|-----------|-------|
| 1 | [CRITICAL/HIGH/WARN/INFO] | [categorie] | [beschrijving] | [FIXED/TODO] |

## Architecture docs vs. codebase
- [afwijkingen of "in sync"]

## ADR status
- [problemen of "alle ADRs actueel"]

## Cross-task patronen
- [patronen of "geen patronen gevonden"]

## Systeem-checks
- [bevindingen per check, of "geen bevindingen"]

## Acties genomen
- [lijst van directe fixes die zijn doorgevoerd]

## Aanbevelingen
- [suggesties die gebruikersbeslissing vereisen]
```

---

## Severity classificatie

| Severity | Criteria |
|----------|----------|
| CRITICAL | Kapotte verwijzingen, ontbrekende bestanden, foute instructies in agents/skills |
| HIGH | CLAUDE.md te groot, verouderde docs niet gemarkeerd, drift die gedrag beinvloedt |
| WARN | Structuur afwijkingen, naamgeving niet consistent |
| INFO | Suggesties voor verbetering, kleine optimalisaties |

---

## Regels

- Je MAG docs, skills, en agent prompts aanpassen voor duidelijke correcties (broken refs, verouderde info)
- Structurele wijzigingen (nieuwe ADRs, grote herschrijvingen) -> rapporteer als aanbeveling, niet direct doorvoeren
- Maak de /docs/audits/ directory aan als die nog niet bestaat
- Verwijs naar de vorige audit als die er is, zodat trends zichtbaar worden
