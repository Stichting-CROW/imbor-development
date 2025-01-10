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

prefix csv: <csv:>

insert data {
    graph <https://data.crow.nl/imbor/aanvullend-metamodel> {
        imbor-refmodels:levensfaseTypering a rdf:Property ;
            skos:prefLabel "typering levensfase"@nl ;
            skos:definition "Dit attribuut is van toepassing op het (O)ntwerp, (A)anleg, (G)eovoorziening, (B)eheer, (D)ynamisch gegeven"@nl ;
            rdfs:range xsd:string ;
            .

        imbor-refmodels:Informatiemodel a rdfs:Class ;
            skos:prefLabel "Informatiemodel"@nl ;
            skos:definition "Externe informatiebron (of ontologie) ten behoeve van IMBOR."@nl ;
            .
        imbor:typeLijst a rdf:Property ;
            skos:prefLabel "open/gesloten"@nl ;
            skos:definition "Of deze lijst een open suggestielijst is of een gesloten enumeratielijst."@nl ;
            rdfs:range xsd:string .

        nen2660:isPartOf a rdf:Property ;
            rdfs:seeAlso nen2660-term:hasPart ;
            skos:definition "A decomposition (isPartOf) relation between concrete concepts"@en, 
                                    "Een decompositie (isPartOf) relatie tussen concrete concepten"@nl ;
            skos:prefLabel "is part of"@en, 
                                    "is deel van"@nl;
            a owl:ObjectProperty ;
            owl:inverseOf nen2660:hasPart ;
            .

        nen2660:isContainedBy a rdf:Property ;
            rdfs:seeAlso nen2660-term:contains ;
            skos:definition "The real objects located in a spatial region, typically the gaseous amount of bulk matter present in that region"@en, 
                                    "De reële objecten die zich in een ruimtelijk gebied bevinden, meestal de gasvormige hoeveelheid bulkmaterie die in dat gebied aanwezig isn"@nl ;
            skos:prefLabel "is containd by"@en, 
                                    "bevindt zich in"@nl;
            a owl:ObjectProperty ;
            owl:inverseOf nen2660:contains ;
            .    

        imbor:speelt a rdf:Property ;
            skos:prefLabel "speelt"@nl ;
            skos:definition "Een relatie die aangeeft dat een Actor een bepaalde Rol op zich neemt of uitvoert."@nl ;
            rdfs:range imbor:Rol ;
            .
            
        imbor:heeftBetrekkingOp a rdf:Property ;
            skos:prefLabel "heeftBetrekkingOp"@nl ;
            skos:definition "Een relatie die aangeeft dat een Rol alleen geldt in de context van een iets specifieks."@nl ;
            rdfs:range nen2660:InformationObject, <http://modellen.geostandaarden.nl/def/nen3610-2022#GeoObject> ;
            .

        imbor:Rol a rdfs:Class ;
            skos:prefLabel "Rol"@nl ;
            skos:definition "Een samenhangende verzameling van verwachtingen, verantwoordelijkheden, bevoegdheden en gedragingen die een Actor kan aannemen in relatie tot iets."@nl ;
            .

        imbor:Actor a rdfs:Class ;
            rdfs:subClassOf nen2660:PhysicalObject ;
            skos:prefLabel "Actor"@nl ;
            skos:definition "Een entiteit die in staat is om handelingen uit te voeren en een specifieke functie of positie te vervullen in een bepaalde context."@nl ;
            .
        
    }
}