# Resilience Patterns

Stack-onafhankelijke richtlijnen voor het bouwen van veerkrachtige systemen.
Deze patronen beschermen tegen cascading failures en onvoorspelbaar gedrag van externe dependencies.

---

## Timeouts

Elke uitgaande call heeft een expliciete timeout. Geen unbounded waits.

### Regels

- Definieer **connect-timeout** en **read-timeout** apart — een trage verbinding is een ander probleem dan een trage response
- Timeouts zijn altijd configureerbaar via environment variabelen of configuratiebestanden, nooit hardcoded
- Kies timeouts op basis van gemeten P99 latency van de dependency, niet op gevoel
- Zet timeouts strikter dan de default van je HTTP client — library defaults zijn vaak 30-60 seconden, veel te ruim
- Database queries hebben ook een timeout — een query die 30 seconden draait is een probleem, geen feature

### Vuistregels

| Type call | Connect timeout | Read timeout |
|---|---|---|
| Interne service | 1-3s | 5-10s |
| Externe API | 3-5s | 10-30s |
| Database | 1-2s | 5-15s |

Deze waarden zijn startpunten. Pas aan op basis van gemeten latency.

---

## Retries

Retries compenseren voor transient failures. Zonder begrenzing maken ze het probleem erger.

### Regels

- Alleen retrien bij **transient failures**: connection timeouts, 503, 429, network errors
- Nooit retrien bij **permanente fouten**: 400, 401, 403, 404, validatiefouten
- Maximaal **3 retries** als default — meer dan dat is zelden zinvol
- Gebruik **exponential backoff met jitter** — voorkomt thundering herd wanneer meerdere clients tegelijk retrien
- Retry alleen **idempotente operaties** — een POST zonder idempotency key retrien kan duplicaten veroorzaken

### Backoff strategie

```
wachttijd = min(basis * 2^poging + willekeurige_jitter, maximum_wachttijd)

Poging 1: ~200ms
Poging 2: ~400ms
Poging 3: ~800ms
```

### Wat te loggen bij retries

- Welke operatie, welke poging (2/3), welke error
- Na de laatste poging: log als WARNING met volledige context

---

## Circuit Breaker

Beschermt tegen cascading failures door calls naar een falende dependency tijdelijk te stoppen.

### States

- **Closed** — alles werkt, requests gaan door
- **Open** — dependency faalt, requests worden direct afgewezen zonder call
- **Half-open** — na een cooldown periode gaat een beperkt aantal requests door om te testen of de dependency hersteld is

### Regels

- Definieer een **failure threshold** voor het openen van de circuit (bijv. 5 fouten in 30 seconden)
- Definieer een **cooldown periode** voor half-open state (bijv. 30 seconden)
- Definieer een **success threshold** in half-open voor het sluiten van de circuit (bijv. 3 opeenvolgende successen)
- Thresholds zijn configureerbaar, niet hardcoded

### Fallback gedrag

Wanneer de circuit open staat, moet het systeem bewust reageren:

- **Cached response** — geef de laatst bekende goede response terug als dat acceptabel is
- **Default waarde** — geef een veilige default terug die de caller kan verwerken
- **Feature uitschakelen** — schakel de functionaliteit tijdelijk uit met een duidelijke melding
- **Falen met context** — geef een duidelijke error terug die aangeeft dat de dependency tijdelijk onbereikbaar is

Kies per dependency welk fallback gedrag past. Documenteer deze keuze.

### Monitoring

- Log elke state transitie (closed→open, open→half-open, half-open→closed)
- Alert bij open circuit — dit betekent dat een dependency structureel faalt

---

## Health Checks

Één endpoint dat aangeeft of de applicatie correct functioneert.

### Status waarden

Per IETF draft (draft-inadarei-api-health-check):

- **pass** — alles werkt naar behoren
- **warn** — functioneert maar met beperkingen (bijv. een niet-kritieke dependency onbereikbaar)
- **fail** — kan geen requests verwerken

### Regels

- Health check test connectiviteit met kritieke dependencies (database, cache, message broker)
- Eigen timeout op de check zelf (korter dan normale requests, bijv. 3 seconden)
- Geen interne details in de response — alleen de status
- Cache het resultaat kort (5-10 seconden) om dependencies niet te belasten met health check traffic

### Response format

```json
{ "status": "pass" }
```

```json
{ "status": "warn" }
```

```json
{ "status": "fail" }
```

---

## Blocking & Waiting

Regels voor code die wacht op een conditie of resultaat.

### Regels

- Geen sleep/delay functies als synchronisatiemechanisme — gebruik signals, events, of condition variables
- Geen busy-wait loops (polling in tight loop) — gebruik backoff of event-driven notificatie
- Geen hardcoded sleeps in productiecode
- Wachten op een externe conditie altijd met een **expliciete timeout en faalpad** — als de conditie niet optreedt, moet er een duidelijke error volgen

### In tests

- Geen vaste wachttijden om te wachten op een async resultaat
- Gebruik polling met timeout: controleer de conditie herhaaldelijk met korte intervallen en een maximum wachttijd
- De meeste test frameworks bieden hier utilities voor
