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
    GRAPH <https://data.crow.nl/imbor/mim> {
        ?MIM_URI	mim:datumOpname	?ChangeDate .
    }
}

WHERE {
    # First subquery: Get MIM URIs and their local names
    {
        SELECT ?MIM_URI ?Type ?MIM_URI_localName WHERE {
            GRAPH <https://data.crow.nl/imbor/mim> {
                ?MIM_URI a ?Type
                VALUES ?Type { 
                    mim:Attribuutsoort
                    mim:Objecttype
                    mim:CharacterString
                    mim:Decimal
                    mim:Integer
                    mim:Boolean
                    mim:Date
                    mim:URI
                    mim:DateTime
                    mim:Year
                    mim:Datatype
                    mim:Enumeratiewaarde
                    mim:Referentielijst
                    mim:Enumeratie
                    mim:Generalisatie
                    mim:ReferentieElement
                }
                # Create normalized local name for matching
                BIND(LCASE(REPLACE(REPLACE(STR(?MIM_URI), "^.*[/#]", ""), "^mim-", "")) AS ?MIM_URI_localName)
            }
        }
    }
    
    # Second subquery: Get IMBOR data with transformed dates
    {
        SELECT ?IMBORGUID ?IMBOR_URI ?IMBOR_URI_localName ?ChangeDate WHERE {
            GRAPH <csv:table/imborVoc_Termen> {
                []  csv:URI ?IMBOR_URI ;
                    csv:IMBORGUID ?IMBORGUID ;
                    csv:Wijzigingsdatum ?Loggingsdatum .
                
                # Create normalized local name for matching (replace by ?IMBORGUID)
                # BIND(LCASE(REPLACE(REPLACE(STR(?IMBOR_URI), "^.*[/#]", ""), "^mim-", "")) AS ?IMBOR_URI_localName)
                
                # Transform date string to standard format
                BIND(REPLACE(?Loggingsdatum, 
                     "^\\w+ (\\w+) (\\d+) (\\d{4}) (\\d{2}:\\d{2}:\\d{2}) GMT\\+(\\d{2})00.*$", 
                     "$3-$1-$2") AS ?tempDate)
                
                # Convert month names to numbers
                BIND(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(
                                                REPLACE(
                                                    REPLACE(
                                                        REPLACE(
                                                            REPLACE(
                                                                REPLACE(?tempDate, 
                                                                    "Dec", "12"),
                                                                "Nov", "11"),
                                                            "Oct", "10"),
                                                        "Sep", "09"),
                                                    "Aug", "08"),
                                                "Jul", "07"),
                                            "Jun", "06"),
                                        "May", "05"),
                                    "Apr", "04"),
                                "Mar", "03"),
                            "Feb", "02"),
                        "Jan", "01"
                    ) AS ?formattedDate)
                
                # Convert to xsd:date
                BIND(STRDT(?formattedDate, xsd:date) AS ?ChangeDate)
            }
        }
    }
    
    # Join the subqueries on local names
    FILTER(?MIM_URI_localName = ?IMBORGUID)
}