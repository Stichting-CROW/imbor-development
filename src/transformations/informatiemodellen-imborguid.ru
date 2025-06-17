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

insert {
    graph <https://data.crow.nl/imbor/addendum/referentiemodellen/> {
        ?SubjectURI dct:source  ?imUri .
    }
} 
WHERE {
    ?row csv:Informatiemodel ?refInformatiemodelID ;
         csv:IMBORGUID ?IMBORGUID .
    
    FILTER(?IMBORGUID NOT IN (
        "c3738d97-b2cb-4d42-90cd-0f498c480f6b",
        "da56fc52-a539-45d4-b685-39c17808cf51", 
        "d14864e0-6fe3-4c51-927f-f0152446e731"
    ))
    
    # Exclude rows that exist in imborKern_EnumeratiesDomeinwaarden
    FILTER NOT EXISTS {
        GRAPH <csv:table/imborKern_EnumeratiesDomeinwaarden> {
            ?row ?anyPred ?anyObj .
        }
    }
    
    GRAPH <csv:table/refModel_Informatiemodellen> {
        ?im csv:refInformatiemodelID ?refInformatiemodelID ;
            csv:refInformatiemodelGUID ?refInformatiemodelGUID .
    }
    
    OPTIONAL { ?row csv:Collectie ?col . }
    OPTIONAL { ?row csv:SemantischeRelatie ?semRel . }
    
    BIND(URI(CONCAT(STR(imbor-refmodels-id:), ?refInformatiemodelGUID)) AS ?imUri)
    
    BIND(
        IF(BOUND(?semRel) && ?semRel = 15170, 
            URI(CONCAT(STR(imbor-refmodels:), ?IMBORGUID)),
            IF(BOUND(?col) && ?col = 4, 
                URI(CONCAT(STR(imbor-domeinwaarde:), ?IMBORGUID)), 
                URI(CONCAT(STR(imbor:), ?IMBORGUID))
            )
        ) AS ?SubjectURI
    )
}