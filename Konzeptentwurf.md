# Konzept

## Vorwort

Im Rahmen des Masterprojektes an der HTW Berlin entsteht in Zusammenarbeit mit der Staatsbibliothek zu Berlin, ein mehrstufiges Forschungsprojekt, im Bereich Texterkennung und Verarbeitung.
Hierfür sollen, die Musikkataloge der Bibliothek, die bisher vor allem aus fotografierten Karteikarten bestehen, umfassend digitalisiert werden.
Das Projekt wird von vier Studenten, Herrn Name 1, Herrn  Name 2, Herrn Görisch, Herrn Name 4 und Herrn Zöllner  als Ansprechpartner für die Staatsbibliothek, geführt.

## Aufgabenstellung

Kernaufgabe der Anwendung(en) ist die
Gewinnung von strukturierten Daten aus dem Katalog der Musikabteilung.

Diese Daten sollen die Retrokonversion des Katalogs
unterstützen und für Nutzer verfügbar sein.

## Die alphabetischen Imagekataloge der Musikabteilung

Siehe [Datenanalyse](/Datenanalyse.md).

## Anwendungsdetails
![Prozessübersicht](/bilder/grobkonzept2.jpg)

### OCR
Siehe [Texterkennung](/Texterkennung.md).

### Strukturierung und Klassifizierung der Daten
Die Analyse mit OCR-Sofware gibt uns lediglich Aufschluss über den
Textinhalt der Karte. Deswegen wird im nächstem Schritt der
semantische Inhalt der Karten erkannt.

Wortgruppen können mit unterschiedlichen Verfahren klassifiziert werden.
Weiterhin kann die Plausibilität einer Klassifizierung von Wortgruppe mit externen
Datenbanken überprüft werden.

### Visualisierung und Darstellung der Ergebnisse
Eine Retrokonversion darf nur sehr geringe Fehlerraten vorweisen.
Deshalb soll die Anwendung moderne Mittel für die Qualitätskontrolle bereitstellen.
So kann eine Visualisierung von Clustern das Finden von "Ausreißern" erleichtern.

Die entstandenen Daten sollen auch der Öffentlichkeit zugänglich gemacht werden.
Dies erleichtert(/ ermöglicht) das Auffinden von Dokumenten der Musikabteilung.

## Umsetzung

### Texterkennung
Es gibt viele kommerzielle und/oder quelloffene Software für die Texterkennung.
Für den Einsatz in der Anwendung müssen diese Evaluiert werden.
Eine korrekte Evaluierung ist nicht einfach,
da viele Methoden mit trainierten Erkennungsmodellen weitaus besser Erkennungsraten erreichen.

Nicht die Entwicklung sondern die Anpassung von OCR-Methoden stellt hier die eigentliche Arbeit dar.

Quelloffene Software ist in den meisten Fällen nicht nur kostenlos, sondern auch wartbar und anpassbar. Dies ist auch wichtig im wenn die Software bei anderen Retrokonversionensprojekten eingesetzt werden soll.


### Strukturierung und Validierung der Texte
Die Texte werden Klassifiziert und nach Entitäten durchsucht.
Eine Klassifizierung (z.B.: nach Medienart, Art des Werkes, ...) soll eine Retrokonversion erleichtern.
Die Klassifizierung von Karten kann auch für die Faceted Navigation genutzt werden.

Die GND wird genutzt um Inhalte zu validieren und zu normalisieren.
Andere Datenbanken werden genutzt um die 

## Verarbeitungsprozess
Die Verarbeitung einer einzelnen Karteikarte unterliegt einem Mehrstufigen System um die Qualität von Stufe zu Stufe zu erhöhen.
Jeder Prozess muss in einer Datenbank vermerkt werden, um zusätzliche Informationen hinzuzufügen. Dafür sollen alle Stufen ihre spezifischen Merkmale anhängen, um eine evtl. nötige Sichtung möglich zu machen.

#### Stufe 1:
OCR Erkennung des Textes, optimaler Weise in Sektoren aufgeteilt oder in einer einzelnen .txt Datei.

#### Stufe 2: 
Überprüfung der Signatur mit vorhandenen und bekannten Mustern um Fehlerkennung möglichst auszuschließen. Signaturen die diese Überprüfung nicht bestehen müssen makiert werden.

#### Stufe 3: 
Autoren, Komponisten die im Headerbreich vermerkt sind können gegen Informationseinheiten validiert werden, um zu prüfen ob ein Zusammenhang zwischen Erkennung und realen Personen besteht. Sind keine Daten zu finden, soll dies vermerkt werden.

#### Stufe 4: 
Verarbeiten des Textes: Der Text kann Merkmale zu seinen Komponisten und Werksnamen enthalten, sowie verschiedenste Stickpunkte. Diese müssen separiert werden, und können dann ebenfalls gegen externe Quellen validiert werden.

####Stufe 5: 
Aufbereiten der erfassten Daten zur Überprüfung bei nicht bestandenen Validierungen

### Datenhaltung und Server
Eine Umsetzung als Webservice mit Weboberfläche (HTML und JS) bereitgestellt durch eine
Java-REST-Server bietet sich aufgrund der Kenntnisse im Team an. (?)

Alle Daten sollten in einem Datenaustauschformat verfügbar sein.
Dies soll eine Integration in andere Services der Staatsbibliothek erleichtern.

## TODO: Zeitplanung, Milestones, Arbeitspakete

### OCR
Testdaten ist nötig um verschiedene OCR-Systeme zu vergleichen.
Die Erstellung von Trainingsdaten ist ein weitaus größerer Aufwand,
da modernere Verfahren ( aus dem Bereich Maschinen Lernen) grosse Mengen benötigen. 
### Semantische Analyse
### Datenbank

	Vermutlich bietet es sich an, nicht mit klassischen RDBMs sondern eher mit NoSQL-Datenbanken wie MongoDB oder Apache Cassandra zu arbeiten.
	Daten zum Abgleich mit bereits bekannten Daten sollten aus Performancegruenden in einem Key-Value-Store wie Redis gehalten werden.

#### TODOS:
	* Installieren und evaluieren von MongoDB / Cassandra
	* Installation und Evaluation von Redis
	* Anbindung der OCR an die oben genannten Systeme
	* Anbindung der geplanten Web-Applikation an o.g. Systeme
