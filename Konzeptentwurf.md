# Konzept

## Aufgabenstellung

Kernaufgabe der Anwendung(en) ist die
Gewinnung von strukturierten Daten aus dem Katalog der Musikabteilung.

Diese Daten sollen die Retrokonversion des Katalogs
unterstützen und für Nutzer verfügbar sein.

## Die alphabetischen Imagekataloge der Musikabteilung

Siehe [Texterkennung.md](/Datenanalyse.md).

## Anwendungsdetails
![Prozessübersicht](/bilder/grobkonzept2.jpg)

### OCR
Siehe [Texterkennung.md](/Texterkennung.md).

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
