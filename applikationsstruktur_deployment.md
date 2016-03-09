# Applikationsstruktur und Deployment
Im Folgenden wird auf die von der Applikation genutzten serverseitigen Komponenten sowie das Deployment 
der Applikation auf Server eingegangen.

## Infrastruktur
Die folgenden Grafik veranschaulicht die Infrastruktur der Applikation:

![Deployment Infrastructure](https://github.com/kaphka/htwmusik/blob/master/bilder/diagramme/htwmusic_deployment_infrastructure.png "Deployment Infrastructure")

Hinter einem Nginx-Webserver, welcher als sogenannter [Reverse Proxy](https://en.wikipedia.org/wiki/Reverse_proxy) agiert, spawnt ein Passenger-Applikationsserver ein Cluster von Instanzen der Rails-Applikation (aktuell der Prototyp).
Passenger kommuniziert Anfragen seitens Nginx an die Clusterinstanzen und liefert deren Antworten wieder an Nginx.

Die Railsinstanzen haben Zugriff auf das lokale Dateisystem, in welchem die Scans der Katalogkarten gehalten werden.

Die Persistenzschicht des Prototypen basiert zum aktuellen Zeitpunkt noch auf SQLite. SQLite wird allerdings im zweiten Projektsemester wegen Performance und SQL-Sprachumfang durch PostgreSQL ersetzt werden. Es ist geplant, 
zur Volltext-Indizierung und -Suche Elasticsearch einzusetzen.

## Deployment

![Deployment directory structure](https://github.com/kaphka/htwmusik/blob/master/bilder/diagramme/htwmusic_directory_structure.png "Deployment directory structure")

