---
name: doc-audit
description: Periodieke audit van het kennissysteem — los van het taakproces. Checkt architecture docs vs. codebase, ADR status, skill/agent drift, en verouderde docs.
user-invocable: true
---

# Doc Audit — Periodieke kennissysteem check

Een standalone audit die je draait los van het taakproces. Gebruik dit na meerdere afgeronde taken, of wanneer je twijfelt of het kennissysteem nog klopt.

**Verschil met `/doc-review`:** doc-review draait per taak (Stap 7) en focust op lessons learned van die taak. Doc-audit kijkt breed naar het hele systeem zonder taakcontext.

---

## Wanneer draai je dit

- Na elke 5 afgeronde taken (vuistregel)
- Wanneer de gebruiker `/doc-audit` aanroept
- Na een grote refactoring of architectuurwijziging
- Bij onboarding van een nieuw teamlid (verificatie dat docs kloppen)

---

## Wat je controleert

### 1. Architecture docs vs. codebase

Vergelijk de documentatie in `/docs/architecture/` met de actuele codebase:
- **Mappenstructuur** — komen de beschreven modules/packages overeen met wat er daadwerkelijk bestaat?
- **Dependencies** — kloppen de beschreven dependencies met `package.json`, `pom.xml`, `requirements.txt`, of equivalent?
- **Componenten** — bestaan alle beschreven componenten nog? Zijn er nieuwe componenten die niet gedocumenteerd zijn?
- **Integraties** — kloppen de beschreven externe integraties nog?

Rapporteer afwijkingen met concrete voorstellen.

### 2. ADR status review

Loop alle ADRs in `/docs/decisions/` na:
- Zijn er ADRs met status `accepted` die feitelijk al **superseded** zijn door latere beslissingen?
- Zijn er ADRs die verwijzen naar componenten of patronen die niet meer bestaan?
- Zijn er architectuurbeslissingen in de code die **geen** ADR hebben maar er wel een verdienen?
- Is de nummering consistent en zonder gaten?

### 3. Skills en agents vs. werkelijkheid

Voor elke skill in `.claude/skills/*/SKILL.md` en elke agent in `.claude/agents/*.md`:
- **Referenties** — bestaan alle gerefereerde bestanden?
- **Instructies** — kloppen de beschreven stappen nog met het actuele workflow?
- **Rules alignment** — conflicteren instructies met rules in `.claude/rules/`?
- **Verouderde context** — verwijzen ze naar tools, frameworks, of patronen die niet meer gebruikt worden?

### 4. CLAUDE.md gezondheidscheck

- Onder ~100 regels?
- Alleen harde regels en pointers?
- Alle verwijzingen geldig?
- Geen content die naar specialist docs hoort?

### 5. Verouderde en wees-docs

- Docs in `/docs/` die nergens naar verwezen worden
- Docs die spreken over componenten die niet meer bestaan
- README index bestanden die niet meer kloppen
- Lege directories die opgeruimd kunnen worden

### 6. Cross-task patronen (retrospectief)

Lees alle afgeronde task docs (uit `/docs/work/*/done/`) sinds de laatste audit:
- Terugkerende problemen of beslissingen
- Patronen die in de praktijk ontstaan zijn maar niet vastgelegd
- Herhaalde review bevindingen die op structurele problemen wijzen
- Onverwerkte lessons learned die gemist zijn door de per-taak doc-reviewer

---

## Rapport schrijven

Schrijf het rapport naar `/docs/audits/audit-[datum].md`:

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

## Skill/agent drift
- [conflicten of "geen drift gevonden"]

## Cross-task patronen
- [patronen of "geen patronen gevonden"]

## Acties genomen
- [lijst van directe fixes die zijn doorgevoerd]

## Aanbevelingen
- [suggesties die gebruikersbeslissing vereisen]
```

---

## Regels

- Je MAG docs, skills, en agent prompts aanpassen voor duidelijke correcties (broken refs, verouderde info)
- Structurele wijzigingen (nieuwe ADRs, grote herschrijvingen) → rapporteer als aanbeveling, niet direct doorvoeren
- Maak de `/docs/audits/` directory aan als die nog niet bestaat
- Verwijs naar de vorige audit als die er is, zodat trends zichtbaar worden
