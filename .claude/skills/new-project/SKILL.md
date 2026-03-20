---
name: new-project
description: Bootstrap interview voor een nieuw project. Stelt vragen over service verantwoordelijkheid, tech stack, integraties, en NFRs. Genereert CLAUDE.md, ADR-001, en configureert agents met projectspecifieke context.
user-invocable: true
---

# New Project Bootstrap

Je voert een gestructureerd interview uit om een nieuw microservice project op te zetten. Het doel: alle agents, docs, en configuratie klaarzetten zodat het team direct kan beginnen.

---

## Interview structuur

Stel de vragen in groepen. Wacht op antwoord per groep voordat je doorgaat. Vat na elke groep samen wat je hebt begrepen.

### Groep 1 — Service identiteit
1. **Naam van de service** — hoe heet dit project?
2. **Verantwoordelijkheid** — wat doet deze service in één zin?
3. **Rol in het systeem** — is dit een standalone service, onderdeel van een groter systeem, of een monoliet?
4. **Primaire gebruikers** — wie zijn de directe consumers (frontend, andere services, externe partijen)?

### Groep 2 — Tech stack
5. **Programmeertaal** — Java, Python, TypeScript, of anders?
6. **Framework** — Spring Boot, Django, NestJS, Express, of anders?
7. **Build tool** — Maven, Gradle, npm, pip, of anders?
8. **Database** — PostgreSQL, MySQL, MongoDB, of anders? Of geen database?
9. **ORM/data access** — JPA/Hibernate, SQLAlchemy, Prisma, TypeORM, of anders?

### Groep 3 — Communicatie en integraties
10. **Welke services/APIs roept deze service aan?** — extern of intern
11. **Welke services roepen deze service aan?** — wie zijn de consumers
12. **Message broker** — Kafka, RabbitMQ, SQS, of geen?
13. **Cache** — Redis, Memcached, of geen?
14. **Observability** — welke stack (Prometheus/Grafana, Datadog, ELK, CloudWatch)?

### Groep 4 — Non-functional requirements
15. **Verwachte load** — requests per seconde, berichten per minuut?
16. **Latency vereisten** — p95 target in ms?
17. **Uptime vereiste** — 99.9%, 99.99%?
18. **Data sensitivity** — bevat het PII, financiele data, medische data?

### Groep 5 — Deployment
19. **Deployment target** — Kubernetes, ECS, Lambda, bare metal?
20. **CI/CD** — GitHub Actions, GitLab CI, Jenkins, of anders? (mag ook "nog niet besloten")
21. **Container** — Docker-based of anders?
22. **Environments** — welke (dev, staging, production)?

---

## Na het interview — stap voor stap

### Stap 0. Lees de bootstrap templates

**Doe dit EERST, voordat je iets verwijdert.**

Lees en onthoud de inhoud van CLAUDE.md.template en README.md voordat je verder gaat. Je hebt de inhoud van CLAUDE.md.template nodig voor Stap 3. Als je dit bestand verwijdert voordat je het hebt gelezen, heb je geen basis meer voor de CLAUDE.md.

### Stap 1. Bootstrap bestanden opruimen

Verwijder bestanden die alleen voor de bootstrap bedoeld zijn (pas NA Stap 0):
```bash
rm -f SESSION-SUMMARY.md
rm -f CLAUDE.md.template
rm -f README.md
```

**SESSION-SUMMARY.md** bevat de ontwerpbeslissingen van de bootstrap — niet relevant voor het nieuwe project.
**CLAUDE.md.template** is de bron voor de nieuwe CLAUDE.md — na generatie niet meer nodig.
**README.md** beschrijft de bootstrap repo — het project krijgt zijn eigen README.

### Stap 2. Irrelevante rules opruimen

De rules zijn georganiseerd per categorie: rules/backend/, rules/frontend/, rules/testing/, rules/commons/. Verwijder de bestanden die niet bij de gekozen tech stack horen. rules/commons/ blijft altijd — die is stack-onafhankelijk.

