# Angular Testing — TestBed patronen

Paths: `**/*.spec.ts`

Voor tooling keuze (TestBed, component harness, HttpTestingController) zie `frontend/angular.md`.
Voor TDD workflow zie `testing/common.md`.

---

## TestBed in beforeEach

- TestBed configuratie altijd in `beforeEach` — nooit in `beforeAll`
- Angular reset modules per test — `beforeAll` leidt tot gedeelde state en flaky tests
- Houd de `configureTestingModule` minimaal — alleen wat de test nodig heeft

## detectChanges()

- Altijd `fixture.detectChanges()` aanroepen na `createComponent()` en voor assertions op template
- Expliciete `detectChanges()` na elke state wijziging die de template raakt
- Gebruik `fixture.autoDetectChanges(true)` alleen als je continu change detection nodig hebt

## Services zonder TestBed

- Services zonder Angular DI afhankelijkheden: test direct met `new MyService(mockDep)`
- TestBed alleen voor component + DI integratie of services die Angular injectables nodig hebben
- Sneller en eenvoudiger — TestBed overhead vermijden waar het kan

## HTTP mocking

- `provideHttpClientTesting()` + `HttpTestingController` voor HTTP tests
- Flush requests expliciet met `req.flush(data)` — verifieer request method en URL
- `httpMock.verify()` in `afterEach` — garandeert geen onverwachte open requests

## Async testing

- `fakeAsync`/`tick` voor timers, debounce, en Promise-based code
- `waitForAsync` voor echte HTTP of complexe async flows
- Nooit `fakeAsync` en echte async mixen in dezelfde test — kies één model

## Component harness

- `HarnessLoader` voor component interactie — stabielere API dan directe DOM queries
- `TestbedHarnessEnvironment.loader(fixture)` voor setup
- Gebruik Material CDK harnesses voor Angular Material componenten

## Verboden

- TestBed config wijzigen na `createComponent()` — heeft geen effect, leidt tot verwarrende failures
- `async/await` binnen `fakeAsync` blokken — breekt de fake async zone
- `fixture.debugElement.query` voor assertions — gebruik component harness of `nativeElement` met semantische queries
