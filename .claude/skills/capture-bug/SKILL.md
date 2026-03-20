---
name: capture-bug
description: Vangt bugs op met P1-P4 severity classificatie. Parkeert in docs/work/bugs/. P1 waarschuwt voor mogelijke werkonderbreking. P3/P4 parkeert stil.
argument-hint: "[korte bug beschrijving]"
user-invocable: true
---

# Bug Capture

Je vangt een bug op, classificeert de severity, en parkeert het veilig in `docs/work/bugs/` (met `status: backlog` in frontmatter) via git-capture. De huidige werkzaamheden worden niet onderbroken (tenzij P1).

---

## Voordat je begint

Meld aan de gebruiker:
- "Ik ga deze bug vastleggen. Je huidige werk wordt niet onderbroken."
- Als er iets in progress is, benoem het: "Je werkt momenteel aan [titel]. Deze bug wordt geparkeerd."

---

## Interview — kort en gericht

> **Agent-fallback:** Als alle benodigde informatie al beschikbaar is in het argument of de aanroepende context (bijv. een gedetailleerde bugmelding), sla de interviewvragen over en gebruik de beschikbare informatie direct. Stel alleen vragen voor ontbrekende verplichte velden.

### 1. Wat is er kapot?
- Beschrijving van het probleem
- Verwacht gedrag vs. daadwerkelijk gedrag
- Stappen om te reproduceren (als bekend)

### 2. Waar zit het?
- Welk onderdeel / welke pagina / welk endpoint
- Eventuele error messages of logs

### 3. Impact
- Wie heeft er last van? (alle gebruikers, specifieke groep, intern)
- Hoe vaak treedt het op? (altijd, soms, sporadisch)
- Is er een workaround?

---

## Severity bepalen

Op basis van het interview, classificeer:

| Severity | Criteria | Actie |
|----------|----------|-------|
| **P1** | Service down, data loss, security breach, geen workaround | **Direct melden + vragen of huidig werk onderbroken moet worden** |
| **P2** | Belangrijke functionaliteit kapot, workaround mogelijk | Parkeren, prominent in backlog |
| **P3** | Functionaliteit beperkt, niet-kritiek pad | Stil parkeren |
| **P4** | Cosmetisch, minor inconvenience | Stil parkeren |

### P1 — Speciale afhandeling

Bij P1 severity:
1. Meld **prominent**: "⚠ Dit is een P1 bug en is vastgelegd."
2. Adviseer: "Open een nieuwe sessie (of worktree via `/git-worktree`) om deze P1 parallel op te pakken met `/start-work`."
3. **Onderbreek NIET het huidige werk** — alleen vastleggen en melden.

---

## Na het interview

### 1. Genereer bug doc
Gebruik het bug template (`bug-template.md` in deze skill folder) en vul in:
- Titel en beschrijving
- Severity (P1/P2/P3/P4)
- Stappen om te reproduceren
- Verwacht vs. daadwerkelijk gedrag
- Impact omschrijving
- Eventuele error messages

### 2. Bepaal volgnummer
Tel alle bestaande `.md` bestanden in `docs/work/bugs/backlog/` en `docs/work/bugs/done/` (exclusief `.gitkeep`).

Volgnummer = totaal aantal + 1, geformateerd als `B-XXX` (bijv. `B-001`, `B-003`).

Gebruik dit nummer in de doc header: `# B-[nummer] — [Bug titel]`

### 3. Bepaal bestandsnaam
Format: `B-[nummer]-[P-level]-[korte-beschrijving].md` in kebab-case.
Voorbeeld: `B-003-P1-payment-timeout.md`, `B-001-P2-checkout-total-wrong.md`

### 4. Bepaal branch naam
Format: `bug/[P-level]-[korte-beschrijving]` (geen nummer in branch)
Voorbeeld: `bug/P2-checkout-total-wrong`

### 5. Roep git-capture aan
Geef door aan de git-capture skill:
- **doc_path:** `docs/work/bugs/backlog/[bestandsnaam]`
- **doc_content:** de gegenereerde bug doc
- **branch_name:** `bug/[P-level]-[naam]`

### 6. Bevestig aan de gebruiker
- Toon severity, titel, en branch naam
- Bij P1: herhaal de urgentie
- Bij P2-P4: bevestig dat het geparkeerd is
- Verwijs naar `/start-work` om het op te pakken

---

## Regels

- Onderbreek NOOIT het huidige werk — ook niet bij P1
- P1 is alleen een melding + advies om een parallelle sessie te openen
- Classificeer altijd een severity — vraag door als het onduidelijk is
- Gebruik altijd git-capture voor de git operaties
- Combineer nooit meerdere bugs in één doc
