<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Anforderungen der Applikation](#anforderungen-der-applikation)
	- [Hardware](#hardware)
		- [System 1: Deployment](#system-1-deployment)
		- [System 2: Development](#system-2-development)
	- [Software](#software)
	- [Installation](#installation)
	- [Konfiguration](#konfiguration)
	- [Bootstrap](#bootstrap)
	- [Infrastruktur](#infrastruktur)
- [Frontend](#frontend)
	- [Aufbau](#aufbau)
	- [Gestaltung](#gestaltung)
	- [Komponenten](#komponenten)
	- [Dashboard](#dashboard)
	- [Filterungslisten](#filterungslisten)
	- [Kartenübersicht](#kartenübersicht)
		- [Felderübersicht](#felderübersicht)
	- [Korrektur](#korrektur)
- [Jobs System](#jobs-system)
	- [Vorraussetzungen](#vorraussetzungen)
		- [Redis](#redis)
		- [Resque](#resque)
		- [Datenbankadapter](#datenbankadapter)
	- [Überblick](#überblick)
		- [CardFactory](#cardfactory)
		- [ExternalWorkLookup](#externalworklookup)
		- [ExternalInterpreterLookup](#externalinterpreterlookup)
		- [SignatureLookup](#signaturelookup)
		- [FieldReplacer](#fieldreplacer)
		- [JobCreator](#jobcreator)
		- [AcronymReplacer](#acronymreplacer)
		- [DataCrawler](#datacrawler)
- [Korrekturalgorithmus](#korrekturalgorithmus)
- [Konvertierung der Datenquellen](#konvertierung-der-datenquellen)
	- [[nbconv](https://github.com/kaphka/nbconv)](#nbconvhttpsgithubcomkaphkanbconv)
	- [[labelconv](https://github.com/kaphka/labelconv)](#labelconvhttpsgithubcomkaphkalabelconv)
	- [[semconv](https://github.com/kaphka/semconv)](#semconvhttpsgithubcomkaphkasemconv)
	- [[catconv](https://github.com/kaphka/catconv)](#catconvhttpsgithubcomkaphkacatconv)
- [Verbesserungen](#verbesserungen)
	- [Accountmanagement](#accountmanagement)
	- [Bildscrolling und 16:9](#bildscrolling-und-169)
	- [Korrekturalgorithmus](#korrekturalgorithmus)
	- [Spracherkennung](#spracherkennung)
	- [Gewichtung von Treffern](#gewichtung-von-treffern)
	- [Mehr Daten](#mehr-daten)
	- [Nutzen anderer Systeme zum Abgleich](#nutzen-anderer-systeme-zum-abgleich)
	- [Rückfluss von Daten aus dem Frontend](#rückfluss-von-daten-aus-dem-frontend)
	- [Modularität](#modularität)
	- [Datenbasis und Datenverarbeitung](#datenbasis-und-datenverarbeitung)
	- [Signaturgenauigkeit](#signaturgenauigkeit)
	- [Schnittstellen](#schnittstellen)
	- [Nutzung der Daten](#nutzung-der-daten)
- [Meilensteine](#meilensteine)
	- [OCR](#ocr)
	- [Korrektur](#korrektur)
- [Ergebnisse](#ergebnisse)

<!-- /TOC -->

# Anforderungen der Applikation
Im folgenden soll kurz auf die hard- und softwareseitigen Anforderungen der Applikation eingegangen werden.

## Hardware
Es wurde während der Entwicklung des Systems auf zwei Systemen folgender Spezifikationen gearbeitet:

### System 1: Deployment
| Bauteil |  Beschreibung |
| ------------ | -------------|
| CPU | Intel Xeon E3-1225 V2 @3.20GHz (Quad Core) |
| RAM | 16GB |
| Festspeicher | 2TB HDD |

### System 2: Development
| Bauteil |  Beschreibung |
| ------------ | -------------|
| CPU | Intel Core I7  @3.40GHz (Quad Core mit Hyper-Threading) |
| RAM | 24GB |
| Festspeicher | 250GB Samsung 850 EVO SSD |

Beide Systeme wurden zum Import und zur Aufbereitung der Daten genutzt und liefen zufriedenstellend.

Für den Produktiveinsatz mit dem Komplettsatz der Daten wäre allerdings mehr CPU-Leistung (mehr Kerne) sinnvoll, da die Import- und Korrekturprozesse auf den beiden oben gezeigten Systemen eher lange liefen.
Aufgrund der hohen IO-Last während der Import- und Korrekturschritte des Sytems ist eine SSD einer normalen Festplatte vorzuziehen.

## Software
Wie in einem der Meetings des zweiten Projektsemesters vereinbart, ist die Applikation sowie alle ihre Komponenten
vollständig kompatibel zur Linuxdistribution Debian 8 (Jessie).

## Installation
Schritte zur einfachen Installation der Applikation auf einem Debian-System als user `root`:

1. `wget https://raw.githubusercontent.com/albrechtsimon/htwmusic_webapp/master/puppet/bootstrap.sh`
2. `bash bootstrap.sh`
3. `git clone https://github.com/albrechtsimon/htwmusic_webapp.git`
4. `cd htwmusic_webapp/puppet`
5. `puppet apply --modulepath=./modules site.pp`

Nach diesen Schritten sollte die Applikation via `http://server_name` erreichbar sein.

## Konfiguration
Die Applikation ist mittels einer [Konfigurationsdatei](https://github.com/albrechtsimon/htwmusic_webapp/blob/master/config/app.yml)
auf das jeweilige System anpassbar. Die folgende Tabelle beschreibt die Konfigurationsvariablen:

| Variable |  Beschreibung |
| ------------ | -------------|
| `acronyms_path`  | Pfad zu einer CSV-Datei, welche Abkürzungen sowie deren Langform enthält |
| `raw_data_path` | Pfad zu einem Ordner, welcher Dateien in der Ordnerstruktur und im Format der OCR-Tools enthält  |
| `words_path` | Pfad zu einem Ordner, der Text-Dateien mit einem Wort pro Zeile enthält |
| `musical_works_path` | Pfad zu einer CSV-Datei, die Werke enthält |
| `people_path` | Pfad zu einer CSV-Datei, die Personen enthält |
| `debug_output` | Boolean. Gibt an, ob die Applikation beim Importprozess Debuginformationen ausgeben soll oder nicht |
| `data_limit` | Ganzzahl. Beschreibt, nach wie vielen Records der Datenimport beendet werden soll. |

Die Stammdaten für die Pfade in der Konfiguration, die während der Entwicklung verwendet worden sind, sind [hier](https://github.com/albrechtsimon/htwmusic_webapp/blob/master/lib/base_data.zip) auffindbar.

## Bootstrap
Sobald die im vorangehenden Abschnitt vorgestellten Konfigurationsparameter gesetzt sind und die Applikation wie oben beschrieben installiert worden ist,
kann ein (in diesem Falle synchroner) Import wie folgt angestoßen werden:

1. `su - htwmusic`
2. `cd htwmusic_webapp`
3. `export RAILS_ENV=production`
4. `bundle exec rake bootstrap`

Sollte ein reiner Import ohne Lauf des Korrekturalgorithmus gewünscht sein, sollte als vierter Punkt stattdessen `bundle exec rake bootstrap2` ausgeführt werden.

## Infrastruktur
Die Hauptapplikation, welche auf Basis von Ruby on Rails 4 entwickelt worden ist, interagiert mit mehreren anderen Softwarekomponenten. Die Struktur während der
Entwicklungsphase sowie die Deployment-Infrastruktur während der Entwicklung (kann in einem separaten Dokument betrachtet werden)[applikationsstruktur_deployment.md].

Nach dem zeiten Projektsemester sieht die Infrastuktur der Softwarekomponenten wiefolgt aus:

![Infrastructure](https://raw.githubusercontent.com/kaphka/htwmusik/master/bilder/diagramme/infrastructure_new.png "Infrastructure")


| Komponente |  Aufgabe | Konfiguration |
| ------------ | -------------|------------|
| Nginx        | Anlaufpunkt der Webapplikation, Reverse Proxy zu Passenger | `/etc/nginx/` |
| Passenger    | Applikationsserver  | Commandline-Argumente, änderbar [hier](https://github.com/albrechtsimon/htwmusic_webapp/blob/master/puppet/site.pp#L113) |
| Ruby on Rails  | Applikationsframework | Konfigurationsdateien. Zu finden [hier](https://github.com/albrechtsimon/htwmusic_webapp/tree/master/config) |
| ElasticSearch | Volltextindizes, Wortkorrektur | Das System nutzt aktuell die default Konfiguration von ElasticSearch. Falls notwendig ist diese anpassbar in `/etc/elasticsearch/elasticsearch.yml` |
| PostgreSQL | Persistenzschicht der Rails-Applikation | PostgreSQL nutzt seine Standardkonfiguration. Anpassungen möglich in `/etc/postgresql/$version/main/` |
| Redis | Speicherort für Queues | Redis nutzt ebenfalls die Standardkonfiguration. Anpassungen möglich in `/etc/redis` |

# Frontend

## Aufbau
Die Basis für das Frontend bildet Rails. Rails dient einerseits als Backend und stellt mit der verwendeten Templateengine ERB alle Ansichten dar. ERB umfasst eine Templatesyntax, welche durch viele Funktionen und Modulen die Entwicklung vereinfacht. Für den Nutzer werden die entsprechenden Daten aufbereitet und abschließend ausgeliefert. Hierbei sind weitere Technologien eingebunden wie u.a. Bootstrap.

## Gestaltung
Die Gestaltung des Frontend orientiert sich einerseits an der Farbgebung der Webseite der Staatsbibliothek zu Berlin, andererseits an einer einfachen Tasterturgebundenen Bedienung.

## Komponenten
Das Frontend setzt sich aus drei Komponenten zusammen, die im Nachfolgenden Abschnitt näher erläutert werden.

##Dashboard
Das Dashboard bildet den Einstieg in die Applikation, in diesem werden alle Kartenzustände grafisch dargestellt.

![Dashboard](https://raw.githubusercontent.com/kaphka/htwmusik/master/bilder/dashboard.jpg "Dashboard")

1. Schnellauswahl für die Filterlisten
2. Grafische Darstellung der Karten Status
3. Übersicht der Karten

##Filterungslisten
In der Listenübersicht kann nach Inhalten von Karten gesucht werden, um thematisch zusammenhängende Karten zu finden.

![Filterliste](https://raw.githubusercontent.com/kaphka/htwmusik/master/bilder/liste.jpg "Filterliste")

1. Suchen nach Kartennummern
2. Suche für die OCR-Texte
3. Kartenvorschau
4. Kartennummer
5. Status der Karte

##Kartenübersicht
Die Kartenübersicht bildet alle gefundenen und verarbeiteten  Daten ab. Diese werden in zwei verschiedenen Ansichten präsentiert, um die Übersicht zu gewährleisten.
 
###Felderübersicht
Hier werden alle wichtigen Kartendaten angezeigt, dazu gehören die Karte selbst, sowie der erkannte OCR-Text.

![Frontend 1](https://raw.githubusercontent.com/kaphka/htwmusik/master/bilder/frontend.jpg "Frontend 1")

1. Auswahl der derzeitigen Übersicht
2. Status der derzeitigen Karte
3. Aus der OCR erfasster Text
4. Bild der Karte
5. Der aus der OCR gelesene Textabschnitt
6. Gefundene Korrektur
7. Typ aus der Katalogübersicht
8. Status des Feldes
9. Speichern oder Löschen von Feldern
10. Erzeugen eines neuen Feldes
11. Speichern der derzeitigen Änderungen
12. Speichern der derzeitigen Änderungen und Versiegeln der Karte

## Korrektur
Der Korrketurtab zeigt alle Änderungen die durch die Korrektur automatisch verarbeitet wurden. Hier ist ersichtlich aus welchen Verzeichnissen die gefundenen Daten erzeugt wurden und weshalb die Änderungen übernommen wurden.

![Korrektur](https://raw.githubusercontent.com/kaphka/htwmusik/master/bilder/korrektur.jpg "Korrektur")

1. Karte
2. Unkorregierter OCR-Text
3. Text nach der Korrektur
4. Teilstück das als Korrekturvorlage diente
5. Korrektur des Teilstückes
6. Basis, auf dessen Grundlage das Teilstück korrigiert wurde



# Jobs System
Aufgrund der Anzahl der zu bearbeiteten Karten war es sinnvoll ein Job System einzuführen, welches in Teilen eingesetzt wurde.
Die Grundlage dafür bildet Resque, ein Queue System von GitHub https://github.com/resque/resque. Die nötigen Bestandteile von  Resque können durch entsprechende Gems in Rails integriert werden und sind so in der Lage auf entsprechende Ressourcen zuzugreifen.
Hierfür werden Jobs entsprechend der Definition erzeugt und können dann von Workern abgearbeitet werden. Die hierfür nötigen Informationen werden in Redis abgelegt.

[Link: Tabelle zur Beschreibung der Jobs](https://docs.google.com/spreadsheets/d/1IwCB8zNoQtqFbDTImsw28fltzyr2qQ-UGqOYK2JXJtU/edit#gid=0)

###Vorraussetzungen
Für die Nutzung der Jobs sind folgende Bestandteile notwendig.

####Redis
Redis ist eine in-memory Datenstruktur die auf einem einfachen Key-Value Cache basiert. In diesem werden die Jobs mit ihren Parametern als JSON gespeichert.
Als Beispiel kann folgender JSON String dienen:

`{'class': ExternalInterpreterLookup,'args': [ 1 , ‘normal’ ] }`

Die Klasse beschreibt den Job der durch einen Workern, durch den Invoke Process erzeugt wird.

Die Argumente bestimmen die Parameter der `perform()` Methode, die jeder Job anbieten muss.

Zu beachten ist, dass nur Parameter abgelegt werden können, die in einen JSON umgewandelt  werden können. Es ist deshalb notwendig z.B. auf Objekt IDs zurückzugreifen, anstatt auf direkte Objektreferenzen bei der Übergabe an

`Resque.enqueue(ExternalInterpreterLookup, 1, normal)`

Näheres dazu in der Dokumentation von Resque und Redis https://github.com/resque/resque


####Resque
Resque ist ein Job System, welches die Bestandteile von Redis nutzt, um Jobs zu erzeugen und auszuführen.
Jobs können generell alle Klassen sein die eine `perform()` Methode anbieten, es empfiehlt sich diese jedoch separat zu strukturieren.
Jobs im Projekt liegen in lib/processing/jobs
Resque bietet mit Workern dann die Basis, die Klassen zu erzeugen die ihnen durch Redis übergeben werden und führen die Methode perform() auf diesen aus.
Worker selbst sind Sub-Prozesse die über

`COUNT=5 QUEUE=* rake resque:workers`

gestartet werden können. Hierbei bestimmt Count die Anzahl der Worker. Im Projekt zeigte sich, dass eine Anzahl von Workern die die maximale Kernzahl übersteigt, keinen Performancegewinn erzeugt. Teilweise stürzte die gesamte Workerstruktur dadurch ab. Erklärungen gab es dafür keine und es ist möglich das sich das nicht reproduzieren lässt, es ist daher lediglich als Anmerkung zu sehen.

Für die Verwaltung bietet Resque gleich eine Schnitstelle im Frontend mit. Diese lässt sich mit

`/resque_web`

aufrufen und bietet eine Übersicht, die zumeist für das debuggen ausreichte. Näheres dazu in der Dokumentation von Resque.

####Datenbankadapter
Es ist notwendig das eine persistente Datenbank zur Verfügung steht, diese muss in Rails definiert sein, da Resque im default diese für seine Jobs benutzt.
In der Entwicklung wurden MySql und Postgress verwendet. Theoretisch sind auch andere denkbar.

###Überblick
Es existieren derzeit folgende Jobs im Projekt:

####CardFactory
Da die Notwendigkeit besteht alle Karten in den übergebenen Jsons zu Objekte zu überführen, werden hier Karten stückweise angelegt. Hierfür werden die Json-Rohdaten in Teile zerlegt und dann auf mehrere Worker verteilt.

####ExternalWorkLookup
Hier wird das Auflösen von Werken aus dem Werksverzeichnis durchgeführt. Durch die Korrektur ist davon auszugehen das Werke bereits aufgelöst wurden. Deshalb reicht ein einfaches Matching.

####ExternalInterpreterLookup
Hier wird das Auflösen von Interpreten aus dem Interpretenverzeichnis durchgeführt.
Für jede Person im Verzeichnis wird eine Suche ausgeführt. Dafür werden zuerst volle Namen aus dem Verzeichnis im Text gesucht, dies wäre der Idealfall, sollte die Korrektur gut gearbeitet haben.
Sollte kein Treffer gefunden werden, wird im Text nach Vor- und Nachnamen gesucht.  Dies ist ungenau und kann zu Fehlern führen, umgeht aber Schreibweisen und Einrückungen.

####SignatureLookup
Hier wird das Auflösen von Signaturen, aus dem Signaturenverzeichnis durchgeführt. Diese werden auf Basis von RegEx begriffen aufgelöst. Dies geschieht Zeilenweise von oben nach unten. Aufgrund der OCR ist die Zeilennummer nicht ausschlaggebend für die Position der Signaturen. Für die Suche wird der Text von Leerzeichen befreit und in Großbuchstaben umgewandelt, dies vereinfacht die Erkennung.
Die RegEx-Begriffe werden aus der *signatures.txt* geladen und enthalten folgende angaben
Bezeichnung nach Katalog
Die Beispielzusammensetzung für Signaturen dieses Typs
Beschreibung
Zuweisung für eine Kategorie, bzw. Beschreibung des Katalogs
RegEx
Der RegEx-Begriff für die Suche
Replacement
Sollte es möglich sein eine komplexe Signatur durch Platzhalter aufzulösen, dient das Replacement für die Korrekturangabe nach dem Match.


####FieldReplacer
Hier werden Felder nach gleichen Einträgen durchsucht, die dann im Anschluss auf einen neuen Typ korrigiert werden.
JobBuilder
Jobs werden durch eine Nummer klassifiziert. Jede Karte besitzt dafür den zuletzt durchgeführten Job als Referenz. Der JobBuilder nutzt diese Identifikation um den nächsten Job für die Karte zu erzeugen. Dies definiert sich durch die Reihenfolge die in JOBS::JOBS definiert ist.

####JobCreator
Der JobCreator ist eine Hilfsklasse die den JobBuilder erzeugt, nachdem alle Parameter gesetzt wurden. Dies war nötig um möglichst Modular zu agieren und einen Job ohne Parameter zu besitzten.


####AcronymReplacer
Um die Verarbeitung einfacher zu gestalten, sollen Synonyme ersetzt werden, so dass diese einheitlich vorliegen. Da die Integration mit der Elastic Search Korrektur nicht vollständig Modular aufgebaut wurde, wird dieser Schritt im Vorbereitungsprozess durchgeführt, sollte die Modularität gewährleistet sein, sollte die Funktionalität hierher ausgelagert werden.

####DataCrawler
Als Erweiterung gedacht, jedoch bisher nicht weiter verfolgt. Sollte es notwendig sein Karten oder Daten nachträglich hinzuzufügen, sollte dies hier implementiert werden. Derzeitig wurde hier nur das Job verhalten der Worker getestet.

# Korrekturalgorithmus
Da die Texterkennung fehlerbehaftet ist, sollte ein Algorithmus entworfen werden, welcher die Fehler der OCR ausbessern sollte.
Die Arbeitsweise des Algorithmus ist in folgender Grafik skizziert:

![Korrekturalgorithmus](https://raw.githubusercontent.com/kaphka/htwmusik/master/bilder/diagramme/korrektur.jpg "Korrekturalgorithmus")

Die Implementierung des Algorithmus kann im [Card-Model der Railsapplikation betrachtet werden](https://github.com/albrechtsimon/htwmusic_webapp/blob/master/app/models/card.rb#L189).

# Konvertierung der Datenquellen
Bis jetzt nutzt das Projekt 4 Datenquellen:

  - OPAC-Bilder
  - OPAC-Indexierung
  - GND
  - Labeldaten

Im folgenden werden die Tools für die Verarbeitung der Daten dokumentiert.

## [nbconv](https://github.com/kaphka/nbconv)
nbconv ist eine Sammlung von iPython-Notebooks
Die Notebooks enthalten Untersuchungen über die Daten und unterschiedliche Konvertierungsskript und API-Anleitungen
 Die Datei [ocr_error_rates.ipynb](https://github.com/kaphka/nbconv/blob/master/analysis/ocr_error_rates.ipynb) erzeugt die Graphen für das IMI-Showtime-Poster.
 Das Skript [index-database2json.ipynb](https://github.com/kaphka/nbconv/blob/master/export/index-database2json.ipynb) exportiert die Indexierungs-Daten als JSON-Dateien.
 Diese Schritte müssen im dauerhaften betrieb der Anwendung nicht mehr ausgeführt werden

## [labelconv](https://github.com/kaphka/labelconv)
![labelconv_screenshot](https://raw.githubusercontent.com/kaphka/htwmusik/master/notes/documentation/pictures/labelconv.png)

labelconv ist ein simples Tool um Trainingsdaten für die OCR zu erstellen.
Im Gegensatz zu den hOCR-Tools von ocropy bietet dieses Tool Features um besser mit den Katalogdatensatz zu arbeiten.
Es kann ein Seed für die zufällige Auswahl von Textzeilen festgelegt werden.
Danach wird im Browser ein Sample aus dem jeweiligen Katalog gezeigt. So können unabhängige Samples zum trainieren und zum testen erstellt werden.

## [semconv](https://github.com/kaphka/semconv)
Dieses Skript dient der Datensammlung zur Verbesserung des Erschliessungsprozesses.
Die Extrahierung der Daten aus der GND ist ein größeres Thema als gedacht und dieses Skript liefert lediglich einen Ausgangspunkt.

## [catconv](https://github.com/kaphka/catconv)
Das Modul ist zuständig für die Konvertierung der Katalogkarten.
Es werden lediglich Skripte bereitgestellt, dabei orientiert sich am Aufbau von Ocropy (kein Zustand, kleine Programme mit nur einer Aufgabe).

- convert.py: Umwandlung von TIF zu jpgs.
- process.py: Vorprozessierung//Binarisierung
- export.py:  Umwandlung ins Exportformat

Die iPython-Notebooks dokumentieren das Trainings eines OCR-Modells, welches fuer das Skript process.py benoetigt wird.




# Verbesserungen

## Accountmanagement
Das Frontend umfasst kein Accountmanagement. Auch wenn dies nicht genutzt werden soll, um einzelne Nutzer zu überwachen, wäre jedoch die Umsetzung nicht sonderlich kompliziert und würde die Anwendung für weitere Szenarien öffnen, beispielsweise Fremdleistungen.

## Bildscrolling und 16:9
Für die Ansicht wurde sich gewünscht, das die Karte beim Scrollen durch die Felder immer sichtbar sein sollte. Dies wurde insofern abgeschwächt, das nun der restliche unbearbeitete Text unter den Feldern sichtbar ist. Hier müsste eruiert werden, ob und inwiefern die Umsetzung vom Bildmitlauf noch gewünscht wäre. Zudem wäre ein breiteres Design möglich, da das derzeitige noch etwas Freiraum an den Seiten bietet. Es gab jedoch kein uns bekanntes Szenario, dass einen anderen Aufbau gerechtfertigt hätte. Hier könnten alternative entworfen werden.


## Korrekturalgorithmus
Gerade der Korrekturalgorithmus ist einer der Punkte, an dem in der Fortführung des Projektes weitergearbeitet werden sollte. Mögliche Punkte, die hierbei
bearbeitet werden könnten sind im Folgenden aufgeführt:

## Spracherkennung
Die aktuelle Version des Algorithmus versucht unter anderem, wie im obigen Diagramm ersichtlich, Korrekturen für Worte anhand eines Wortindex zu finden.
Dieser Index ist momentan nicht sprachabhänging implementiert. Das heißt, dass Worte aus unterschiedlichen Sprachen in einem Index liegen.

Man könnte nun versuchen, diesen Index sprachspezifisch aufzusplitten, sodass Worte einer Sprache jeweils in ihrem eigenen Index liegen.
Gegeben den Fall, es würde eine Methode gefunden, mit welcher ermittelt werden kann, in welcher Sprache der Text einer Karte verfasst ist oder auch
welcher Sprache einzelne Wörter im OCR-Text angehören, könnte die Fehlerrate des Algorithmus gesenkt werden.

## Gewichtung von Treffern
Die Implementierung des Wählens von Treffern einer Query an ElasticSearch ist momentan relativ primitiv. Werden Worte, die zur Korrektur herangezogen werden
sollen, gleich oft gefunden, entscheidet sich der Algorithmus immer für den ersten Treffer. Durch dieses Vorgehen entstehen falsche Ersetzungen.

Hier könnte versucht werden, weitere Metriken in den Algorithmus einfließen zu lassen, welche eine präzisere Auswahl einer korrekten Ersetzung ermöglichen.
Der Punkt der Gewichtung könnte von der im vorangehenden Abschnitt angesprochenen Spracherkennung ebenfalls zugutekommen.

## Mehr Daten
Während der Durchführung des Projektes sowie der Entwicklung des Algorithmus wurde auf einem relativ kleinen Datenset gearbeitet. Die Resultate, die das Verfahren zeigt,
lassen darauf schließen, dass der Ansatz in die richtige Richtung geht. Dem Gesetz der großen Zahlen entsprechend wird es sicherlich so sein, dass
die generelle Korrektheit der Ersetzungen mit dem Erhöhen der Grunddatenmenge steigen wird. Grunddatenmenge bezeichnet in diesem Kontext alles an textuellen Daten, die
der Algorithmus zum Abgleich heranzieht:

* einzelne Worte
* Werke
* Personen
* alle OCR Rohtexte

## Nutzen anderer Systeme zum Abgleich
Ein Punkt, der im Verlauf des Projektes nicht mehr adressiert werden konnte, war der Abgleich der einzelnen der OCR entstammenden Worte Daten anderer Systeme.
Würde man annehmen, dass die Drittquellendaten der Wahrheit entsprechen, könnte man mit den Daten dieser Quellen

1. verhindern, dass bereits korrekte Worte durch Falsches ersetzt werden
2. weitere Abgleiche anstellen, die beispielsweise in die Gewichtung der Korrekturkandidaten hineinspielen könnten.

## Rückfluss von Daten aus dem Frontend
Sollte das System in den Produktiveinsatz übergehen, wäre es sinnvoll, alle Korrekturen, die von Anwendern des Systems vorgenommen werden, zu speichern und als wahr und valide
aufzufassen. Diese manuell eingegebenen Daten sollten wiederum in einen neuen Index in der Applikation einfließen, welcher bei der Bewertung von Treffern im Korrekturalgorithmus
ein wesentlich höheres Gewicht als (vermutlich alle) anderen Indizes haben sollte. Dies würde zum einen die Fehlerrate des Systems verringern und zum anderen mittel- bis langfristig
die Datenmenge auf die der Algorithmus mit Vertrauen zurückgreifen kann erhöhen und deren Qualität verbessern.

## Modularität
Aufgrund von Problemen beim Import und der Verarbeitung der Karten, läuft der Korrekturprozess nicht Modular. Hier konnte keine kurzfristige und zufriedenstellende Lösung gefunden werden, Callbacks zu integrieren, so das Jobs anderen Jobs melden können, wenn diese durchlaufen wurden. Sollte dies umgesetzt sein, kann die Korrektur auch in einen Job ausgelagert werden. Dies gilt dann auch für das Replacement, erst dann wäre das Job System völlig asynchron. Derzeit sind nur nachgelagerte und vorgelagerte Prozesse in Jobs möglich.

Zudem muss für den JobCreator derzeit ein Subprozess generiert werden, der in einem Interval neue JobCreator-Jobs erzeugt, damit dieser wiederum neue nachfolgende Jobs erzeugt. Evtl wäre es möglich hier einen besseren Ansatz zu finden.

## Datenbasis und Datenverarbeitung
Die Datenbasis bildet einerseits die OCR, die sicherlich weiter optimiert werden kann, um die Genauigkeit zu erhöhen, andererseits werden die Werke etc. aus einer Extraktion aus der GND gespeist. Diese stellte sich jedoch als teilweise unzureichend heraus, da viele Daten unberücksichtigt sind. Daraus resultiert, das viele Karten ungenügend aufgelöst werden. Könnten hier mehr Daten angereichert werden, wäre eine Verbesserung, einerseits der Korrektur, andererseits der Auflösung möglich.

In Zukunft sollten zur Datenverarbeitung stärker auf leistungsfähigere Frameworks gesetzt werden.
Aufgrund der Datenmenge würde eine Verteilung der Prozessierung auf mehre Rechner mit einem Framekwork wie [Spark](https://spark.apache.org/) Vorteile bringen.
Eine Umstellung auf ein Machine Learning framework würde es möglich machen GPU's zur Erkennung der Textzeilen zu nutzen. Ocropy nutzt bis jetzt "nur" eine CPU-Implementierung für die OCR.
Eine Eigenentwicklung wird aber nicht mehr nötig sein sobald die Erkennung vom transkriptorium-Projekt übernommenen wird.

## Signaturgenauigkeit
Derzeit sind Signaturen durch RegEx-Begriffe ausgezeichnet. Diese sind für Treffer sehr genau, zeigten jedoch, dass es durchaus Gemeinsamkeiten in der fehlerhaften Erkennung von Zeichen im OCR-Text gibt.
So werden oft "S" oder "5" als jeweilige Partner vertauscht.
Beispiel: "55 CD 131543" wird zu "5S CD 131S43"
Durch diesen Umstand ist es schwierig korrekte Signaturen umzusetzen, dies liegt vor allem daran, dass Signaturen teilweise mehrdeutige Schreibweisen besitzen. Beispiel: 55 CD XX, sowie CD XX. Eine Fehlerkennung ist deshalb nicht ausgeschlossen, wenn die vorangestellten Zeichen nicht richtig durch die OCR erkannt wurden.
Eindeutige Signaturen sind derzeit sehr zuverlässig und können durch die Ersetzungsregeln auch dann gefunden werden, wenn diese Fehlerbuchstaben enthalten.
So lassen sich Signaturen wie DMS XX oder NUS XX leicht erkennen und lieferten im Test sehr gute Ergebnisse. Probleme bereiten vor allem sehr uneindeutige Signaturen wie CD oder sehr lange Signaturen, da die Fehlerrate mit der Länge der Signaturen zunimmt. Aufgrund dieser Tatsache, wäre es Ratsam, die Signaturen aus den Kartenbildern direkt zu extrahieren und so zumindest die Datenbasis, die derzeit beim ganzen OCR-Text liegt zu begrenzen. Mit unseren Mitteln, war dies jedoch bisher nicht möglich.
Dies würde zumindest die Fehlerrate senken, die durch verdrehte Buchstabenkombinationen im Quelltext aufkommen.

## Schnittstellen
Derzeitig liegen alle Daten die erfasst wurden nur im System selbst vor, dies Umfasst die Datenbank, den ElasticSearch und die Kartenbilder selbst.
Der Hauptaugenmerk lag in der allg. Verfügbarkeit und Machbarkeitsstudie des Projektes. Trotz Fehlerraten und Misserkennung wäre aber bereits eine Nutzung denkbar. Hierfür müssten Schnittstellen definiert werden über die diese Daten abgerufen werden könnten.

## Nutzung der Daten
Evtl. wären auch weitere Nutzungsszenarien denkbar, die bisher nicht in Erwägung gezogen wurden, da schlicht keine Daten außer den Bildern zur Verfügung standen. So wäre eine experimentelle Suche möglich die die Ergebnisse auf Wunsch dem allg. Datenbestand hinzufügt, um diese für die Öffentlichkeit zugänglich zu machen.

# Meilensteine
Als agiles Projekt konzipiert und durchgeführt, änderten sich Teilaspekte durch anhaltende Wöchentliche Meetings, jedoch blieben die Ziele im allg. gleich.

So definiert sich als Hauptziel, die Entwicklung eines Systems zur Verarbeitung von Kartenbildern und Überführung in ein System mit anschließender Fehlerkorrektur, Datenaufbereitung/Visualisierung, sowie evtl. Datenextraktion.
Daraus definieren sich Meilensteine die im Wochenplan festgehalten wurden. Diese unterscheiden sich je nach Anwendungsgebiet.
Der größte Meilenstein des Projektes, war klar die Präsentation auf der Messe der HTW, diese war ein voller Erfolg, so dass das Projekt als solches als Erfolg verbucht werden kann, auch wenn nicht alle Meilensteine gänzlich erfüllt wurden.
Die Meilensteine definieren sich aus dem aktuellsten Wochenplan, der für das Projekt angelegt wurde.

## OCR

Die grundlegende Aufgabe der Verbesserung und Automatisierung der OCR konnte konsequent bearbeitet.
Im Verlauf der Arbeit wurde klar das die Fehlerraten, die in vielen Publikationen
berichtet werden, nicht in realen Datensets erreicht werden können.
Es wurden neben der OCR auch an weiteren Methoden zur Datenextrahierung gearbeitet wie zum Beispiel
die Erkennung der Kartensprache und des Kartentyps.
Jedoch kann man diese Daten nur weiterverarbeiten, wenn man auch die Genauigkeit validiert,
ein Integration in die Pipeline vornimmt und ein Nutzungsformat spezifiziert.


##Korrektur
Im Großen und Ganzen wurden alle Meilensteine abgearbeitet und umgesetzt. Dazu gehört das Entwickeln eines Systems inkl. ElasticSearch-Integration, der Prozessmodelierung und Abarbeitung, Entwicklung eines Persitenzmodels, Anlegen eines Jobsystems für asynchrone Tasks, Korrektur von Ergebnissen auf Basis von GND Daten.
Aufgrund der Veränderung des Prozesses, wurden GND Daten nicht mehr Live über Pazpar2 abgerufen, sondern extern extrahiert. Dies schließt Daten externer Anbieter derzeit aus, da dafür keine Daten erhoben wurden. In diesem Punkt kann nur eine teilweise Erfüllung angesehen werden.
Die Technik dahinter ist jedoch vorhanden, so dass einfach weiteren Daten importiert werden können, wenn diese erhoben wurden.
Durch Zeitmangel vor allem am Ende des Projektes, wurde die Accountverwaltung nicht implementiert. Diese war zwar immer optional, theoretisch aber im ersten Plan festgehalten.
Der Export von Daten wurde theoretisch vorgesehen,jedoch nicht umgesetzt.  Dies würde neu kalkuliert werden müssen.



# Ergebnisse

Für das Masterprojekt 1 und 2 wurde ein System Entwickelt das aufzeigt, dass eine automatisierte Erfassung technisch möglich ist. So wurden Bilder in Texte umgewandelt und anschließend versucht diese zu korrigieren, um abschließend Daten aus diesen gewinnen zu können.
Die Ergebnisse sind sehr stark abhängig vom gewählten Katalog und der Qualität desselben. So spielte auch die Sprache eine große Rolle, da die OCR ursprünglich auf englischem Text trainiert wurde. Dies führt zu einer verschobenen Spracherkennung. Dies kann mit mehr validen Trainingsdaten umgangen werden, wofür jedoch eine händische Erfassung notwendig wäre. Dies wäre deshalb voraussichtlich ein Problem an Ressourcen.
Mit Verbesserung der OCR ist davon auszugehen, dass sich das Ergebnis aller anderen Schritte verbessert. Da dies jedoch nicht zu 100% erreicht werden kann, produziert die Korrektur bereits zufriedenstellende Ergebnisse. Diese ist jedoch abhängig von den bereits erhobenen Daten. So zeigte sich, dass vor allem die Inhalte der Karten selbst ein Problem darstellen, da diese zwar logisch strukturiert sind, jedoch nicht ausreichend klare Daten beinhalten. Da dies die letzte Instanz in der Kette vor der Nutzerinteraktion darstellt, sind hier die Korrekturen maßgeblich, dazu gehören natürlich auch die Fehlerraten die durch die Korrektur selbst erzeugt werden. Die abschließende Extraktion stützt sich dann auf die korrekte Korrektur, weshalb dort Fehlerkennung  das größte Problem darstellt. Sollten Bestandteile weder durch die OCR noch durch die Korrektur genau ermittelt worden sein, ist es sehr schwierig Daten zu erheben. Dies zeigte sich Maßgeblich an den Signaturen, die je nach Katalogart sehr durchwachsende oder sehr gute Ergebnisse lieferten.
Maßgeblich ist hier auch die Datenbasis die zugrunde liegt, Daten die nicht existieren, können nicht gefunden werden, weshalb eine weitere Datenspeisung ratsam ist.
Trotz der angesprochenen Probleme, zeigt das Projekt, das es möglich ist, maschinell Daten zu erheben. Diese entsprechen jedoch voraussichtlich nicht den Anforderungen die ein Bibliothekar an seine Sammlung stellt. Hierbei ist jedoch zu betrachten, das Daten die nicht existieren, nicht gefunden werden können und so das in Kauf nehmen von Fehlerraten besser wäre, als 100%tige Ergebnisse. Jedoch ist eine Fehlerrate gegen Null immer anzustreben, weshalb eine weitere Beschäftigung mit dem Projekt ratsam ist.
