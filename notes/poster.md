# Erschließungs- und Visualisierungswerkzeuge für den Imagekatalog der Musikabteilung der Staatsbibliothek zu Berlin

Das hier vorgestellte Projekt, ist eine Zusammenarbeit der Staatsbibliothek zu Berlin und der HTW Berlin. 
Das Projekt wird von drei Studenten, Herrn Simon Albrecht, Herrn Jakob Schmolling, Herrn Lars Görisch und Herrn Zellhöfer, als Ansprechpartner für die Staatsbibliothek, geführt.
Das Ziel des Projekts, ist die
Gewinnung von strukturierten Daten, aus dem Katalog der Musikabteilung.
Diese Daten sollen die Retrokonversion des Katalogs
unterstützen und später auch für Nutzer verfügbar sein.

## Besonderheiten der alphabetischen Imagekataloge der Musikabteilung

Die Staatsbibliothek zu Berlin unterhält ein umfassendes Musikarchiv, mit vielen Werken aus vergangener und heutiger Zeit.
Diese werden seit dem Bestehen der Bibliothek auf Karteikarten festgehalten und gesammelt.
Diese werden seit dem 1800 geführt und unterscheiden sich deshalb stark in ihrer Form. 
Der Umfang bemisst sich derzeit auf rund eine Million Karten, die in diesem Projekt in das digitale Archiv und Katalogsystem überführt werden sollen.

Die Katalogkarten der Musikabteilung wurden mit einer Auflösung von 200dpi gescannt und
liegen im TIF-Format vor. Der uns zu Verfügung stehende Datensatz umfasst etwa 3.4 TB. 
Für etwa 30.0000 der Karten gibt es zudem einen manuell erstellen Index.
Die Textform und Schrift variiert stark nach Zeit und Bibliothekar. So sind Karten in Handschrift, Schreibmaschine oder Computertext geschrieben.
Zudem sind die Einträge mehrsprachig (Deutsch, Englisch, Französisch, Tschechisch, ...).

## Umsetzung

Die Umsetzung hat sich im ersten Semester des Projekts in zwei Bereiche gegliedert: 

1. Die Analyse der bestehende Daten und Anforderungen 
2. Die Entwicklung von Anwendungsprototypen.


### Anwendung und Evaluierung von OCR-Werkzeugen

Zu allererst mussten Daten für einen Goldstandard(“ground truth”) erstellt werden.
Gegen diesen kann man dann verschiedene Methoden vergleichen.
Die Umsetzung der Schrifterkennung basiert auf dem Open-Source OCR-Framework ocropy,
welches wir über Skripte erweitert haben.
Die Benutzung der Skripte wurde mithilfe von iPython-Notebooks dokumentiert und visualisiert. 

Aktuelle OCR-Methoden basieren auf überwachten Lernverfahren, dass heißt man 
benötig Ein-und Ausgabebeispiele in großen Mengen. Daraus können Modelle zur Schrifterkennung erzeugt werden. 
Aufgrund der großen Varianz in den Daten arbeiten wir an einer Kategorisierung 
der Karten in verschiedene Klassen (unterschiedliche Handschriften, Schreibmaschine, etc.)

### Gewinnung von strukturierter Information

Etwa 5% der Buchstaben in den Texten, die von unserer OCR erzeugt werden, sind falsch.
Das erschwert die Tokenisierung und Erkennung von Wörtern zusätzlich.

Die GND (Gemeinsame Normdatei) wird genutzt um Inhalte zu validieren und zu normalisieren. Andere Datenbankenquellen werden zur Verbesserung der Ergebnisse eingebunden. Beispielsweise: Wikidata oder MusicBrainz.

### Webinterface 

Im Prototyp der Weboberfläche, können alle Daten eingegeben werden, die für einen korrekten Eintrag im Katalog der Staatsbibliothek nötig sind.
Die Erkennung von Autor, Werk, etc. soll im Verlauf des 2. Semester automatisiert werden,
jedoch eignet sich die Anwendung schon jetzt zur Erstellung von Trainingsdaten (für maschinelles Lernen).

