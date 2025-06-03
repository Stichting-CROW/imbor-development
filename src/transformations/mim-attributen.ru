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
    graph <https://data.crow.nl/imbor/mim/> {
        ?MIMAttribuutSoort a mim:Attribuutsoort ;
            mim:naam ?AttribuutNaam ;
            mim:definitie ?AttribuutDef ;
            mim:begrip ?Begrip ;
            mim:begripsterm ?BegripsTerm ;
            mim:herkomst "IMBOR - Stichting CROW"@nl ;
            mim:herkomstDefinitie "IMBOR - Stichting CROW"@nl ;
            mim:indicatieClassificerend ?Identificerend ;
            mim:kardinaliteit ?Kardinaliteit ;
            mim:eenheid ?unit ;
            mim:locatie "https://data.crow.nl/imbor/def" ;
            .
        
        ?AttributeShape mim:equivalent ?MIMAttribuutSoort .
        ?AttribuutSoort mim:equivalent ?MIMAttribuutSoort .

        ?MIMAttribuutSoort  mim:type   ?MIMDatatype, ?MIMEnumeratieType  .

    }
} where {
    GRAPH <https://data.crow.nl/imbor/def/> {
        ?AttribuutSoort a rdf:Property ;
            skos:prefLabel ?AttribuutNaam ;
            skos:definition ?AttribuutDef ;
            rdfs:seeAlso ?Begrip ;
            .
        
        BIND(
        IF(
        CONTAINS(STR(?AttribuutSoort),STR(nen2660:)),
        IRI(REPLACE(STR(?AttribuutSoort),"https://w3id.org/nen2660/def#","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?AttribuutSoort),STR(nen3610:)), 
        IRI(REPLACE(STR(?AttribuutSoort),"http://modellen.geostandaarden.nl/def/nen3610-2022#","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?AttribuutSoort),STR(tooi-ont:)),
        IRI(REPLACE(STR(?AttribuutSoort),"https://identifier.overheid.nl/tooi/def/ont/","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?AttribuutSoort),STR(net:)),
        IRI(REPLACE(STR(?AttribuutSoort),"http://inspire.ec.europa.eu/ont/net#","https://data.crow.nl/imbor/mim/mim-")),      
        IF(
        CONTAINS(STR(?AttribuutSoort),STR(gwsw:)),
        IRI(REPLACE(STR(?AttribuutSoort),"http://data.gwsw.nl/1.6/totaal/","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?AttribuutSoort),STR(sml:)),
        IRI(REPLACE(STR(?AttribuutSoort),"https://w3id.org/sml/def#","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?AttribuutSoort),STR(imbor:)),
        IRI(REPLACE(STR(?AttribuutSoort),"https://data.crow.nl/imbor/def/","https://data.crow.nl/imbor/mim/mim-")), 
        "?" )))))))
        AS ?MIMAttribuutSoort)


        OPTIONAL    {?AttribuutShape sh:path ?AttribuutSoort .
        BIND(
            IF(?AttribuutSoort = imbor:e3e112b3-e46f-45c4-b2c9-b152e6f805a1, true, false)
            AS ?Identificerend)
                   }

        OPTIONAL {?AttribuutShape sh:minCount ?shmin}.
        OPTIONAL {?AttribuutShape sh:maxCount ?shmax}.
        OPTIONAL {?AttribuutShape sh:qualifiedMinCount ?shqmin}.
        OPTIONAL {?AttribuutShape sh:qualifiedMaxCount ?shqmax}.
        OPTIONAL {?AttribuutShape qudt:hasUnit ?unit}.
        BIND(COALESCE(?shmin,?shqmin,0) AS ?min)
        BIND(COALESCE(?shmax,?shqmax,"*") AS ?max)
        BIND(CONCAT(STR(?min),"..",STR(?max)) AS ?Kardinaliteit)
        
        OPTIONAL {?AttribuutShape sh:datatype      ?Datatype}.
        OPTIONAL {?AttribuutShape sh:qualifiedValueShape/sh:class      ?EnumeratieType}.

        BIND(
        IF(
        CONTAINS(STR(?EnumeratieType),STR(nen2660:)),
        IRI(REPLACE(STR(?EnumeratieType),"https://w3id.org/nen2660/def#","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?EnumeratieType),STR(nen3610:)), 
        IRI(REPLACE(STR(?EnumeratieType),"http://modellen.geostandaarden.nl/def/nen3610-2022#","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?EnumeratieType),STR(tooi-ont:)),
        IRI(REPLACE(STR(?EnumeratieType),"https://identifier.overheid.nl/tooi/def/ont/","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?EnumeratieType),STR(net:)),
        IRI(REPLACE(STR(?EnumeratieType),"http://inspire.ec.europa.eu/ont/net#","https://data.crow.nl/imbor/mim/mim-")),      
        IF(
        CONTAINS(STR(?EnumeratieType),STR(gwsw:)),
        IRI(REPLACE(STR(?EnumeratieType),"http://data.gwsw.nl/1.6/totaal/","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?EnumeratieType),STR(imbor:)),
        IRI(REPLACE(STR(?EnumeratieType),"https://data.crow.nl/imbor/def/","https://data.crow.nl/imbor/mim/mim-")), 
        "?" ))))))
        AS ?MIMEnumeratieType)  

        BIND(IF(CONTAINS(STR(?Datatype),"XML"),
                	IRI(REPLACE(STR(?Datatype),"http://www.w3.org/2001/XMLSchema#","https://data.crow.nl/imbor/mim/mim-")),
                		IRI(REPLACE(STR(?Datatype),"http://www.opengis.net/ont/geosparql#","https://data.crow.nl/imbor/mim/mim-"))) AS ?MIMDatatype) 
        
        }

    ?Begrip skos:prefLabel ?BegripsTerm .
}
