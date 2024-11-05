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
        ?Objecttype1Uri
            a sh:NodeShape ;
            sh:property ?propShapeUri .
        
        ?propShapeUri 
            a sh:PropertyShape ;
            skos:prefLabel ?propDescNL ;
            sh:path ?metaRelatie ;
            sh:qualifiedValueShape [ sh:class ?Objecttype2Uri ] ;
            sh:qualifiedMinCount ?minCount ;
            sh:qualifiedMaxCount ?maxCount ;
            .

        nen2660:hasBoundary rdfs:subPropertyOf geo:hasGeometry 
        .
    }
}
WHERE {
    graph <csv:table/imborKern_K_ObjecttypenSemantischeRelaties> {
        [] csv:IMBORGUID ?IMBORGUID ;
            csv:Multipliciteit ?Multipliciteit ;
            csv:Objecttype1 ?Objecttype1 ;
            csv:SemantischeRelatie ?SemantischeRelatie ;
            csv:Objecttype2 ?Objecttype2 ;
        
        VALUES (?SemantischeRelatie ?metaRelatie ?metaRelatieNL) {
            ( 14525 nen2660:contains "bevat"@nl )
            ( 14526 nen2660:hasPart "heeft deel"@nl )
            ( 14569 nen2660:isConnectedTo "is verbonden met"@nl )
            ( 14596 nen2660:isDescribedBy "is beschreven door"@nl )
            ( 14995 nen2660:executes "voert uit"@nl )
            ( 15169 nen2660:consistsOf "bestaat uit"@nl )
            ( 22458 imbor:heeftBetrekkingOp "heeft betrekking op"@nl )
            ( 22457 imbor:speelt "speelt"@nl )
            ( 22336 net:Link.endNode "endNode"@nl )
            ( 22335 net:Link.startNode "startNode"@nl )
            ( 22298 nen2660:isPartOf "is onderdeel van"@nl )
            ( 21799 nen3610:registratiegegevens "geregistreerd met"@nl )
#            ( 15170 nen2660:hasBoundary "heeft begrenzing"@nl )
        }
        
        values (?Multipliciteit ?minCount ?maxCount) {
            (15167  UNDEF  1     )
            (15168  UNDEF  UNDEF )
            (14518  1      1     )
            (14519  1      UNDEF )
            (16750  UNDEF  2     )
            (16912  2      UNDEF )
        }
### TODO: Gaat dit wel helemaal goed?
        
        graph <csv:table/imborVoc_Termen> {
            [] csv:VocabulairID ?Objecttype1 ;
               csv:Term ?Objecttype1Naam ;
               csv:IMBORGUID ?Objecttype1GUID .
            
            [] csv:VocabulairID ?Objecttype2 ;
               csv:Term ?Objecttype2Naam ;
               csv:IMBORGUID ?Objecttype2GUID .

        }
    }
    
    BIND (URI(CONCAT(STR(imbor:), ?IMBORGUID)) AS ?propShapeUri)
    BIND (CONCAT(?Objecttype1Naam, " ", ?metaRelatieNL, " ", ?Objecttype2Naam) as ?propDesc)
    BIND (STRLANG(?propDesc, "nl") as ?propDescNL)
    BIND (URI(CONCAT(STR(imbor:), ?Objecttype1GUID)) AS ?Objecttype1Uri)
    BIND (URI(CONCAT(STR(imbor:), ?Objecttype2GUID)) AS ?Objecttype2Uri)
}