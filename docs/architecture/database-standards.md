# Database Standards

Stack-onafhankelijke richtlijnen voor database ontwerp en beheer. Doel: consistente, veilige en onderhoudbare databases.

---

## Naming conventies

### Regels

- Kies **één casing** (snake_case of camelCase) en gebruik die consistent voor alle objecten
- Kies **singular of plural** voor tabelnamen en gebruik die consistent door de hele database
- Tabelnamen beschrijven de entiteit: `order`, `user_profile` — geen afkortingen tenzij domein-standaard
- Kolommen beschrijven het attribuut: `email_address`, niet `ea` of `email_addr`
- Foreign key kolommen bevatten de gerelateerde tabel en kolom: `user_id`, `order_id`
- Boolean kolommen met prefix: `is_active`, `has_permission`
- Index naamgeving: `idx_[tabel]_[kolom(men)]`
- Constraint naamgeving: `fk_[tabel]_[gerelateerde_tabel]`, `uq_[tabel]_[kolom]`, `chk_[tabel]_[beschrijving]`
- Geen reserved words als object namen

---

## Schema ontwerp

### Regels

- Foreign keys altijd **expliciet** definiëren — geen impliciete relaties op basis van naamgeving alleen
- Elke tabel heeft een **primary key** — geen uitzonderingen
- Audit velden op elke tabel: `created_at` en `updated_at` (timestamp in UTC)
- **Soft deletes** (bijv. `deleted_at`) alleen als er een business reden is om verwijderde data te behouden — hard delete is de default
- Geen business logica in de database (stored procedures, triggers) tenzij er een aantoonbare noodzaak is — logica hoort in de applicatie
- Geen nullable kolommen tenzij `null` een expliciete business betekenis heeft — gebruik defaults waar mogelijk

---

## Migraties

Migration-based versioning. Elke wijziging aan het schema is een migratie.

### Regels

- Eén migratie = **één logische wijziging** — niet meerdere onafhankelijke wijzigingen combineren
- Migraties zijn **sequentieel genummerd** met timestamp of incrementeel nummer
- Elke migratie heeft een **rollback** — beschrijf hoe de wijziging ongedaan gemaakt wordt
- Migraties zijn **idempotent** — dezelfde migratie twee keer draaien mag geen fout geven
- Nooit een bestaande migratie wijzigen die al in een gedeelde omgeving is gedraaid — maak een nieuwe migratie
- Migraties draaien in **één transactie** waar de database dit ondersteunt — geen half-afgeronde migraties

### Destructieve wijzigingen

Kolommen of tabellen verwijderen is een meerstaps proces:

1. **Stop het gebruik** — verwijder alle code die de kolom/tabel gebruikt
2. **Deploy** — bevestig dat de oude code niet meer draait
3. **Migratie** — verwijder de kolom/tabel in een aparte migratie

Nooit in één stap code én schema wijzigen voor destructieve changes.

### Data migraties

- Data migraties apart van schema migraties
- Altijd backward-compatible: de oude code moet blijven werken tijdens de migratie
- Test data migraties met een representatieve dataset voor uitvoering op productie

---

## Indexing

### Regels

- Foreign key kolommen altijd indexen
- Index op kolommen die frequent voorkomen in WHERE, JOIN en ORDER BY
- Niet over-indexen — elke index vertraagt writes (INSERT, UPDATE, DELETE)
- Geen index op kolommen met lage kardinaliteit (bijv. boolean velden)
