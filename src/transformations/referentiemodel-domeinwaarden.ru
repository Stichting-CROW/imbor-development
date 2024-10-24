prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix nen2660: <https://w3id.org/nen2660/def#>

prefix imbor-term: <https://data.crow.nl/imbor/term/>
prefix imbor: <https://data.crow.nl/imbor/def/>
prefix imbor-refmodels: <https://data.crow.nl/imbor-ref/def/>
prefix imbor-refmodels-id: <https://data.crow.nl/imbor-ref/id/>

prefix dct: <http://purl.org/dc/terms/>
prefix geo: <http://www.opengis.net/ont/geosparql#>
prefix sh:	<http://www.w3.org/ns/shacl#>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix prov: <http://www.w3.org/ns/prov#>
prefix csv: <csv:>

insert {
    graph <https://data.crow.nl/imbor/addendum/referentiemodellen> {
        ?uri
            a imbor-refmodels:RefDomeinwaarde ;
            skos:prefLabel ?refDomeinwaardeNL ;
            skos:definition ?DefinitieNL ;
            skos:note ?ToelichtingNL ;
            dct:source ?imUri ;
            rdfs:seeAlso ?uriAnyUri ;
    }

} where {
    graph <csv:table/refModel_Domeinwaarden> {
        ?dw # csv:refAttribuut ?refAttribuut ;
            csv:refInformatiemodel ?refInformatiemodel ;
            csv:refDomeinwaardeGUID ?refDomeinwaardeGUID ;
            csv:refDomeinwaarde ?refDomeinwaarde ;
            # csv:refBovenliggendeWaarde ?refBovenliggendeWaarde .

        optional { ?dw csv:Toelichting ?Toelichting . }
        optional { ?dw csv:URI ?URI . }
        optional { ?dw csv:Definitie ?Definitie . } 

        filter (?refInformatiemodel != 15)  # QUDT wordt reeds anders verwerkt

        BIND ( STRLANG(?refDomeinwaarde, "nl") as ?refDomeinwaardeNL )
        BIND ( STRLANG(?Toelichting, "nl") as ?ToelichtingNL )
        BIND ( STRLANG(?Definitie, "nl") as ?DefinitieNL )
        BIND ( STRDT(?URI, xsd:anyURI) as ?uriAnyUri )
        BIND (URI(CONCAT(STR(imbor-refmodels-id:), ?refDomeinwaardeGUID)) AS ?uri)
    }

    graph <csv:table/refModel_Informatiemodellen> {
        ?im csv:refInformatiemodelGUID ?refInformatiemodelGUID ;
            csv:refInformatiemodelID ?refInformatiemodel .

        BIND (URI(CONCAT(STR(imbor-refmodels-id:), ?refInformatiemodelGUID)) AS ?imUri)
    }

}
