# IMBOR Pipeline

Private repository to transform IMBOR Access file to RDF in Turtle 

## Benodigdheden transformatie

- Een beschikbaar SPARQL-endpoint dat werkt volgens de RDF4J-API, zoals bijv. GraphDB
- Pas de endpoints beschreven in [./sparql-query-runner.json] aan
- Zorg ervoor dat `npm` en `npx` beschikbaar zijn in `$PATH`
- Zorg ervoor dat de inputbestanden (sc. `IMBOR-2022*.accdb`)
- Voer uit: 

```sh
$ npx @rdmr-eu/sparql-query-runner
```

- Met Apache Jena's `riot` beschikbaar op `$PATH` worden ook de resulterende bestanden ge-pretty-format.
