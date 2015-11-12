# Konzept

## Aufgabenstellung

Kernaufgabe der Anwendung(en) ist die
Gewinnung von strukturierten Daten aus dem Katalogs der Musikabteilung.

Diese Daten sollen eine Retrokonversion des Katalogs
unterstützen.

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

### Datenhaltung und Server
Eine Umsetzung als Webservice mit Weboberfläche (HTML und JS) bereitgestellt durch eine
Java-REST-Server bietet sich aufgrund der Kenntnisse im Team an. (?)

Alle Daten sollten in einem Datenaustauschformat verfügbar sein.
Dies soll eine Integration in andere Services der Staatsbibliothek erleichtern.

## TODO: Zeitplannung, Milestones, Arbeitspakete


