#TODO: Checken waarom deze nodig is

CONSTRUCT {
    ?tgtList a rdf:List .
    ?tgtList rdf:first ?tgtElementUri .
    ?tgtElementUri a ?tgtEnumeratieType .
    ?tgtElementUri rdfs:label ?domeinwaarde .
    ?tgtList rdf:rest ?tgtRestList .
    ?tgtEnumeratieType rdfs:subClassOf nen2660:EnumerationType .
    ?tgtEnumeratieType a sh:NodeShape .
    ?tgtEnumeratieType sh:in ?tgtListFirst .
}
WHERE {
    # Iets om te zorgen dat je het over één en dezelfde  attributen op te halen
	?row2 csv:Enumeratietype ?enumeratietype .
	## Je hebt 2 lijstjes nodig (= 2 subqueries) per enumeratieType:
	## 1x om alle domeinwaarden op te halen + van iedere domeinwaarde het aantal domeinwaarden wat 'kleiner' is (op basis van een string-vergelijking)
	## 1x om alle domeinwaarden op te halen + van iedere domeinwaarde het aantal domeinwaarden wat 'groter' is (op basis van een string-vergelijking)
	## Hiermee kun je uiteindelijk sorteren en onderaan deze query een lijstje opbouwen
	{
        SELECT ?enumeratieType ?domeinwaardeIMBORGUID ?domeinwaarde ((COUNT(?predecessor)) AS ?elementIndex)
        WHERE {
			?row2 csv:Domeinwaarde ?Domeinwaarde .
            ?row2 csv:Enumeratietype ?enumeratieType .
			# Dit klopt nog niet helemaal, even aanpassen naar de juiste graph
            ?row2 csv:IMBORGUID ?domeinwaardeIMBORGUID .
            OPTIONAL {
                ?otherRow csv:Enumeratietype ?enumeratieType .
				?otherRow csv:IMBORGUID ?predecessor .
                FILTER (str(?predecessor) < str(?domeinwaardeIMBORGUID)) .
            } .
        }
        GROUP BY ?enumeratieType ?domeinwaardeIMBORGUID ?domeinwaarde
    } .
    {
        SELECT ?enumeratieType ?domeinwaardeIMBORGUID ?domeinwaarde ((COUNT(?successor)) AS ?isLastElement)
        WHERE {
			?row2 csv:Domeinwaarde ?Domeinwaarde .
            ?row2 csv:Enumeratietype ?enumeratieType .
			# Dit klopt nog niet helemaal, even aanpassen naar de juiste graph
            ?row2 csv:IMBORGUID ?domeinwaardeIMBORGUID .
            OPTIONAL {
                ?otherRow csv:Enumeratietype ?enumeratieType .
				?otherRow csv:IMBORGUID ?successor .
                FILTER (str(?successor) > str(?domeinwaardeIMBORGUID)) .
            } .
        }
        GROUP BY ?enumeratieType ?domeinwaardeIMBORGUID ?domeinwaarde
    } .
    BIND (?enumeratieType AS ?tgtEnumeratieType) .
    BIND (?domeinwaardeIMBORGUID AS ?tgtElementUri) .
	## Nu ga je de lijstjes gebruiken om je rdf:list op te bouwen
	## In dit geval worden de URIs voor de list opgebouwd uit: de URI van enumeratieType + '-list-' + een volgnummer
    BIND (CONCAT(str(?tgtEnumeratieType), "-list-") AS ?listBase) .
	## Startpunt van de lijst is altijd 0
    BIND (IRI(CONCAT(?listBase, "0")) AS ?tgtListFirst) .
	## De eerste subquery geeft een volgnummer terug, die plak je in de URI
    BIND (IRI(CONCAT(?listBase, str(?elementIndex))) AS ?tgtList) .
	## De tweede subquery geeft aan hoeveel domeinwaarden nog te gaan zijn. Als dit 0 is kun je de rdf:list afsluiten met rdf:nil, anders wijst hij door naar de volgende volgnummer in de lijst
    BIND (IF((?isLastElement = 0), rdf:nil, URI(CONCAT(?listBase, str((?elementIndex + 1))))) AS ?tgtRestList) .
}