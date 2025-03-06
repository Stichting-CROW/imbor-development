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
    graph <https://data.crow.nl/imbor/mim> {
        ?MIMDatatype a ?MIMModelDatatype ;
            mim:naam ?MIMModelDatatypeNaam ;
            mim:definitie "Zie corresponderende specificatie"@nl ;
            mim:herkomst ?MIMModelDatatypeHerkomst ;
            mim:locatie ?MIMModelDatatypeHerkomst ;
            .
        
        ?AttributeShape mim:equivalent ?MIMAttribuutSoort .
        ?AttribuutSoort mim:equivalent ?MIMAttribuutSoort .

        ?MIMAttribuutSoort mim:type ?MIMDatatype .
    }
} where {
    GRAPH <https://data.crow.nl/imbor/def/> {
        ?AttribuutSoort a rdf:Property .

        ?AttribuutShape sh:path ?AttribuutSoort ;
                        sh:datatype ?Datatype .
        
         BIND(IF(CONTAINS(STR(?Datatype),"XML"),
                	IRI(REPLACE(STR(?Datatype),"http://www.w3.org/2001/XMLSchema#","https://data.crow.nl/imbor/mim/mim-")),
                		IRI(REPLACE(STR(?Datatype),"http://www.opengis.net/ont/geosparql#","https://data.crow.nl/imbor/mim/mim-"))) AS ?MIMDatatype) 
   		
         VALUES 
            (?MIMDatatype                                           ?MIMModelDatatype       ?MIMModelDatatypeNaam    ?MIMModelDatatypeHerkomst               )
            {   
            (<https://data.crow.nl/imbor/mim/mim-string>             mim:CharacterString    "CharacterString"@nl     "https://www.w3.org/2001/XMLSchema"      )
            (<https://data.crow.nl/imbor/mim/mim-positiveInteger>    mim:Integer            "Integer"@nl             "https://www.w3.org/2001/XMLSchema"      ) 
            (<https://data.crow.nl/imbor/mim/mim-integer>            mim:Integer            "Integer"@nl             "https://www.w3.org/2001/XMLSchema"      ) 
            (<https://data.crow.nl/imbor/mim/mim-decimal>            mim:Decimal            "Decimal"@nl             "https://www.w3.org/2001/XMLSchema"      ) 
            (<https://data.crow.nl/imbor/mim/mim-boolean>            mim:Boolean            "Boolean"@nl             "https://www.w3.org/2001/XMLSchema"      ) 
            (<https://data.crow.nl/imbor/mim/mim-date>               mim:Date               "Date"@nl                "https://www.w3.org/2001/XMLSchema"      ) 
            (<https://data.crow.nl/imbor/mim/mim-dateTime>           mim:DateTime           "DateTime"@nl            "https://www.w3.org/2001/XMLSchema"      ) 
            (<https://data.crow.nl/imbor/mim/mim-gYear>              mim:Year               "Year"@nl                "https://www.w3.org/2001/XMLSchema"      ) 
            (<https://data.crow.nl/imbor/mim/mim-anyURI>             mim:URI                "URI"@nl                 "https://www.w3.org/2001/XMLSchema"      ) 
            (<https://data.crow.nl/imbor/mim/mim-duration>           mim:Datatype           "Datatype"@nl            "https://www.w3.org/2001/XMLSchema"      ) 
# Hier is MIM nog geen standaard Primitief datatype voor. Dit zou eigenlijk wel moeten zijn. Is issue bij MIM. Voor nu zelf converteren naar xsd:duration
            (<https://data.crow.nl/imbor/mim/mim-wktLiteral> 	     mim:CharacterString    "CharacterString"@nl     "http://www.opengis.net/ont/geosparql"   ) 
# In IMBOR volgen wij niet de OGC splitsing. Daarom vertalen we geo:wktLiteral een string. Je kunt de discussie hebben of dit waardevol is, maar volgens mij is het niet ‘fout’.
            }
        }
}
