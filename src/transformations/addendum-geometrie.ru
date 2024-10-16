# from file imbor/src/transformations/addendum-geometrie.rq
# Target-Graph: <https://data.crow.nl/imbor/def>

prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix nen2660: <https://w3id.org/nen2660/def#>

prefix imbor-term: <https://data.crow.nl/imbor/term/>
prefix imbor: <https://data.crow.nl/imbor/def/>
prefix imbor-refmodels: <https://data.crow.nl/imbor-ref/def/>

prefix dct: <http://purl.org/dc/terms/>
prefix geo: <http://www.opengis.net/ont/geosparql#>
prefix sh:	<http://www.w3.org/ns/shacl#>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix prov: <http://www.w3.org/ns/prov#>
prefix csv: <csv:>

insert {
    graph <https://data.crow.nl/imbor/addendum/geometrie> {
        ?Objecttype1Uri
            a sh:NodeShape ;
            sh:property ?propShapeUri .
        
        ?propShapeUri
            a sh:PropertyShape ;
            skos:prefLabel ?propDesc ;
            sh:path nen2660:hasBoundary ;
            sh:qualifiedValueShape [ sh:class ?Objecttype2Uri ] ;
            sh:qualifiedMinCount ?minCount ;
            sh:qualifiedMaxCount ?maxCount ;
            .
    }
}
WHERE {
    graph <csv:table/imborKern_K_ObjecttypenSemantischeRelaties> {
        [] csv:IMBORGUID ?IMBORGUID ;
            csv:Multipliciteit ?Multipliciteit ;
            csv:Objecttype1 ?Objecttype1 ;
            csv:SemantischeRelatie 15170 ;  # heeft begrenzing
            csv:Objecttype2 ?Objecttype2 .
                
        values (?Multipliciteit ?minCount ?maxCount) {
            (15167  UNDEF  1     )
            (15168  UNDEF  UNDEF )
            (14518  1      1     )
            (14519  1      UNDEF )
            (16750  UNDEF  2     )
            (16912  2      UNDEF )
        }
        
        graph <csv:table/imborVoc_Termen> {
            [] csv:VocabulairID ?Objecttype1 ;
               csv:Term ?Objecttype1Naam ;
               csv:IMBORGUID ?Objecttype1GUID .
            
            [] csv:VocabulairID ?Objecttype2 ;
               csv:Term ?Objecttype2Naam ;
               csv:IMBORGUID ?Objecttype2GUID .

        }
    }
    
    BIND (URI(CONCAT(STR(imbor-refmodels:), ?IMBORGUID)) AS ?propShapeUri)
    BIND (CONCAT(?Objecttype1Naam, " heeft begrenzing ", ?Objecttype2Naam) as ?propDesc)
    BIND (URI(CONCAT(STR(imbor:), ?Objecttype1GUID)) AS ?Objecttype1Uri)
    BIND (URI(CONCAT(STR(imbor:), ?Objecttype2GUID)) AS ?Objecttype2Uri)
}