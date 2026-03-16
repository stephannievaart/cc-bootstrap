# Error Handling Rules

---

## Algemeen

- Behandel errors op elk niveau — nooit stilzwijgend opslokken
- Log gedetailleerde context server-side
- Geef bruikbare maar veilige berichten terug aan clients
- Geen bare `catch` blokken zonder actie

## Error types

- Onderscheid tussen **verwachte fouten** (validatie, not found) en **onverwachte fouten** (bugs, crashes)
- Verwachte fouten: geef duidelijke HTTP status + error code terug
- Onverwachte fouten: log volledig met stack trace, geef generieke melding aan client

## Error response format

Consistent envelope voor alle API errors:
```json
{
  "error": "beschrijving voor de gebruiker",
  "code": "ERROR_CODE",
  "details": {}
}
```

## Externe dependencies

- Vang alle exceptions van externe calls (HTTP, database, queue)
- Zet om naar interne exceptions met context
- Laat externe error details niet lekken naar clients

## Logging bij errors

- Log: wat er fout ging, waar, met welke input (zonder PII)
- Log: correlation ID zodat de request traceerbaar is
- Log niveau: ERROR voor onverwachte fouten, WARN voor verwachte fouten

## Verboden

- Lege `catch` blokken
- `catch (Exception e) {}` zonder logging of re-throw
- Stack traces teruggeven aan clients
- Fouten negeren omdat "het toch wel goed komt"
