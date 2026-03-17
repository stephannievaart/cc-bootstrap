# Frontend Common Rules

Taal-onafhankelijke regels voor frontend code.

---

## Accessibility

- Semantische HTML — gebruik juiste elementen (`button`, `nav`, `main`), niet `div` voor alles
- Alle interactieve elementen bereikbaar via keyboard (tab, enter, escape)
- Afbeeldingen: alt tekst verplicht, decoratief = lege alt (`alt=""`)
- Kleurcontrast: WCAG AA minimum (4.5:1 voor tekst, 3:1 voor grote tekst)
- Focus management bij navigatie en modals — focus verplaatsen naar nieuw content, terug bij sluiten
- ARIA alleen als semantische HTML niet volstaat — verkeerd ARIA is erger dan geen ARIA

## State management principes

- Onderscheid server state (data van API) en UI state (open/dicht, geselecteerd)
- Meng deze niet in dezelfde store of structuur
- State zo dicht mogelijk bij het component dat het gebruikt
- Afgeleide waarden berekenen, niet apart opslaan — één bron van waarheid

## Responsive design

- UI werkt op mobiel, tablet, en desktop
- Geen hardcoded pixel waarden voor layout — gebruik relatieve eenheden of design tokens
- Touch targets minimaal 44x44px
- Test op meerdere viewports — niet alleen desktop

## Forms

- Client-side validatie is UX, niet security — server valideert altijd opnieuw
- Toon feedback inline bij het veld, niet alleen bovenaan de pagina
- Disable submit niet als enige foutindicatie — toon waarom het formulier niet verstuurd kan worden
- Preserveer user input bij validatiefouten — nooit het formulier legen

## Performance

- Optimaliseer assets: comprimeer afbeeldingen, subset fonts
- Monitor bundel-grootte — stel een budget in en meet bij elke build
- Lazy load zware onderdelen die niet direct zichtbaar zijn

## Empty states

- Nooit een leeg scherm tonen — altijd uitleg waarom het leeg is
- Bied een actie aan: "Maak je eerste project aan" niet alleen "Geen projecten gevonden"
- Onderscheid "nog nooit gebruikt" (onboarding) van "geen resultaten" (filter/zoek)

## Destructieve acties

- Destructieve acties vereisen expliciete bevestiging van de gebruiker
- Toon de impact concreet — "Dit verwijdert 42 records" niet alleen "Weet u het zeker?"
- Bied undo aan waar technisch mogelijk — communiceer duidelijk als iets onomkeerbaar is
