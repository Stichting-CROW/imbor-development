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
prefix as: <https://www.w3.org/ns/activitystreams/>

prefix csv: <csv:>

INSERT {
   GRAPH <https://data.crow.nl/change/log/imbor> {
        ?loggingUri
            a crow_change:change-item, ?TypeChange ;
            as:to           ?SubjectURI, ?Subject2URI ;
            rdfs:seeAlso    ?githubURL ;
            rdfs:label      ?OmschrijvingNL ;
            as:name         ?OmschrijvingNL ;
            as:summary      ?TerugkoppelingNL ;
            rdfs:comment    ?TerugkoppelingNL ;
            as:published    ?ChangeDateTime ;
            skos:changeNote ?AardAanpassingNL ;
            skos:scopeNote  ?CollectieNL ;
            as:target       ?ToURI ;
            .

    crow_change:change-item    rdfs:subClassOf nen2660:Event ;
                                rdfs:label  "Log-item"@nl, "Change-item"@en .

   }

}
WHERE {
    graph <csv:table/imbor_logging> {
        ?row    csv:LoggingGUID ?LoggingGUID ;
                csv:CollectieID ?CollectieID ;
                csv:StatusID ?StatusID .
        OPTIONAL { ?row csv:VocabulairGUID ?VocabulairGUID .}
        OPTIONAL { ?row csv:IMBORGUID ?IMBORGUID .}
        OPTIONAL { ?row csv:GitHub-issueID ?Github .}
        OPTIONAL { ?row csv:Terugkoppeling ?Terugkoppeling .}
        OPTIONAL { ?row csv:Omschrijving ?Omschrijving .}
        OPTIONAL { ?row csv:Loggingsdatum ?Loggingsdatum .}
        OPTIONAL { ?row csv:AardAanpassing ?AardAanpassing .}
        OPTIONAL { ?row csv:LoggingTypeID ?LoggingType .}
        OPTIONAL { ?row csv:VervangGUID ?VervangGUID .}
    }
        
# TODO: Kijken of dit later nodig is, als de kolom URI gebruikt gaat worden.
    # graph <csv:table/imborVoc_Termen> {
        # ?row1     
    #         csv:VocabulairID ?Vakdiscipline ;
    #         csv:Term ?Term ;
    #         csv:VocabulairGUID ?VocabulairGUID ;
            # csv:IMBORGUID ?IMBORGUID ;
            # csv:Wijzingsdatum ?Wijzingsdatum .
    # }

    graph <csv:table/imbor_loggingStatus> {
        ?row2
            csv:StatusID ?StatusID ;
            csv:StatusGUID ?StatusGUID ;
            csv:Term ?StatusTerm ;
            .
    }

    graph <csv:table/imborVoc_Collecties> {
        ?row3
            csv:CollectieID ?CollectieID ;
            csv:CollectieGUID ?CollectieGUID ;
            csv:Term ?CollectieTerm ;
            .
    }

    BIND (URI(CONCAT(STR("https://data.crow.nl/change/log/imbor/id/"), ?LoggingGUID)) AS ?loggingUri)
    BIND (URI(CONCAT(STR(imbor-term:), ?VocabulairGUID)) AS ?Subject2URI)
    BIND (URI(CONCAT(STR(imbor:), ?IMBORGUID)) AS ?SubjectURI)
    BIND (CONCAT("https://github.com/Stichting-CROW/imbor/issues/", ?Github) AS ?githubURL)
    BIND (STRLANG(?Terugkoppeling, "nl") as ?TerugkoppelingNL)
    BIND (STRLANG(?Omschrijving, "nl") as ?OmschrijvingNL)
    BIND (URI(CONCAT(STR(as:), STR(?StatusTerm))) AS ?TypeChange)
    BIND (STRLANG(?AardAanpassing, "nl") as ?AardAanpassingNL)
    BIND (STRLANG(?CollectieTerm, "nl") as ?CollectieNL)
    BIND (URI(CONCAT(STR(imbor:), ?VervangGUID)) AS ?ToURI)

# DateTime conversion from Access to xsd:data
    BIND(REPLACE(?Loggingsdatum, "^\\w+ (\\w+) (\\d+) (\\d{4}) (\\d{2}:\\d{2}:\\d{2}) GMT\\+(\\d{2})00.*$", "$3-$1-$2T$4+$5:00") AS ?tempDate)
    BIND(IF(CONTAINS(?tempDate, "Jan"), REPLACE(?tempDate, "Jan", "01"),
    IF(CONTAINS(?tempDate, "Feb"), REPLACE(?tempDate, "Feb", "02"),
    IF(CONTAINS(?tempDate, "Mar"), REPLACE(?tempDate, "Mar", "03"),
    IF(CONTAINS(?tempDate, "Apr"), REPLACE(?tempDate, "Apr", "04"),
    IF(CONTAINS(?tempDate, "May"), REPLACE(?tempDate, "May", "05"),
    IF(CONTAINS(?tempDate, "Jun"), REPLACE(?tempDate, "Jun", "06"),
    IF(CONTAINS(?tempDate, "Jul"), REPLACE(?tempDate, "Jul", "07"),
    IF(CONTAINS(?tempDate, "Aug"), REPLACE(?tempDate, "Aug", "08"),
    IF(CONTAINS(?tempDate, "Sep"), REPLACE(?tempDate, "Sep", "09"),
    IF(CONTAINS(?tempDate, "Oct"), REPLACE(?tempDate, "Oct", "10"),
    IF(CONTAINS(?tempDate, "Nov"), REPLACE(?tempDate, "Nov", "11"),
    REPLACE(?tempDate, "Dec", "12"))))))))))))
    AS ?formattedDate)
    BIND(STRDT(?formattedDate, xsd:dateTime) AS ?ChangeDateTime)

  
}