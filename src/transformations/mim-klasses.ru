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
    graph <https://data.crow.nl/imbor/mim> {
        ?MIMKlasse a mim:Objecttype ;
            mim:naam ?KlasseNaam ;
            mim:definitie ?KlasseDef ;
            mim:begrip ?Begrip ;
            mim:begripsterm ?BegripsTerm ;
            mim:datumOpname "2023-01-01"^^xsd:date ;
            mim:indicatieAbstractObject ?abstract ;
            .
        
        ?Klasse     mim:equivalent  ?MIMKlasse .
    }
} where {
    GRAPH <https://data.crow.nl/imbor/def/> {
        ?Klasse a rdfs:Class , sh:NodeShape ;
            skos:prefLabel ?KlasseNaam ;
            skos:definition ?KlasseDef ;
            rdfs:seeAlso ?Begrip ;
            dash:abstract ?abstract ;
            .
        BIND(
        IF(
        CONTAINS(STR(?Klasse),STR(nen2660:)),
        IRI(REPLACE(STR(?Klasse),"https://w3id.org/nen2660/def#","https://data.crow.nl/imbor/mim/mim-")),
        IF(
        CONTAINS(STR(?Klasse),STR(nen3610:)), 
        IRI(REPLACE(STR(?Klasse),"http://modellen.geostandaarden.nl/def/nen3610-2022#","https://data.crow.nl/imbor/mim/mim-")),   
        IF(
        CONTAINS(STR(?Klasse),STR(imbor:)),
        IRI(REPLACE(STR(?Klasse),"https://data.crow.nl/imbor/def/","https://data.crow.nl/imbor/mim/mim-")), 
        "?" ))) 
        AS ?MIMKlasse)
        
    }    
    ?Begrip skos:prefLabel ?BegripsTerm . 
}

;

insert {
    graph <https://data.crow.nl/imbor/mim> {
        ?MIMKlasse  mim:herkomstDefinitie "IMBOR - Stichting CROW"@nl ;      
                    mim:herkomst "IMBOR - Stichting CROW"@nl ;
                    mim:locatie "https://data.crow.nl/imbor/def" ;
        .
    }
} where {
    GRAPH <https://data.crow.nl/imbor/def/> {
        ?Klasse a rdfs:Class , sh:NodeShape .
        filter contains(str(?Klasse), str(imbor:))

        BIND(IRI(REPLACE(STR(?Klasse),"https://data.crow.nl/imbor/def/","https://data.crow.nl/imbor/mim/mim-")) AS ?MIMKlasse) 
    }
}

;

insert {
    graph <https://data.crow.nl/imbor/mim> {
        ?MIMKlasse  mim:herkomstDefinitie "NEN3610 - Geonovum"@nl ;
                    mim:herkomst "NEN3610 - Geonovum"@nl ;
                    mim:locatie "http://modellen.geostandaarden.nl/def/nen3610-2022" ;
        .
    }
} where {
    GRAPH <https://data.crow.nl/imbor/def/> {
        ?Klasse a rdfs:Class , sh:NodeShape .
        filter contains(str(?Klasse), str(nen3610:))

        BIND(IRI(REPLACE(STR(?Klasse),"http://modellen.geostandaarden.nl/def/nen3610-2022#","https://data.crow.nl/imbor/mim/mim-")) AS ?MIMKlasse) 
    }
}

;

insert {
    graph <https://data.crow.nl/imbor/mim> {
        ?MIMKlasse  mim:herkomstDefinitie "NEN2660-2 - NEN"@nl ;
                    mim:herkomst "NEN2660-2 - NEN"@nl ;
                    mim:locatie "https://w3id.org/nen2660/def" ;
        .
    }
} where {
    GRAPH <https://data.crow.nl/imbor/def/> {
        ?Klasse a rdfs:Class , sh:NodeShape .
        filter contains(str(?Klasse), str(nen2660:))

        BIND(IRI(REPLACE(STR(?Klasse),"https://w3id.org/nen2660/def#","https://data.crow.nl/imbor/mim/mim-")) AS ?MIMKlasse) 
    }
}

;
# Relatie tussen Klasse en Attribuut
insert { 
    graph <https://data.crow.nl/imbor/mim> {
        ?MIMKlasse  mim:attribuut   ?MIMAttribuutSoort .
        
    }
} where {
    GRAPH <https://data.crow.nl/imbor/def/> {
        ?Klasse a rdfs:Class , sh:NodeShape ;
                sh:property ?PropertyShape .
        ?PropertyShape  sh:path ?AttribuutSoort .
		FILTER (!CONTAINS(str(?AttribuutSoort),"nen2660"))
        # Om alleen attributen er uit te halen (geen relaties)

        BIND(IRI(REPLACE(STR(?Klasse),"https://data.crow.nl/imbor/def/","https://data.crow.nl/imbor/mim/mim-")) AS ?MIMKlasse) 
        BIND(IRI(REPLACE(STR(?AttribuutSoort),"https://data.crow.nl/imbor/def/","https://data.crow.nl/imbor/mim/mim-")) AS ?MIMAttribuutSoort)  
    }
}