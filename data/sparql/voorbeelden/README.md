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

Uitvoeren kan via een SPARQL-client, de webinterface van het endpoint, of met curl.
In PowerShell (gebruik `curl.exe`, niet de `curl`-alias voor `Invoke-WebRequest`):

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@01 - Zoekingangen (overzicht met aantal objecttypen).rq" `
  -H "Accept: text/csv"
```

De exacte commando's voor álle query's (elk verwijzend naar het bijbehorende
`.rq`-bestand) staan in [`Uitvoeren-met-curl.md`](Uitvoeren-met-curl.md).

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
| **Attribuut**        | `rdf:Property`, vastgezet op een klasse via een `sh:PropertyShape` (`sh:path`)                                                                                         | Eigenschappen met o.a. `sh:datatype`, `qudt:hasUnit`, multipliciteit. Alleen het attribuut zelf is een `rdf:Property`.                        |
| **Semantische relatie** | `sh:PropertyShape` waarvan de `sh:path` een generiek NEN2660/NEN3610-predicaat is (`hasPart`, `consistsOf`, `contains`, `isConnectedTo`, `executes`, `hasBoundary`, `isDescribedBy`, `nen3610:registratiegegevens`, …) en met een `sh:qualifiedValueShape/sh:class` als doeltype | Verband naar een andere klasse. Anders dan een attribuut is dit predicaat **géén** `rdf:Property`; dat is precies het onderscheid tussen attribuut en relatie (zie query 08/09). |
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
  aanpast; een **lege waarde (`""`) toont dan alles**. Dit geldt voor query 11
  (zoekterm) en query 13 (zoekingang, omdat "alles" daar > 100.000 rijen oplevert).

## Overzicht van de query's

| Bestand | Wat het oplevert |
|---------|------------------|
| `00 - Aantallen (sanity check).rq` | De kern-"ankers" (klassen, objecttypen, attributen, relaties per soort, enumeratielijsten, verschijningsvorm-lijsten) in één telling, om aantallen te bewaken tussen jaargangen. |
| `01 - Zoekingangen (overzicht met aantal objecttypen).rq` | Alle zoekingangen met het aantal objecttypen per stuk. |
| `02 - Objecttypen (concrete klassen met definitie).rq` | Alle objecttypen (concrete ruimtelijke/reële klassen) met definitie. |
| `03 - Klassen (alle klassen met soort).rq` | Alle klassen met een afgeleide soort (objecttype / abstracte klasse / enumeratietype / materie-of-functieklasse). |
| `04 - Objecttypen onder een zoekingang.rq` | Alle objecttypen per zoekingang (voor álle zoekingangen). |
| `05 - Klassenhierarchie (supertypen van een objecttype).rq` | De volledige overervingsketen (supertypen) van álle objecttypen. |
| `06 - Attributen van een objecttype (inclusief overerving).rq` | Alle attributen van álle objecttypen, inclusief overgeërfde, met datatype/eenheid óf waardenlijst (enumeratie) en multipliciteit. |
| `07 - Domeinwaarden van een enumeratie (op naam).rq` | Alle domeinwaarden van álle enumeraties, inclusief hiërarchie. |
| `08 - Alle semantische relaties (NEN2660 en NEN3610).rq` | Álle semantische relaties van álle objecttypen (het spiegelbeeld van de attributen), inclusief geometrie (`hasBoundary`) en functie (`executes`). |
| `09 - Relaties tussen objecttypen (object-naar-object).rq` | De deelverzameling van query 08 waarbij het doeltype zélf óók een objecttype is (dus zonder geometrie/functie/registratie). |
| `10 - Attributen met hun veldtype (datatype, eenheid, grootheid of waardenlijst).rq` | Alle attributen met hun veldtype: datatype, QUDT-eenheid en -grootheid, óf een waardenlijst (enumeratie). |
| `11 - Zoek een begrip (vrije tekst).rq` | Vrije-tekst zoeken door alle begrippen (label + definitie), met soort. **Parameter:** `?zoekterm` (leeg = alles). |
| `12 - Enumeratielijsten versus suggestielijsten.rq` | Alle enumeratietypen met lijsttype en aantal domeinwaarden. |
| `13 - Attributen en domeinwaarden per objecttype (binnen een zoekingang).rq` | Uitgebreide query: attributen + domeinwaarden per objecttype (inclusief overerving). **Parameter:** `?zoekingang` (leeg = alles; zeer groot). |
| `14 - Geometrietypes per objecttype.rq` | Welke geometrie (`sf:Point`/`LineString`/`Surface`/…) álle objecttypen kunnen hebben, via `nen2660:hasBoundary`. |
| `15 - Functies per objecttype.rq` | Welke functies (subklassen van `sml:Function` / `nen2660:Activity`) álle objecttypen vervullen, via `nen2660:executes`. |
| `16 - Domeinwaarden met bovenliggende domeinwaarde en herkomst-attribuut.rq` | Domeinwaarden van álle enumeraties mét bovenliggende domeinwaarde (`skos:broader`) én het attribuut/objecttype dat de lijst gebruikt. |
| `17 - Objecttypen en hun mogelijke verschijningsvormen.rq` | Alle objecttypen met de mogelijke waarden van hun attribuut *verschijningsvorm* (per objecttype een eigen waardenlijst). |

## Aantallen bewaken

Query `00` telt de kern-ankers van het model in één keer. In de toelichting bovenaan
dat bestand staat het **referentiepeil voor IMBOR 2025** (o.a. 2867 klassen, 1522
objecttypen, 460 enumeratietypen, 722 attributen, 1123 relatie-rijen, 201 objecttypen
met een verschijningsvorm-lijst). Draai je die query tegen een nieuwe jaargang of na
een modelwijziging, dan zie je meteen of een getal is verschoven — en dus of een
afbakening (of het model) is veranderd. De afbakening per anker is dezelfde als in de
losse voorbeeldquery's, zodat de aantallen daarmee overeenkomen.
