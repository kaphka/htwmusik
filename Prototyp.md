#Prototyp

Um das Projekt programmatisch voranzubringen wurde entschieden, dass bereits frühzeitig ein Prototyp entwickelt werden soll.
Dies umfasste einmal die gesamte OCR Erkennung die im Abschnitt: TODO: link bereits erläutert wurde und andererseits das Web-Frontend, das in diesem Abschnitt näher erläutert wird.

##Frontend
Die durch die OCR gewonnen Rohdaten müssen im weiteren Verlauf aufgearbeitet werden. Hierfür ist es nötig eine entsprechende Schnittstelle für die menschliche Korrektur und Nachpflege der Daten zu entwickeln. Hier wurde sich für eine Web basierende Oberfläche entschieden, die ausschließlich den Bibliothekaren zur Verfügung steht und die Ergebnisse der maschinellen Korrektur grafisch aufbereitet und anzeigt.

##Entwicklung
Der Prototyp wurde voranging vom Team entwickelt und in wöchentlichen Meetings, durch Kritik und Ideensammlungen vervollständigt. Im Vergleich zur Ursprünglichen Skizze war das Ergebnis bereits erkennbar.  TODO: link Bild
Im weiteren Verlauf wurde entschieden, dass sich die Farbliche Gestaltung am öffentlichen Auftritt der Staatsbibliothek zu Berlin orientieren soll.

##Implementierung
Der Prototyp umfasst drei große Teilbereiche, dazu gehören:

####das Dashboard:
Es bildet den Einstieg in das Frontend, und zeigt in einer übersichtlichen Darstellung, die verarbeiteten Kartenstatus, sowie die neusten Karten des Status ‚neu‘ und ‚fertiggestellt‘.

Bild Dashboard

####Filterlisten: 
Geordnet nach den Status der Karten, können hier alle Karten entsprechend angesehen und gefiltert werden. Im Laufe des Projektes, können hier noch weitere Filtermöglichkeiten folgen, sollten sich diese als pragmatisch Erweisen.

####der Bearbeitungsbereich:
Der Bearbeitungsbereich, zeigt die entsprechenden Rohbilder und dessen gescannten Text der OCR im oberen Bereich an.
Im unteren Bereich, wird für jede Information, die aus dem Text extrahiert wurde, grafisch aufgearbeitet und präsentiert.

Der Bereich unterteilt sich in vier Spalten:

* Gelesener Text: Die erkannte Textpassage aus der OCR
* Korrektur: Die im ersten Schritt maschinelle korrigierte Fassung.
* Feld-Typ: Der bezeichnende Feld-Typ für das Informationssegment. Siehe Klassifikationstabelle
* Status: Der Status, der vom System anhand der erfolgten Korrektur vergeben wurde. Siehe Status
