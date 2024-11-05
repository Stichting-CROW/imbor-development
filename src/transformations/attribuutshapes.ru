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
prefix restapi: <https://data.crow.nl/rest-api/def#>
prefix coll: <https://data.crow.nl/rest-api/id#>

prefix csv: <csv:>

insert {
    graph imbor: {
        ?propShapeUri
            a sh:PropertyShape ;
            sh:path ?attribuutUri ;
            ?QminCount ?minCount ;
            ?QmaxCount ?maxCount ;
            skos:prefLabel ?propDescNL ;
            sh:datatype ?shDatatype ;
            .
        
        ?klasseUri
            a sh:NodeShape ;
            sh:property ?propShapeUri ;
            .
    }
}
WHERE {
    graph <csv:table/imborKern_K_KlassenAttributen> {
        [] csv:Attribuut ?Attribuut ;
            csv:IMBORGUID ?IMBORGUID ;  # guid van de property shape
#            csv:KlasseAttribuutID ?KlasseAttribuutID ;
            csv:Klasse ?Klasse ;
            csv:Multipliciteit ?Multipliciteit ;
#            csv:Informatiemodel ?Informatiemodel ;
        	.
        
        values (?Multipliciteit ?minCount ?maxCount) {
            (15167  UNDEF  1     )
            (15168  UNDEF  UNDEF )
            (14518  1      1     )
            (14519  1      UNDEF )
            (16750  UNDEF  2     )
            (16912  2      UNDEF )
        }
        
        graph <csv:table/imborVoc_Termen> {
            [] csv:VocabulairID ?Attribuut ;
               csv:Term ?AttribuutNaam ;
               csv:IMBORGUID ?AttribuutGUID .
            
            [] csv:VocabulairID ?Klasse ;
               csv:Term ?KlasseNaam ;
               csv:IMBORGUID ?KlasseGUID .
            
            graph <csv:table/imborKern_Attributen> {
                [] csv:Attribuut ?Attribuut ;
					csv:Datatype ?DataType ;
     				.
                
                VALUES ( ?DataType ?shDatatype ) {
                    ( 14538  geo:wktLiteral )
                    ( 14579  xsd:anyURI )
                    ( 14580  xsd:boolean )
                    ( 14581  xsd:date )
                    ( 14582  xsd:dateTime )
                    ( 14583  xsd:decimal )
                    ( 14584  xsd:duration )
                    ( 14585  xsd:gYear )
                    ( 14586  xsd:positiveInteger )
                    ( 14587  xsd:string )
                    ( 21778  xsd:integer )
                }
            }
        }
    }

    BIND(IF(BOUND(?shDatatype), sh:minCount, sh:qualifiedMinCount) AS ?QminCount)
    BIND(IF(BOUND(?shDatatype), sh:maxCount, sh:qualifiedMaxCount) AS ?QmaxCount)
    
    BIND (URI(CONCAT(STR(imbor:), ?IMBORGUID)) AS ?propShapeUri)
    BIND (URI(CONCAT(STR(imbor:), ?AttribuutGUID)) AS ?attribuutUri)
    BIND (URI(CONCAT(STR(imbor:), ?KlasseGUID)) AS ?klasseUri)
    BIND (CONCAT(?AttribuutNaam, " vastgezet op ", ?KlasseNaam) as ?propDesc)

    BIND (STRLANG(?Term, "nl") as ?TermNL)
    BIND (STRLANG(?Definitie, "nl") as ?DefinitieNL)
    BIND (STRLANG(?AttribuutTypeTerm, "nl") as ?AttribuutTypeTermNL)
    BIND (STRLANG(?propDesc, "nl") as ?propDescNL)
}