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
        "c3738d97-b2cb-4d42-90cd-0f498c480f6b", # heeftBetrekkingOp
        "da56fc52-a539-45d4-b685-39c17808cf51", # Rol
        "d14864e0-6fe3-4c51-927f-f0152446e731", # speelt
        "0eb6a9ef-d74c-48a9-a3c2-1ce07913168e", # Collectie Multipliciet
        "732e2e6b-aebc-466c-865b-ea9f8cf7f951", # Collectie Multipliciet
        "be7f3569-dcd7-4c80-b59e-e790f1cc79de", # Collectie Multipliciet
        "6a1e0a67-5642-4a54-9dc6-422dfa78ed6e", # Collectie Multipliciet
        "5e758734-951a-451b-bc0b-27d1956b85cf", # Collectie Multipliciet
        "370fffbf-fb97-4257-899f-b367cd2e28e5", # Collectie Multipliciet
        "0b5aeb0e-d549-47c9-87ae-bc61fda57e03", # Enumeratie
        "bf384130-de78-44de-b205-02040c48b591", # Referentie
        "540f5974-5601-4d4a-9ee9-6e1227c09317", # Abstract
        "8e5725bc-3216-4a13-893c-482e62f734a9"  # Conreet
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