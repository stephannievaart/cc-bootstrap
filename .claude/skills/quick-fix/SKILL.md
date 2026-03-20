---
name: quick-fix
description: Lichtgewicht pad voor triviale wijzigingen — typo's, config, kleine correcties. Geen task doc, geen review pipeline. Direct commit op een short-lived branch.
argument-hint: "[korte beschrijving van de fix]"
user-invocable: true
---

# Quick Fix — Triviale wijzigingen

Je helpt bij wijzigingen die te klein zijn voor het volledige start-work proces. Geen task doc, geen review pipeline, geen agents.

---

## Stap 1 — Toets of de wijziging écht klein is

De fix moet voldoen aan **alle** criteria:

| Criterium | Vereiste |
|-----------|----------|
| Scope | Eén bestand of één component |
| Aard | Geen logicawijziging — alleen tekst, config, of cosmetisch |
| API impact | Geen — geen endpoints, contracts, of response formats geraakt |
| Database | Geen — geen migraties, queries, of schema wijzigingen |
| Risico | Geen risico op regressie |

### Voorbeelden die WEL quick-fix zijn
- Typo in UI tekst of documentatie
- Config correctie (feature flag, environment variabele)
- Copy/label wijziging
- Enkelvoudige regelwijziging zonder gedragsimpact

### Voorbeelden die GEEN quick-fix zijn
- Bug met reproductie-stappen → `/capture-bug`
- Nieuwe functionaliteit → `/new-feature`
- Wijziging in business logica → `/start-work`
- Meerdere bestanden met samenhangende wijzigingen → `/start-work`

**Als de wijziging niet aan alle criteria voldoet:** stop en verwijs naar de juiste skill.

---

## Stap 2 — Begrijp de fix

> **Agent-fallback:** Als de benodigde informatie al beschikbaar is in het argument (wat, waar, gewenste situatie), sla de vragen over en gebruik de beschikbare informatie direct.

Vraag de gebruiker:
1. **Wat is er fout?** — huidige situatie
2. **Wat moet het zijn?** — gewenste situatie
3. **Waar zit het?** — bestand of component

---

## Stap 3 — Voer de fix uit

Voer de fix uit. In een interactieve sessie kan de gebruiker de fix zelf uitvoeren; in een agent-context: voer de fix direct uit op basis van de informatie uit Stap 2.

Controleer na de wijziging:
- Is het nog steeds één bestand of één component?
- Is er geen logicawijziging binnengeslopen?

**Als de fix tijdens uitvoering groter blijkt dan verwacht:** stop direct. Meld:
> "Deze wijziging is groter dan een quick-fix. Revert de wijzigingen en gebruik `/capture-bug` of `/new-feature` om dit via het volledige proces te doen."

---

## Stap 4 — Commit

### Op een feature/bug/chore branch (niet main)
Commit direct op de huidige branch:
```bash
git add [bestand]
git commit -m "fix: [korte beschrijving]"
```

### Op main
Maak een korte branch aan, commit, en maak direct een PR:
```bash
git checkout -b fix/[korte-naam]
git add [bestand]
git commit -m "fix: [korte beschrijving]"
git push -u origin fix/[korte-naam]
gh pr create --title "fix: [korte beschrijving]" --body "Triviale fix — geen task doc."
```

---

## Stap 5 — Bevestig

- Toon de commit hash
- Als er een PR is aangemaakt: toon de PR link
- Als de fix op een bestaande branch staat: meld dat het meekomt met de volgende PR van die branch

---

## Regels

- Geen task doc — nooit
- Geen review pipeline — nooit
- Geen agents aanroepen — nooit
- Maximaal één bestand of één component — strikte grens
- Altijd `fix:` als commit type
- Stop DIRECT als de scope groeit — verwijs naar het volledige proces
- Op main altijd via een branch + PR — nooit direct committen op main
