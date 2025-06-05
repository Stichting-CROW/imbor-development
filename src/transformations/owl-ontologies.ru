# ! Manual adjust versions

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

insert data {
    graph imbor-term: {
        imbor-term: a owl:Ontology ;
            owl:imports nen2660-term: ;
            owl:versionInfo "IMBOR2025" ;
            owl:priorVersion "IMBOR2022" ;
            rdfs:comment "Dit normatieve gedeelte betreft de vocabulaire van IMBOR"@nl ;
            rdfs:label "IMBOR Vocabulaire"@nl .
    }

    graph imbor: {
        imbor: a owl:Ontology ;
            owl:imports nen2660: , sh:, quantitykind: , unit: , imbor-meta:, imbor-term: ;
            owl:versionInfo "IMBOR2025" ;
            owl:priorVersion "IMBOR2022" ;
            rdfs:comment "Dit normatieve gedeelte betreft de kern (de ontologie) van IMBOR"@nl ;
            rdfs:label "IMBOR Kernmodel (ontologie)"@nl .
    }

    graph imbor-domeinwaarde: {
        imbor-domeinwaarde: a owl:Ontology ;
            owl:imports imbor: ;
            owl:versionInfo "IMBOR2025" ;
            owl:priorVersion "IMBOR2022" ;
            rdfs:comment "Dit normatieve gedeelte betreft alle domeinwaarden van IMBOR"@nl ;
            rdfs:label "IMBOR Domeinwaarden"@nl .
    }

    graph imbor-meta: {
        imbor-meta: a owl:Ontology ;
            owl:imports owl:, rdfs:, <https://w3id.org/nen2660/data/concat/nen2660.ttl> ;
            owl:versionInfo "IMBOR2025" ;
            owl:priorVersion "IMBOR2022" ;
            rdfs:comment "Een aantal metaconcepten worden specifiek voor IMBOR gedefinieerd. Dit wordt gedaan middels het 'IMBOR Aanvullend Metamodel'. Dit betreft een kleine ontologie van beschrijfende concepten die er voor zorgen dat alle IMBOR specifieke properties netjes en navolgbaar gedefinieerd zijn."@nl ;
            rdfs:label "IMBOR Aanvullend metamodel"@nl .
    }

    graph <https://data.crow.nl/imbor/addendum/oagbd/> {
        <https://data.crow.nl/imbor/addendum/oagbd/> a owl:Ontology ;
            owl:imports imbor: ;
            owl:versionInfo "IMBOR2025" ;
            owl:priorVersion "IMBOR2022" ;
            rdfs:comment "Dit informatieve gedeelte van IMBOR geeft aan bij elke combinatie van klasse en attribuut in welke fase van de levenscyclus van het object de informatie doorgaans bekend is."@nl ;
            rdfs:label "IMBOR addendum OAGBD"@nl .
    }

    graph <https://data.crow.nl/imbor/addendum/geometrie/> {
        <https://data.crow.nl/imbor/addendum/geometrie/> a owl:Ontology ;
            owl:imports imbor:, geo: ; 
            owl:versionInfo "IMBOR2025" ;
            owl:priorVersion "IMBOR2022" ;
            rdfs:comment "Dit informatieve gedeelte van IMBOR geeft aan welke soort geometrische vastlegging de voorkeur heeft en welke er meer mogelijk zijn."@nl ;
            rdfs:label "IMBOR addendum Geometrie"@nl .
    }

    graph <https://data.crow.nl/imbor/addendum/referentiemodellen/> {
        <https://data.crow.nl/imbor/addendum/referentiemodellen/> a owl:Ontology ;
            owl:imports imbor: ;
            owl:versionInfo "IMBOR2025" ;
            owl:priorVersion "IMBOR2022" ;
            rdfs:comment "Dit informatieve gedeelte van IMBOR bevat de modellen waar vanuit IMBOR aan gerefereerd kan worden. Tevens bevat het waar van toepassing de 'bron' van een IMBOR concept."@nl ;
            rdfs:label "IMBOR addendum Referentiemodellen"@nl .
    }
    
    graph imbor-mim: {
        imbor-mim: a owl:Ontology , mim:Informatiemodel ;
            owl:imports imbor-domeinwaarde:, mim: ;
            owl:versionInfo "IMBOR2025" ;
            owl:priorVersion "IMBOR2022" ;
            rdfs:comment "Dit informatieve gedeelte van IMBOR verrijkt de IMBOR Kern met MIM classificaties en properties. Het is geenszins een volledige MIM 'mapping'. Bijvoorbeeld de relaties tussen MIM metaClass's zijn niet opgenomen."@nl ;
            rdfs:label "IMBOR addendum MIM"@nl ;
            mim:naam "IMBOR addendum MIM"@nl;
            mim:informatiedomein "Beheer openbare ruimte"@nl ;
            mim:mimversie "1.1"@nl ;
            .
    }

     graph <https://data.crow.nl/change/log/imbor/> {
        <https://data.crow.nl/change/log/imbor/> a owl:Ontology ;
            owl:imports imbor-meta: ;
            owl:versionInfo "IMBOR2025" ;
            owl:priorVersion "IMBOR2022" ;
            rdfs:comment "Dit onderdeel van IMBOR beschrijft de complete historie van de changelog."@nl ;
            rdfs:label "IMBOR Change-log"@nl .
    }
}

