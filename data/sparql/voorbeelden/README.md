# IMBOR SPARQL – voorbeeldquery's

Deze map bevat voorbeeld-SPARQL-query's (`.rq`) op de IMBOR-data. Ze zijn bedoeld
als startpunt om zelf query's te bouwen en om het datamodel te leren kennen.

## Endpoint

De query's zijn geschreven voor en getest tegen het **IMBOR 2025 Volledig-CombiGraph**
endpoint, waarin alle deelbestanden (kern, domeinwaarden, addenda, vocabulaire) in
één graph zitten:

```
https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql
```

Omdat alles in één graph zit, is er geen federatie (`SERVICE`) nodig – ook de
domeinwaarden zijn direct bevraagbaar. Een overzicht van alle beschikbare endpoints
(o.a. per deelbestand en per jaargang) staat in [`../SPARQL-Endpoints.md`](../SPARQL-Endpoints.md).

Uitvoeren kan via een SPARQL-client, de webinterface van het endpoint, of met curl:

```bash
curl -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" \
  --data-urlencode "query@01 - Zoekingangen (overzicht met aantal objecttypen).rq" \
  -H "Accept: text/csv"
```

## Modelbegrippen

IMBOR is grotendeels een [NEN2660-2](https://docs.crow.nl/imbor/techdoc/) model.
De belangrijkste begrippen die in de query's terugkomen:

| Begrip               | Modellering                                                                                                                                                            | Toelichting                                                                                                                                   |
|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| **Klasse**           | `rdfs:Class`                                                                                                                                                           | Verzamelnaam voor alle klassen (2867 stuks).                                                                                                  |
| **Objecttype**       | `rdfs:Class` + `dash:abstract false` én (in)direct `rdfs:subClassOf` van `nen2660:SpatialRegion`/`nen2660:RealObject`                                                  | Concreet, registreerbaar ruimtelijk/reëel object, bijv. *Boom*, *Lichtmast* (1522 stuks).                                                     |
| **Abstracte klasse** | `rdfs:Class` + `dash:abstract true`                                                                                                                                    | Alleen generiek supertype, bijv. *Vegetatieobject* (189 stuks).                                                                               |
| **Enumeratietype**   | `rdfs:subClassOf nen2660:EnumerationType`                                                                                                                              | Definieert een domeinwaardenlijst; `imbor:typeLijst` geeft aan of het een gesloten *Enumeratielijst* of open *Suggestielijst* is (460 stuks). |
| **Domeinwaarde**     | instantie van een enumeratietype (`… a imbor:<enum>`)                                                                                                                  | De toegestane waarden; kunnen onderling `skos:broader` hebben.                                                                                |
| **Attribuut**        | `rdf:Property`, vastgezet op een klasse via een `sh:PropertyShape` (`sh:path`)                                                                                         | Eigenschappen met o.a. `sh:datatype`, `qudt:hasUnit`, multipliciteit.                                                                         |
| **Relatie**          | `sh:PropertyShape` met een NEN2660-`sh:path` (`isPartOf`, `hasPart`, `contains`, `isConnectedTo`, `executes`, …) en een `sh:qualifiedValueShape/sh:class` als doeltype | Relaties tussen objecttypen.                                                                                                                  |
| **Zoekingang**       | `rdfs:Container` met `rdfs:member`                                                                                                                                     | Thematische ingang (bijv. *Bomen*) die objecttypen groepeert.                                                                                 |

> **Klasse vs. objecttype:** *klasse* is de generieke term (elk `rdfs:Class`);
> een *objecttype* is de concrete, ruimtelijke/reële subset. Materie- en
> functieklassen (bijv. *Asfalt*, *Weren van vee*) zijn wél concreet, maar géén
> objecttype. Zie query 02 en 03.

## Conventies in de query's

- Elke `.rq` begint met een toelichting (doel, model, eventuele parameter) en het
  aanbevolen endpoint.
- Waar van toepassing worden **URI én label** getoond, in die volgorde (URI eerst).
- De query's tonen **standaard alles** (alle objecttypen, enumeraties, enz.). Alleen
  waar dat echt nodig is staat bovenaan een parameter als `BIND(... AS ?param)` die je
  aanpast; een **lege waarde (`""`) toont dan alles**. Dit geldt voor query 10
  (zoekterm) en query 12 (zoekingang, omdat "alles" daar > 100.000 rijen oplevert).

## Overzicht van de query's

| Bestand | Wat het oplevert |
|---------|------------------|
| `01 - Zoekingangen (overzicht met aantal objecttypen).rq` | Alle zoekingangen met het aantal objecttypen per stuk. |
| `02 - Objecttypen (concrete klassen met definitie).rq` | Alle objecttypen (concrete ruimtelijke/reële klassen) met definitie. |
| `03 - Klassen (alle klassen met soort).rq` | Alle klassen met een afgeleide soort (objecttype / abstracte klasse / enumeratietype / materie-of-functieklasse). |
| `04 - Objecttypen onder een zoekingang.rq` | Alle objecttypen per zoekingang (voor álle zoekingangen). |
| `05 - Klassenhierarchie (supertypen van een objecttype).rq` | De volledige overervingsketen (supertypen) van álle objecttypen. |
| `06 - Attributen van een objecttype (inclusief overerving).rq` | Alle attributen van álle objecttypen, inclusief overgeërfde, met datatype/eenheid/multipliciteit. |
| `07 - Domeinwaarden van een enumeratie (op naam).rq` | Alle domeinwaarden van álle enumeraties, inclusief hiërarchie. |
| `08 - Relaties tussen objecttypen (NEN2660).rq` | De NEN2660-relaties van álle objecttypen met hun doeltype. |
| `09 - Attributen met eenheid en grootheid.rq` | Alle kwantitatieve attributen met QUDT-grootheid en -eenheid. |
| `10 - Zoek een begrip (vrije tekst).rq` | Vrije-tekst zoeken door alle begrippen (label + definitie), met soort. **Parameter:** `?zoekterm` (leeg = alles). |
| `11 - Enumeratielijsten versus suggestielijsten.rq` | Alle enumeratietypen met lijsttype en aantal domeinwaarden. |
| `12 - Attributen en domeinwaarden per objecttype (binnen een zoekingang).rq` | Uitgebreide query: attributen + domeinwaarden per objecttype (inclusief overerving). **Parameter:** `?zoekingang` (leeg = alles; zeer groot). |
| `13 - Geometrietypes per objecttype.rq` | Welke geometrie (`sf:Point`/`LineString`/`Surface`/…) álle objecttypen kunnen hebben, via `nen2660:hasBoundary`. |
| `14 - Functies per objecttype.rq` | Welke functies (subklassen van `sml:Function` / `nen2660:Activity`) álle objecttypen vervullen, via `nen2660:executes`. |
| `15 - Domeinwaarden met bovenliggende domeinwaarde en herkomst-attribuut.rq` | Domeinwaarden van álle enumeraties mét bovenliggende domeinwaarde (`skos:broader`) én het attribuut/objecttype dat de lijst gebruikt. |
| `16 - Objecttypen en hun mogelijke verschijningsvormen.rq` | Alle objecttypen met de mogelijke waarden van hun attribuut *verschijningsvorm* (per objecttype een eigen waardenlijst). |