Backend rules — houd alleen de gekozen taal/framework, verwijder de rest:
- Java + Spring Boot: houd java-conventions.md, java-spring-boot.md, common.md — verwijder alle andere backend/*.md
- Java zonder framework: houd java-conventions.md, common.md — verwijder alle andere backend/*.md
- Python + FastAPI: houd python-conventions.md, python-fastapi.md, common.md — verwijder alle andere backend/*.md
- Python zonder framework: houd python-conventions.md, common.md — verwijder alle andere backend/*.md
- .NET / C#: houd dotnet-conventions.md, dotnet-aspnet.md, common.md — verwijder alle andere backend/*.md
- Kotlin: houd kotlin.md, common.md — verwijder alle andere backend/*.md
- Go: houd go.md, common.md — verwijder alle andere backend/*.md
- Elixir + Phoenix: houd elixir-conventions.md, elixir-phoenix.md, common.md — verwijder alle andere backend/*.md

Frontend rules — als er geen frontend is, verwijder de hele rules/frontend/ map. Anders houd alleen het gekozen framework:
- React / Next.js: houd react.md, typescript.md, common.md, ui-ux.md — verwijder angular.md
- Angular: houd angular.md, typescript.md, common.md, ui-ux.md — verwijder react.md
- Geen frontend: verwijder hele rules/frontend/ map

Testing rules — houd alleen de talen die actief zijn in het project. Verwijder testing rules voor talen die je hierboven hebt verwijderd. Houd altijd testing/common.md en testing/e2e.md.

Voorbeeld voor Java + Spring Boot + geen frontend:
  rm .claude/rules/backend/python-conventions.md .claude/rules/backend/python-fastapi.md
  rm .claude/rules/backend/dotnet-conventions.md .claude/rules/backend/dotnet-aspnet.md
  rm .claude/rules/backend/kotlin.md .claude/rules/backend/go.md
  rm .claude/rules/backend/elixir-conventions.md .claude/rules/backend/elixir-phoenix.md
  rm -rf .claude/rules/frontend/
  rm .claude/rules/testing/python.md .claude/rules/testing/dotnet.md
  rm .claude/rules/testing/kotlin.md .claude/rules/testing/go.md
  rm .claude/rules/testing/elixir.md .claude/rules/testing/react.md .claude/rules/testing/angular.md

### Stap 3. Genereer CLAUDE.md

Gebruik de inhoud van `CLAUDE.md.template` (lees het eerst!) als basis. Vul de placeholders in:
- `[Project naam]` → de gekozen projectnaam
- `[Één zin — wat doet deze service en voor wie]` → uit interview groep 1
- `[build commando]` → op basis van build tool (mvn, gradle, npm, pip, etc.)
- `[test commando]` → op basis van framework (mvn test, pytest, npm test, etc.)
- `[run commando]` → op basis van framework
- `[migratie commando]` → op basis van ORM/framework (flyway, alembic, prisma, etc.)
- `[structuur]` → typische mappenstructuur voor het gekozen framework

**Let op:** CLAUDE.md mag niet groter worden dan ~100 regels. Houd het lean.

### Stap 4. Genereer ADR-001 — Stack beslissingen

Maak `docs/decisions/ADR-001-stack-beslissingen.md` aan met:
- **Status:** accepted
- **Datum:** vandaag
- **Context:** waarom dit project bestaat en wat het moet doen (uit groep 1)
- **Beslissingen:** elke tech stack keuze met korte motivatie
- **Consequenties:** wat volgt uit deze keuzes (positief en negatief)

### Stap 5. Configureer agents met projectcontext

Elk agent bestand in `.claude/agents/` heeft een `## Projectcontext` sectie met placeholders. Vul deze in voor **alle 12 agents**:

```markdown
## Projectcontext

- **Service:** [naam] — [verantwoordelijkheid]
- **Tech stack:** [taal] / [framework] / [build tool]
- **Database:** [type] met [ORM]
- **Integraties:** [services, brokers, cache]
- **Observability:** [stack]
- **Rules:** lees `.claude/rules/commons/` voor algemene conventies en `.claude/rules/backend/` voor stack-specifieke conventies
```

Daarnaast per agent categorie:

**Developer agents** (backend, frontend, ui-designer):
- Voeg de relevante stack-specifieke rules referentie toe op basis van de gekozen stack:
  - Java: rules/backend/java-conventions.md en rules/backend/java-spring-boot.md
  - Python: rules/backend/python-conventions.md en rules/backend/python-fastapi.md (indien FastAPI)
  - .NET: rules/backend/dotnet-conventions.md en rules/backend/dotnet-aspnet.md
  - Kotlin: rules/backend/kotlin.md
  - Go: rules/backend/go.md
  - Elixir: rules/backend/elixir-conventions.md en rules/backend/elixir-phoenix.md (indien Phoenix)
  - React frontend: rules/frontend/react.md en rules/frontend/typescript.md
  - Angular frontend: rules/frontend/angular.md en rules/frontend/typescript.md
- Als er geen frontend is: noteer in frontend-developer en ui-designer dat ze niet actief zijn voor dit project

**DBA reviewer**:
- Voeg database type en ORM toe
- Voeg migratie tool referentie toe

**Security reviewer**:
- Voeg data sensitivity level toe (PII, financieel, medisch)
- Voeg auth mechanisme toe indien besproken

**Non-functional reviewer**:
- Voeg externe dependencies toe (welke services, latency targets)
- Voeg uptime vereiste toe

### Stap 6. Genereer README.md

Gebruik het README template (`readme-template.md` in deze skill folder) als basis. Vul in:
- Projectnaam en beschrijving (uit groep 1)
- Quickstart commando's (install, run, test — uit groep 2)
- Tech stack tabel (uit groep 2 + 3)
- Korte architectuur beschrijving (uit groep 1 + 3)
- Project structuur passend bij het gekozen framework

**De README is het eerste wat een nieuwe developer leest.** Houd het beknopt, concreet, en actionable.

### Stap 7. Doc structuur aanvullen

Maak directories aan die nog niet bestaan (sommige bestaan al vanuit bootstrap):
```bash
mkdir -p docs/work/features
mkdir -p docs/work/bugs
mkdir -p docs/work/chores
mkdir -p docs/decisions
mkdir -p docs/workflow
mkdir -p docs/architecture/api-contracts
mkdir -p docs/audits
```

### Stap 8. CI/CD afhandelen

Op basis van het antwoord op de CI/CD vraag (vraag 20):

**Als CI/CD al besloten is:**
- Leg de keuze vast in ADR-001 (onder de andere stack beslissingen)
- Voeg toe aan de agent projectcontext waar relevant

**Als CI/CD nog niet besloten is:**
- Maak een chore doc aan in `docs/work/chores/` met het chore-template:
  - **Titel:** CI/CD pipeline opzetten
  - **Type:** ci-cd
  - **Risico:** midden
  - **Beschrijving:** CI/CD pipeline opzetten voor het project. Minimale pipeline stappen: build, test, static analysis, deploy. Richtlijnen: één keer builden en overal deployen (niet per omgeving opnieuw), dezelfde deploy methode op elke omgeving, geen handmatige stappen, secrets via secret store van de CI/CD tooling (nooit in code of logs).
  - **Acceptatiecriteria:** pipeline draait op elke push, tests zijn verplicht groen voor merge, deploy naar staging is geautomatiseerd
  - **Urgentie:** niet blokkerend voor development, wel nodig voor eerste deploy

### Stap 9. Git herinitialiseren

Het project moet met een schone git history beginnen. De huidige `.git` verwijst nog naar de bootstrap repo — die moet weg.

**Stap 9a — Verwijder de bootstrap git history:**
```bash
rm -rf .git
```

**Stap 9b — Initialiseer een nieuw repo:**
```bash
git init
git add -A
git commit -m "docs: project bootstrap — [projectnaam]"
```

**Stap 9c — Remote instellen:**
Vraag de gebruiker: "Heb je al een repo aangemaakt voor dit project? Zo ja, wat is de URL?"

Als de gebruiker een URL geeft:
```bash
git remote add origin [url]
git push -u origin main
```

Als de gebruiker nog geen repo heeft, bied aan om er een aan te maken:
```bash
gh repo create [projectnaam] --private --source=. --remote=origin --push
```

**Waarschuwing:** Maak NOOIT een publiek repo aan zonder expliciete toestemming. Default is private.

### Stap 10. Bevestig aan de gebruiker

Geef een samenvatting:
- CLAUDE.md inhoud (kort)
- ADR-001 samenvatting
- Welke rules actief zijn voor de gekozen stack
- Welke agents conditioneel NIET actief zijn (bijv. frontend-developer als er geen frontend is)
- Verwijderde bootstrap bestanden en irrelevante rules
- **Volgende stap:** eerste feature definiëren met `/new-feature`

---

## Regels

- Sla nooit een interviewgroep over
- Maak geen aannames — vraag als iets onduidelijk is
- Genereer nooit code — dit is alleen scaffolding en configuratie
- **Voer Stap 0 altijd als eerste uit** — lees CLAUDE.md.template voordat Stap 1 het verwijdert
- Alle stappen worden **in volgorde** uitgevoerd — niet parallel
- Eindig altijd met de git herinitialisatie — het project start clean
