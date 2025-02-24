# Target-Graph: <https://data.crow.nl/imbor/def>
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

prefix csv: <csv:>

INSERT {
    GRAPH imbor: {
        ?childUri ?rdfsProperty ?parentUri .
    }
}
WHERE {
    graph <csv:table/imborKern_Hierarchie> {
        [] csv:Parent ?Parent ;
           csv:Child ?Child ;
           csv:HierarchieType ?HierarchieType .

            VALUES (?HierarchieType ?rdfsProperty) {
            ("Klasse" rdfs:subClassOf )
            ("Functie" rdfs:subClassOf )
            ("Materie" rdfs:subClassOf )
            ("Rol" rdfs:subClassOf )
            ("Eigenschap" rdfs:subPropertyOf )
            ("Semantische relatie" rdfs:subPropertyOf )
        }
    }

    graph <csv:table/imborKern_HierarchieElementen> {
        [] csv:HierarchieElementID ?Parent ;
            csv:HierarchieElement ?parentVocabID .

        [] csv:HierarchieElementID ?Child ;
            csv:HierarchieElement ?childVocabID .
    }

    graph <csv:table/imborVoc_Termen> {
        [] csv:VocabulairID ?parentVocabID ;
           csv:IMBORGUID ?IMBORGUIDParent .

        [] csv:VocabulairID ?childVocabID ;
           csv:IMBORGUID ?IMBORGUIDChild .

        BIND (URI(CONCAT(STR(imbor:), ?IMBORGUIDParent)) AS ?parentUri)
        BIND (URI(CONCAT(STR(imbor:), ?IMBORGUIDChild)) AS ?childUri)
    }
}
