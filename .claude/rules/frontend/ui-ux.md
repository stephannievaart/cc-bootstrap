# UI/UX Principes

Gebruikerservaring principes die de hele stack raken — backend én frontend.

---

## Foutmeldingen

- Schrijf in de taal van de gebruiker, niet van de developer — geen jargon, geen codes zonder uitleg
- Elke foutmelding is actionable — vertel wat de gebruiker kan doen, niet alleen wat er mis ging
- Consistente toon — zakelijk, behulpzaam, niet beschuldigend ("Er ging iets mis" niet "U heeft een fout gemaakt")
- Validatiefouten noemen het specifieke veld en wat er verwacht wordt

## Loading & feedback

- Elke actie die langer dan ~300ms duurt geeft visuele feedback — geen stilte
- Langlopende operaties (report generatie, bulk import) bieden een voortgangsmechanisme — de API retourneert 202 Accepted + status resource die de frontend kan pollen
- Geef een indicatie van verwachte duur bij operaties langer dan een paar seconden

## Consistente terminologie

- Gebruik dezelfde term voor hetzelfde concept in de hele applicatie — API velden, UI labels, documentatie
- Houd een woordenlijst bij als het domein complexe of ambigue termen heeft
- Wijzig terminologie op alle plekken tegelijk — niet alleen de UI terwijl de API de oude term houdt

## Destructieve acties

- Destructieve acties zijn onomkeerbaar tenzij expliciet anders ontworpen
- Overweeg soft delete en undo bij het API design — maak de keuze bewust, niet achteraf

## Datum & tijd

- De API levert altijd UTC (ISO 8601) — de presentatielaag converteert naar de tijdzone van de gebruiker
- Gebruik relatieve tijden ("3 minuten geleden") voor recente events, absolute tijden voor historische data
- Toon altijd de tijdzone als er ambiguïteit mogelijk is
