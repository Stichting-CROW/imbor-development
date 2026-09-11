# IMBOR SPARQL – uitvoeren met curl (PowerShell)

Dit bestand bevat voor elke voorbeeldquery het exacte commando om de query tegen het
endpoint uit te voeren, geschreven voor **PowerShell** op Windows. De query wordt niet
ingetypt maar rechtstreeks uit het `.rq`-bestand ingelezen
(`--data-urlencode "query@<bestand>"`), zodat je altijd de actuele versie draait.

## Endpoint

```
https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql
```

## Werkwijze

- Gebruik **`curl.exe`**, niet `curl`. In PowerShell is `curl` een alias voor
  `Invoke-WebRequest`, en die kent de opties `-G` / `--data-urlencode` niet.
  `curl.exe` zit standaard op Windows 10/11.
- De regel-vervolgtekens hieronder zijn een backtick (`` ` ``). Je mag alles ook op
  één regel zetten.
- Voer de commando's uit **vanuit deze map** (`data/sparql/voorbeelden/`), zodat de
  relatieve bestandsnaam achter `query@` klopt.
- De `@`-syntax van `--data-urlencode` leest de query uit het bestand en url-encodeert
  hem. De bestandsnamen bevatten spaties/haakjes; houd daarom de dubbele
  aanhalingstekens om `"query@..."` heen.
- Het resultaatformaat bepaal je met de `Accept`-header:
  - `text/csv` → CSV
  - `application/sparql-results+json` → JSON
  - `text/tab-separated-values` → TSV
- Wil je de output bewaren, gebruik dan `| Set-Content -Encoding utf8 resultaat.csv`.

### Tip: elke query in één keer draaien

Vanuit deze map, alle `.rq`-bestanden achter elkaar naar een CSV per query:

```powershell
Get-ChildItem *.rq | ForEach-Object {
  curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
    --data-urlencode "query@$($_.Name)" `
    -H "Accept: text/csv" | Set-Content -Encoding utf8 "$($_.BaseName).csv"
}
```

---

## De commando's per query

### 00 – Aantallen (sanity check)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@00 - Aantallen (sanity check).rq" `
  -H "Accept: text/csv"
```

### 01 – Zoekingangen (overzicht met aantal objecttypen)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@01 - Zoekingangen (overzicht met aantal objecttypen).rq" `
  -H "Accept: text/csv"
```

### 02 – Objecttypen (concrete klassen met definitie)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@02 - Objecttypen (concrete klassen met definitie).rq" `
  -H "Accept: text/csv"
```

### 03 – Klassen (alle klassen met soort)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@03 - Klassen (alle klassen met soort).rq" `
  -H "Accept: text/csv"
```

### 04 – Objecttypen onder een zoekingang

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@04 - Objecttypen onder een zoekingang.rq" `
  -H "Accept: text/csv"
```

### 05 – Klassenhierarchie (supertypen van een objecttype)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@05 - Klassenhierarchie (supertypen van een objecttype).rq" `
  -H "Accept: text/csv"
```

### 06 – Attributen van een objecttype (inclusief overerving)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@06 - Attributen van een objecttype (inclusief overerving).rq" `
  -H "Accept: text/csv"
```

### 07 – Domeinwaarden van een enumeratie (op naam)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@07 - Domeinwaarden van een enumeratie (op naam).rq" `
  -H "Accept: text/csv"
```

### 08 – Alle semantische relaties (NEN2660 en NEN3610)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@08 - Alle semantische relaties (NEN2660 en NEN3610).rq" `
  -H "Accept: text/csv"
```

### 09 – Relaties tussen objecttypen (object-naar-object)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@09 - Relaties tussen objecttypen (object-naar-object).rq" `
  -H "Accept: text/csv"
```

### 10 – Attributen met hun veldtype (datatype, eenheid, grootheid of waardenlijst)

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@10 - Attributen met hun veldtype (datatype, eenheid, grootheid of waardenlijst).rq" `
  -H "Accept: text/csv"
```

### 11 – Zoek een begrip (vrije tekst) — *parameter*

Deze query heeft bovenaan een parameter `BIND("..." AS ?zoekterm)`. Laat je die leeg
(`""`) dan krijg je alles (tot de `LIMIT`). Wil je een andere zoekterm, pas dan het
`.rq`-bestand aan.

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@11 - Zoek een begrip (vrije tekst).rq" `
  -H "Accept: text/csv"
```

### 12 – Enumeratielijsten versus suggestielijsten

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@12 - Enumeratielijsten versus suggestielijsten.rq" `
  -H "Accept: text/csv"
```

### 13 – Attributen en domeinwaarden per objecttype (binnen een zoekingang) — *parameter*

Deze query heeft een parameter `BIND("..." AS ?zoekingang)`. **Let op:** leeg (`""`)
levert > 100.000 rijen op; vul bij voorkeur een zoekingang in het `.rq`-bestand in.

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@13 - Attributen en domeinwaarden per objecttype (binnen een zoekingang).rq" `
  -H "Accept: text/csv"
```

### 14 – Geometrietypes per objecttype

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@14 - Geometrietypes per objecttype.rq" `
  -H "Accept: text/csv"
```

### 15 – Functies per objecttype

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@15 - Functies per objecttype.rq" `
  -H "Accept: text/csv"
```

### 16 – Domeinwaarden met bovenliggende domeinwaarde en herkomst-attribuut

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@16 - Domeinwaarden met bovenliggende domeinwaarde en herkomst-attribuut.rq" `
  -H "Accept: text/csv"
```

### 17 – Objecttypen en hun mogelijke verschijningsvormen

```powershell
curl.exe -s -G "https://hub.laces.tech/crow/imbor/2025/p/volledig-combigraph/sparql" `
  --data-urlencode "query@17 - Objecttypen en hun mogelijke verschijningsvormen.rq" `
  -H "Accept: text/csv"
```
