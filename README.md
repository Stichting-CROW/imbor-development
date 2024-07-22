# IMBOR-development

**ONTWIKKELINGOMGEVING** voor IMBOR. Data binnen deze repository is 'work-in-progress' en kan dus niet gebruikt worden in productieomgevingen. Deze repository is er alleen om de voortgang in te kunnen zien en de ontwikkeling van IMBOR transparant te houden. Issues worden alleen behandeld in de [**imbor-issues**](https://github.com/Stichting-CROW/imbor/issues).


_**DEVELOPMENT ENVIRONMENT** for IMBOR. Data within this repository is 'work-in-progress' and should not be used in production environments. This repository exists solely to provide insight into the progress and to keep the development of IMBOR transparent. Issues are only addressed in the [**imbor-issues**](https://github.com/Stichting-CROW/imbor/issues)._


## Inhoud repository
Deze repository bevat drie folders:
- [`data`](data): **Belangrijkste folder met alle ontwikkel data**
  - [`msaccess:`](data/msaccess) De _up-to-date_ versie van de MS Access Database: [**De laatste werkversie**](data/msaccess/IMBOR-development.accdb)
  - [`rdf:`](data/rdf) RDF bestanden (in Turtle formaat) welke automatisch gegenereerd worden door [GitHub actions](https://github.com/Stichting-CROW/imbor-development/actions) op basis van de Access Database
  - [`tsv:`](data/tsv) TSV bestanden welke automatisch gegeneerd worden door [GitHub actions](https://github.com/Stichting-CROW/imbor-development/actions) op basis van de Access Database
- [`bin:`](bin) Hulpfolder voor het genereren van de `rdf` en `tsv`
- [`src:`](src) Hulpfolder voor het genereren van de `rdf` en `tsv`. Inclusief alle SPARQL-queries waarmee de Access Database naar RDF wordt omgezet

### ACCDB bestand
[`IMBOR-development.accdb`](data/msaccess/IMBOR-development.accdb) is de ontwikkelversie (werkversie) van IMBOR. Deze wordt hier elke keer geplaatst als er wijzigingen geweest zijn. Wanneer er een release is wordt deze verplaatst naar de [**imbor**](https://github.com/Stichting-CROW/imbor/tree/master/data) repository. 

### TSV bestanden
De folder [`tsv`](data/tsv) bevat automatisch gegenereerde `tsv` bestanden door [GitHub actions](https://github.com/Stichting-CROW/imbor-development/actions). Bij elke nieuwe commit van de [`IMBOR-development.accdb`](data/msaccess/IMBOR-development.accdb) worden automatische de tabellen uit de database omgezet naar `tsv`. Daardoor kan op **regel niveau bekeken worden wat er gewijzigd is** omdat GitHub dit nu bijhoudt. 


### RDF bestanden
De folder [`rdf`](data/rdf) bevat automatisch gegenereerde `ttl` bestanden door [GitHub actions](https://github.com/Stichting-CROW/imbor-development/actions). Bij elke nieuwe commit van de [`IMBOR-development.accdb`](data/msaccess/IMBOR-development.accdb) worden automatische de tabellen uit de database omgezet naar `rdf`. De transformatie maakt gebruik van [`workflow.sqr.yaml`](workflow.sqr.yaml) en alles uit de [`bin`](bin) en [`src`](src) folder. Hieruit volgt de content van de [`rdf`](data/rdf) folder. Deze transformatie kan ook zelf lokaal gedaan worden:

#### Lokale transformatie naar RDF
- Een beschikbaar GraphDB-endpoint op poort 7200, met een repository genaamd `imbor-development`.
  - Script [`bin/setup.sh`](bin/setup.sh) beschrijf hoe je die met Docker lokaal opzet
- Zorg ervoor dat `npm` en `npx` beschikbaar zijn in `$PATH`
- Zorg ervoor dat de inputbestanden (sc. `IMBOR-development.accdb`) beschikbaar zijn.

- Voer `sparql-query-runner run --exec-shell` uit. Als die nog niet is geïnstalleerd, doe dat met het volgende commando:

```sh
$ npm install --global @rdmr-eu/sparql-query-runner
```

![image](https://github.com/Stichting-CROW/imbor/assets/56293445/5e00e5cf-2ba7-459f-9fb4-f433b346920a)
