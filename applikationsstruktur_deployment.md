# Applikationsstruktur und Deployment
Im Folgenden wird auf die von der Applikation genutzten serverseitigen Komponenten sowie das Deployment 
der Applikation auf Server eingegangen.

## Infrastruktur
Die folgenden Grafik veranschaulicht die Infrastruktur der Applikation:

![Deployment Infrastructure](https://github.com/kaphka/htwmusik/blob/master/bilder/diagramme/htwmusic_deployment_infrastructure.png "Deployment Infrastructure")

Hinter einem Nginx-Webserver, welcher als sogenannter [Reverse Proxy](https://en.wikipedia.org/wiki/Reverse_proxy) agiert, spawnt ein Passenger-Applikationsserver ein Cluster von Instanzen der Rails-Applikation (aktuell der Prototyp).
Passenger kommuniziert Anfragen seitens Nginx an die Clusterinstanzen und liefert deren Antworten wieder an Nginx.

Die Rails-Instanzen haben Zugriff auf das lokale Dateisystem, in welchem die Scans der Katalogkarten gehalten werden.

Die Persistenzschicht des Prototypen basiert zum aktuellen Zeitpunkt noch auf SQLite. SQLite wird allerdings im zweiten Projektsemester wegen Performance und SQL-Sprachumfang durch PostgreSQL ersetzt werden. Es ist geplant, 
zur Volltext-Indizierung und -Suche Elasticsearch einzusetzen.

## Deployment
Die folgende Grafik veranschaulicht die serverseitige Ordnerstruktur des Deployments der Applikation:

![Deployment directory structure](https://github.com/kaphka/htwmusik/blob/master/bilder/diagramme/htwmusic_directory_structure.png "Deployment directory structure")

Die einzelnen Elemente des Directory-Listings sind dabei die folgenden:

|  Name |  Beschreibung|
| ------------ | -------------|
| current | Symlink auf den Ordner, der das aktuelle Release der Applikation beinhaltet |
| last_version | Beinhaltet den Index des aktuellen Releases |
| releases | In diesem Ordner werden die letzten 5 Releases der Applikation vorgehalten. Ein Rollback auf eine vorherige Version ist damit problemlos machbar. |
| scm | Klon des Git-Repositories von [GitHub](https://github.com/albrechtsimon/htwmusic_webapp) |
| shared | Dateien und Verzeichnisse, welche von Release zu Release gleich bleiben (z.B. Konfigurationen oder Assets wie Grafiken) |
| tmp | Temporary files. |
