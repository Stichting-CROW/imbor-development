# IMBOR Pipeline

Private repository to transform IMBOR Access file to RDF in Turtle

## Benodigdheden transformatie

- Een beschikbaar GraphDB-endpoint op poort 7200, met een repository genaamd `imbor-pipeline`.
  - Script [`bin/setup.sh`](bin/setup.sh) beschrijf hoe je die met Docker lokaal opzet
- Zorg ervoor dat `npm` en `npx` beschikbaar zijn in `$PATH`
- Zorg ervoor dat de inputbestanden (sc. `IMBOR-2022*.accdb`) beschikbaar zijn.

- Voer `sparql-query-runner run --exec-shell` uit. Als die nog niet is geïnstalleerd, doe dat met het volgende commando:

```sh
$ npm install --global @rdmr-eu/sparql-query-runner
```
