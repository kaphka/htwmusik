#Prototyp

Um das Projekt programmatisch voranzubringen wurde entschieden, dass bereits frühzeitig ein Prototyp entwickelt werden soll.
Dies umfasste einmal die gesamte OCR Erkennung und andererseits das Web-Frontend, das in diesem Abschnitt näher erläutert wird.



##Frontend
Die durch die OCR gewonnen Rohdaten müssen im weiteren Verlauf aufgearbeitet werden. Hierfür ist es nötig eine entsprechende Schnittstelle für die menschliche Korrektur und Nachpflege der Daten zu entwickeln. Hier wurde sich für eine Web basierende Oberfläche entschieden, die ausschließlich den Bibliothekaren zur Verfügung steht und die Ergebnisse der maschinellen Korrektur grafisch aufbereitet und anzeigt.

##Backend
Für die Verarbeitung der OCR Daten wurde bereits ein Backend erarbeitet, was die Daten live zur Verfügung stellt.
Diese sind jedoch nicht weiter aufbereitet, dies ist Teil des zweiten Projektabschnittes.

##Entwicklung
Der Prototyp wurde voranging vom Team entwickelt und in wöchentlichen Meetings, durch Kritik und Ideensammlungen vervollständigt. Im Vergleich zur Ursprünglichen Skizze war das Ergebnis bereits erkennbar. 

![alt text][Mookup_01]
[Mookup_01]: https://github.com/kaphka/htwmusik/blob/master/bilder/edit.png "Mookup_01"

Im weiteren Verlauf wurde entschieden, dass sich die Farbliche Gestaltung am öffentlichen Auftritt der Staatsbibliothek zu Berlin orientieren soll.

## Technik
Der Prototyp wurde mit Ruby und Ruby on Rails umgesetzt. 
Dies bietet einen großen Fundus an Erweiterungen(Gems), die einfach ins Projekt eingebunden werden können.
Zudem bietet die Verwendung eines Frameworks bereits einige wichtige Vortele, was die Strukutierung und Sicherheit anbelangt.

Für das Styling wurde Bootstrap implementiert und entsprechend der Vorgaben und Ideen angepasst.

- [Ruby](https://www.ruby-lang.org/de/)
- [Ruby on Rails](http://rubyonrails.org/)
- [Bootstrap](http://getbootstrap.com/)


##Implementierung
Der Prototyp umfasst drei große Teilbereiche, dazu gehören:

####das Dashboard:
Es bildet den Einstieg in das Frontend, und zeigt in einer übersichtlichen Darstellung, die verarbeiteten Kartenstatus, sowie die neusten Karten des Status ‚neu‘ und ‚fertiggestellt‘.

![alt text][Dashboard_01]
[Dashboard_01]: https://github.com/kaphka/htwmusik/blob/master/bilder/Dashboard_01.png "Dashboard"

####Filterlisten: 
Geordnet nach den Status der Karten, können hier alle Karten entsprechend angesehen und gefiltert werden. Im Laufe des Projektes, können hier noch weitere Filtermöglichkeiten folgen, sollten sich diese als pragmatisch Erweisen.

![alt text][Filterliste_01]
[Filterliste_01]: https://github.com/kaphka/htwmusik/blob/master/bilder/Cards_new_01.png "Filterliste_01"

####der Bearbeitungsbereich:
Der Bearbeitungsbereich, zeigt die entsprechenden Rohbilder, dessen gescannten Text der OCR und den Status der Karte in Textform im oberen Bereich an und in visuellel als Balken darunter an.

Im unteren Bereich, wird jede Information, die aus dem Text extrahiert wurde, grafisch aufgearbeitet und präsentiert.
Hier kann der Nutzer die Korrekturen abspeichern und die Karte damit als 'fertiggestellt' makieren.

Der Bereich unterteilt sich in vier Spalten:

* Gelesener Text: Die erkannte Textpassage aus der OCR
* Korrektur: Die im ersten Schritt maschinelle korrigierte Fassung.
* Feld-Typ: Der bezeichnende Feld-Typ für das Informationssegment. siehe Klassifikationstabelle
* Status: Der Status, der vom System anhand der erfolgten Korrektur vergeben wurde. siehe Status

Die Korrketurspalte besitzt zusätzlich einen Informationsbutton, welcher die Informationsvalidierungen in einem Popover anzeigt. Dazu gehören externe Quellen, sowie Nutzerspeicherungen.
![alt text][Karten_Head]
[Karten_Head]: https://github.com/kaphka/htwmusik/blob/master/bilder/card_overview_02.png "Karten_Head"
![alt text][Karten_Footer]
[Karten_Footer]: https://github.com/kaphka/htwmusik/blob/master/bilder/card_overview_03.png "Karten_Footer"
![alt text][Karten_Popup]
[Karten_Popup]: https://github.com/kaphka/htwmusik/blob/master/bilder/card_overview_05.png "Karten_Popup"

###Klassifikationstabelle

|Kategorie|Benennung RAK|
| ------------- |:-------------:|
|7100|Signatur|
|3000|1. Verfasser|
|3220|Ansetzungssachtitel|
|4000|Hauptsachtitel, Zusätze, Verfasserangabe|
|4030|Ort, Verlag|
|7100|Erscheinungsjahr|
|7100|Umfangsangabe|

###Status
Das System vergibt je nach voraussichtlicher Sicherheit der erkannten Informationen und dessen Validierung durch externe Quellen, eine Prognose über die Genauigkeit des Informationssegmentes.

#####OK: 	
Die Information:
- wurde durch einen Nutzer gespeichert
- wurde im Vorfeld durch viele Nutzer gespeichert
- konnte durch externe Quellen stichhaltig Belegt werden
- Die Klassifikation ist eindeutig zuzuordnen
	
#####Warnung:
Die Information:
- konnte nicht eindeutig klassifiziert werden
- ist mehrdeutig
- konnte nicht durch genügend Quellen zweifelsfrei belegt werden

#####Error:
Die Information:
- konnte nicht klassifiziert werden
- hat Fehler in der Zusammensetzung
- entspricht nicht den formalen Vorgaben(z.B. Signaturkontext)
- besitzt keine externen Quellennachweise
- wurde im Vorfeld nie bestätigt


###Ausstehende Erweiterungen:
In Gesprächen mit Verantwortlichen und Nutzern, wurden einige Komponenten erfasst, die im Laufe des Projektes noch ergänzt bzw. nachgepflegt werden müssen:

- integration eines User-Logins
- Administrationsoberfläche für die Nutzerverwaltung
- Erweiterung der Bearbeitungsoberfläche
- Kartenbilder im linken Teilabschnitt mitscrollen lasse, um die Bearbeitung zu erleichtern.
- Auszüge des Kartenbilds über den entsprechenden Korrekturfeldern anzeigen lassen
- Button, für das Hinzufügen von weiteren Informationssegmenten
- Buttons für die Speicherung von einzelnen Segmenten
