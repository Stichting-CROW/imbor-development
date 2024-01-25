# IMBOR 'data (Producten)
In deze folder staan alle data bestanden van IMBOR.
Er is voor gekozen om de AccessDB en de TTL files in een ZIP file te distribueren en niet als losse files (middels .gitignore worden deze gefilterd). 

Deze ZIP files moeten dus handmatig gemaakt worden en geüpload worden naar https://github.com/Stichting-CROW/imbor/tree/master/data indien er een nieuwe versie is. 

## REST-API toevoeging
De 'IMBOR-REST-API-linkset' is de uitzondering omdat deze _geen_ onderdeel is van de IMBOR producten, maar wel nodig is voor de query's die in de REST-API beschikbaar zijn. Omdat het hostingplatform van het SPARQL-endpoint geen grafen onderscheidt, maar die voor sommige queries toch handig zijn, wordt herkomst/verie-info bewaard in dit bestand / deze losse graaf. Dit is dus alleen nodig voor de query's op de REST-API, niet voor de directe connectie op het SPARQL-endpoint.

Deze moeten dus ook handmatig geüpload worden naar dezelfde folder.

