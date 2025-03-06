# Target-Graph: <https://data.crow.nl/imbor/term>
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix owl: <http://www.w3.org/2002/07/owl#>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix sh: <http://www.w3.org/ns/shacl#>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix prov: <http://www.w3.org/ns/prov#>
prefix dash: <http://datashapes.org/dash#>
prefix dct: <http://purl.org/dc/terms/>
prefix geo: <http://www.opengis.net/ont/geosparql#>
prefix quantitykind: <http://qudt.org/vocab/quantitykind/> 
prefix qudt: <http://qudt.org/schema/qudt/> 
prefix unit: <http://qudt.org/vocab/unit/> 

prefix nen2660: <https://w3id.org/nen2660/def#>
prefix nen2660-term: <https://w3id.org/nen2660/term#>
prefix nen3610: <http://modellen.geostandaarden.nl/def/nen3610-2022#>
prefix nen3610-beg: <http://definities.geostandaarden.nl/nen3610-2022/id/begrip/> 
prefix nen3610-col: <http://definities.geostandaarden.nl/nen3610-2022/id/collectie/>
prefix nen3610-ont: <http://modellen.geostandaarden.nl/def/nen3610/>
prefix nen3610-sh: <http://modellen.geostandaarden.nl/nen3610/id/shape/>
prefix mim: <http://bp4mc2.org/def/mim#>
prefix net: <http://inspire.ec.europa.eu/ont/net#>
prefix tooi-ont: <https://identifier.overheid.nl/tooi/def/ont/>

prefix imbor: <https://data.crow.nl/imbor/def/>
prefix imbor-term: <https://data.crow.nl/imbor/term/>
prefix imbor-refmodels: <https://data.crow.nl/imbor-ref/def/>
prefix imbor-refmodels-id: <https://data.crow.nl/imbor-ref/id/>
prefix imbor-domeinwaarde: <https://data.crow.nl/imbor/id/domeinwaarden/>
prefix imbor-mim: <https://data.crow.nl/imbor/mim/>
prefix imbor-meta: <https://data.crow.nl/imbor/aanvullend-metamodel/>
prefix crow_change: <https://data.crow.nl/change/def/> 
prefix imbor_change_log: <https://data.crow.nl/change/log/imbor/id/> 
prefix restapi: <https://data.crow.nl/rest-api/def#>
prefix coll: <https://data.crow.nl/rest-api/id#>
prefix gwsw: <http://data.gwsw.nl/1.6/totaal/>
prefix sml: <https://w3id.org/sml/def#>

prefix csv: <csv:>

INSERT {
    graph imbor-term: {
        imbor-term:term-schema a skos:ConceptScheme;
            owl:versionInfo "IMBOR2025" ;
            skos:prefLabel "IMBOR Vocabulaire (Begrippenkader voor IMBOR)"@nl ;
            skos:hasTopConcept ?broader ;
            dct:creator "IMBOR - Stichting CROW"@nl ;
            dct:format "SKOS"@nl ;
            dct:language "Nederlands"@nl ;
            dct:description "Vanaf IMBOR2022 is IMBOR gesplitst in een aantal modules. De IMBOR Vocabulaire is er daar eentje van en dit betreft het begrippenkader (of model van begrippen). De vocabulaire bevat 1) de begrippen (concepten), 2) de termen (geprefereerde en alternatieve), 3) de definities, 4) eventuele toelichtingen en 5) een indeling van de begrippen in groepen. Deze afsplitsing is gemaakt zodat de vocabulaire op zichzelf gebruikt kan worden (zonder de uitgebreidere ontologie) en omdat de aanpassingsfrequentie van de ontologie en de vocabulaire kan verschillen. Zo kan er apart van elkaar gewerkt worden. Vanuit de IMBOR Ontologie wordt met rdfs:seeAlso verwezen naar het begrip in deze vocabulaire. Voor meer informatie zie de IMBOR technische documentatie" ;
            .

        ?termURI a skos:Concept ;
            skos:inScheme imbor-term:term-schema ;
            .

        }
}
WHERE {
    ?termURI a skos:Concept .
    OPTIONAL {
        ?termURI skos:broader ?broader .
        filter not exists { ?broader skos:broader ?parent }
    }
}