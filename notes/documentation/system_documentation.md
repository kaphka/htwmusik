#Installation


#Frontend 

#Aufbau
Die Basis für das Frontend bildet Rails. Rails dient einerseits als Backend und stellt mit der verwendeten Templateengine ERB alle Ansichten dar. ERB umfasst eine Templatesyntax, welche durch viele Funktionen und Modulen die Entwicklung vereinfacht. Für den Nutzer werden die entsprechenden Daten aufbereitet und abschließend ausgeliefert. Hierbei sind weitere Technologien eingebunden wie u.a. Bootstrap.

#Gestaltung
Die Gestaltung des Frontend orientiert sich einerseits an der Farbgebung der Webseite der Staatsbibliothek zu Berlin, andererseits an einer einfachen tasterturgebundenen Bedienung.

#Komponenten
Das Frontend setzt sich aus drei Komponenten zusammen, die im Nachfolgenden Abschnitt näher erläutert werden.

##Dashboard
Das Dashboard bildet den Einstieg in die Applikation, in diesem werden alle Kartenzustände grafisch dargestellt.

![alt text](https://raw.githubusercontent.com/kaphka/htwmusik/master/bilder/dashboard.jpg "Dashboard")

1. Schnellauswahl für die Filterlisten
2. Grafische Darstellung der Karten Status
3. Übersicht der Karten

##Filterungslisten 
In der Listenübersicht kann nach Inhalten von Karten gesucht werden, um thematisch zusammenhängende Karten zu finden.

![alt text](https://raw.githubusercontent.com/kaphka/htwmusik/master/bilder/liste.jpg "Filterliste")

1. Suchen nach Kartennummern
2. Suche für die OCR-Texte
3. Kartenvorschau
4. Kartennummer
5. Status der Karte

##Kartenübersicht
Die Kartenübersicht bildet alle gefundenen und verarbeiteten  Daten ab. Diese werden in zwei verschiedenen Ansichten präsentiert, um die Übersicht zu gewährleisten.
 
###Felderübersicht
Hier werden alle wichtigen Kartendaten angezeigt, dazu gehören die Karte selbst, sowie der erkannte OCR-Text. 

![alt text](https://raw.githubusercontent.com/kaphka/htwmusik/f7524b64e9d6b3f16725bdc42d2a4883f52b56d7/bilder/frontend.jpg "Frontend 1")

1. Auswahl der derzeitigen Übersicht
2. Status der derzeitigen Karte
3. Aus der OCR erfasster Text.
4. Bild der Karte
5. Der aus der OCR gelesene Textabschnitt
6. Gefundene Korrektur
7. Typ aus Katalogübersicht
8. Status des Feldes
9. Speichern oder Löschen von Feldern
10. Erzeugen eines neuen Feldes
11. Speichern der derzeitigen Änderungen
12. Speichern der derzeitigen Änderungen und Versiegeln der Karte

###Korrektur
Der Korrketurtab zeigt alle Änderungen die durch die Korrektur automatisch verarbeitet wurden. Hier ist ersichtlich aus welchen Verzeichnissen die gefundenen Daten erzeugt wurden und weshalb die Änderungen übernommen wurden.

![alt text](https://raw.githubusercontent.com/kaphka/htwmusik/master/bilder/korrektur.jpg "Korrektur")

1. Karte
2. unkorregierter OCR-Text
3. Text nach der Korrektur
4. Teilstück das als Korrekturvorlage diente
5. Korrektur des Teilstückes
6. Basis, auf dessen Grundlage das Teilstück korrigiert wurde.

##Verbesserungen

###Accountmanagement
Das Frontend umfasst kein Accountmanagement. Auch wenn dies nicht genutzt werden soll, um einzelne Nutzer zu überwachen, wäre jedoch die Umsetzung nicht sonderlich kompliziert und würde die Anwendung für weitere Szenarien öffnen, beispielsweise Fremdleistungen.

###Bildscrolling und 16:9
Für die Ansicht wurde sich gewünscht das die Karte beim Scrollen durch die Felder immer sichtbar sein sollte. Dies wurde insofern abgeschwächt, das nun der restliche unbearbeitete Text unter den Feldern sichtbar ist. Hier müsste eruiert werden, ob und inwiefern die Umsetzung vom Bildmitlauf noch gewünscht wäre. Zudem wäre ein Breiteres Design möglich, da das derzeitige noch etwas Freiraum an den Seiten bietet. Es gab jedoch kein uns bekanntes Szenario das einen anderen Aufbau gerechtfertigt hätte. Hier könnten alternative entworfen werden.


#Jobs
Aufgrund der Anzahl der zu bearbeiteten Karten war es sinnvoll ein Job System einzuführen, welches in Teilen eingesetzt wurde.
Die Grundlage dafür bildet Resque, ein Queue System von GitHub https://github.com/resque/resque. Die nötigen Bestandteile von  Resque können durch entsprechende Gems in Rails integriert werden und sind so in der Lage auf entsprechende Ressourcen zuzugreifen.
Hierfür werden Jobs entsprechend der Definition erzeugt und können dann von Workern abgearbeitet werden. Die hierfür nötigen Informationen, werden in Redis abgelegt.

https://docs.google.com/spreadsheets/d/1IwCB8zNoQtqFbDTImsw28fltzyr2qQ-UGqOYK2JXJtU/edit#gid=0

##Vorraussetzungen
Für die Nutzung der Jobs sind folgende Bestandteile notwendig
###Redis 
Redis ist eine in-memory Datenstruktur die auf einem einfachen Key-Value Cache basiert. In diesem werden die Jobs mit ihren Parametern als JSON gespeichert.
Als Beispiel kann folgender JSON String dienen:

`{'class': ExternalInterpreterLookup,'args': [ 1 , ‘normal’ ] }`

Die Klasse beschreibt den Job der durch einen Workern durch den Invoke Process erzeugt wird.

Die Argumente bestimmen die Parameter der `perform()` Methode, die jeder Job anbieten muss.

Zu beachten ist, dass nur Parameter abgelegt werden können, die in einen JSON umgewandelt  werden können. Es ist deshalb notwendig z.B. auf Objekt IDs zurückzugreifen, anstatt auf direkte Objektreferenzen bei der Übergabe an 

`Resque.enqueue(ExternalInterpreterLookup, 1, normal)`

Näheres dazu in der Dokumentation von Resque und Redis https://github.com/resque/resque


###Resque
Resque ist ein Job System, welches die Bestandteile von Redis nutzt, um Jobs zu erzeugen und auszuführen.
Jobs können generell alle Klassen sein die eine `perform()` Methode anbieten, es empfiehlt sich diese jedoch separat zu strukturieren. 
Jobs im Projekt liegen in lib/processing/jobs
Resque bietet mit Workern dann die Basis, Workern erzeugen die entsprechenden Klassen, die ihnen durch Redis übergeben werden und führen die Methode perform() auf diesen aus.
Worker selbst sind Sub-Prozesse die über 

`COUNT=5 QUEUE=* rake resque:workers`

gestartet werden können. Hierbei bestimmt Count die Anzahl der Worker. Im Projekt zeigte sich, dass eine Anzahl von Workern, die die maximale Kernzahl übersteigt, keinen Performancegewinn erzeugt. Teilweise stürzte die gesamte Workerstruktur dadurch hab, Erklärungen gab es dafür keine und es ist möglich das sich das nicht reproduzieren lässt, es ist daher lediglich als Anmerkung zu sehen.

Für die Verwaltuing bietet resque gleich eine Schnitstelle im Frontend mit diese lässt sich mit 

`/resque_web`

aufrufen und bietet eine Übersicht, die zumeist für das debuggen ausreichte. Näheres dazu in der Dokumentation von Resque.

###Datenbankadapter
Es ist notwendig das eine persistente Datenbank zur Verfügung steht, diese muss in Rails definiert sein, da Resque im default diese für seine Jobs benutzt. 
In der Entwicklung wurden MySql und Postgress verwendet. Theoretisch sind auch andere denkbar. 

###Überblick
Es existieren derzeit folgende Jobs im Projekt:

####CardFactory
Da die Notwendigkeit besteht,  alle Karten in den übergebenen Jsons zu Objekte zu überführen, werden hier Karten stückweise angelegt. Hierfür werden die Json-Rohdaten in Teile zerlegt und dann auf mehrere Worker verteilt.

####ExternalWorkLookup
Hier wird das Auflösen von Werken, aus dem Werksverzeichnis durchgeführt. Durch die Korrektur ist davon auszugehen das Werke bereits aufgelöst wurden. Deshalb reicht ein einfaches Matching.

####ExternalInterpreterLookup
Hier wird das Auflösen von Interpreten, aus dem Interpretenverzeichnis durchgeführt.
Für jede Person im Verzeichnis wird eine Suche ausgeführt, dafür werden zuerst volle Namen aus dem Verzeichnis im Text gesucht, dies wäre der Idealfall, sollte die Korrektur gut gearbeitet haben.
Sollte kein Treffer gelandet werden, wird im Text nach Vor- und Nachnamen gesucht.  Dies ist ungenau und kann zu Fehlern führen, umgeht aber Schreibweisen und Einrückungen.

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


###Verbesserungen

####Modularität
Aufgrund von Problemen beim Import und der Verarbeitung der Karten, läuft der Korrekturprozess nicht Modular. Hier konnte keine kurzfristige und zufriedenstellende Lösung gefunden werden, Callbacks zu integrieren, so das Jobs anderen Jobs melden können, wenn diese durchlaufen wurden. Sollte dies umgesetzt sein, kann die Korrektur auch in einen Job ausgelagert werden. Dies gilt dann auch für das Replacement, erst dann wäre das Job System völlig asynchron. Derzeit sind nur nachgelagerte und vorgelagerte Prozesse in Jobs möglich.

Zudem muss für den JobCreator derzeit ein Subprozess generiert werden, der in einem Interval neue JobCreator-Jobs erzeugt, damit dieser wiederum neue nachfolgende Jobs erzeugt. Evtl w#äre es möglich hier einen besseren Ansatz zu finden.

####Datenbasis
Die Datenbasis bildet einerseits die OCR, die sicherlich weiter optimiert werden kann, um die Genauigkeit zu erhöhen, andererseits werden die Werke ect. aus einer Extraktion aus der GND gespeist. Diese stellte sich jedoch als teilweise unzureichend heraus, da viele Daten unberücksichtigt sind. Daraus resultiert, das viele Karten ungenügend aufgelöst werden. Könnten hier mehr Daten angereichert werden, wäre eine Verbesserung, einerseits der Korrektur, andererseits der Auflösung möglich.

####Signaturgenauigkeit
Derzeit sind Signaturen durch RegEx-Begriffe ausgezeichnet. Diese sind für Treffer sehr genau, zeigten jedoch, dass es durchaus Gemeinsamkeiten in der fehlerhaften Erkennung von Zeichen im OCR-Text gibt. 
So werden oft "S" oder "5" als jeweilige Partner vertauscht. 
Beispiel: "55 CD 131543" wird zu "5S CD 131S43"
Durch diesen Umstand ist es schwierig korrekte Signaturen umzusetzen, dies liegt vor allem daran, dass Signaturen teilweise mehrdeutige Schreibweisen besitzen, so existieren 55 CD XX, sowie CD XX. Eine Fehlerkennung ist deshalb nicht ausgeschlossen, wenn die vorangestellten Zeichen nicht richtig durch die OCR erkannt wurden.
eindeutige Signaturen sind derzeit sehr zuverlässig und können durch die Ersetzungsregeln auch dann gefunden werden, wenn diese Fehlerbuchstaben enthalten.
So lassen sich Signaturen wie DMS XX oder NUS XX leicht erkennen und lieferten im Test sehr gute Ergebnisse. Probleme bereiten vor allem sehr uneindeutige Signaturen wie CD oder sehr lange Signaturen, da die Fehlerrate mit der Länge der Signaturen zunimmt. Aufgrund dieser Tatsache, wäre es Ratsam, die Signaturen aus den Kartenbildern direkt zu extrahieren und so zumindest die Datenbasis, die derzeit beim ganzen OCR-Text liegt zu begrenzen. Mit unseren Mitteln, war dies jedoch bisher nicht möglich.
Dies würde zumindest die Fehlerrate senken, die durch verdrehte Buchstabenkombinationen im Quelltext aufkommen.




#Allgemeine Verbesserungen

Dieses Kapitel umfasst alle Vorschläge zu Verbesserungen und Ideen, die sich nicht einem bestimmten Themengebiet zuordnen lassen.

##Schnittstellen
Derzeitig liegen alle Daten die erfasst wurden nur im System selbst vor, dies Umfasst die Datenbank, den ElasticSearch und die Kartenbilder selbst.
Der Hauptaugenmerk lag in der allg. Verfügbarkeit und Machbarkeitsstudie des Projektes. Trotz Fehlerraten und Misserkennung wäre aber bereits eine Nutzung denkbar. Hierfür müssten Schnittstellen definiert werden über die diese Daten abgerufen werden könnten.

##Nutzung der Daten
Evtl. wären auch weitere Nutzungsszenarien denkbar, die bisher nicht in Erwägung gezogen wurden, da schlicht keine Daten außer den Bildern zur Verfügung standen. So wäre eine experimentelle Suche möglich die die Ergebnisse auf Wunsch dem allg. Datenbestand hinzufügt, um diese für die Öffentlichkeit zugänglich zu machen.

Meilensteine
Als agiles Projekt konzipiert und durchgeführt, änderten sich Teilaspekte durch anhaltende Wöchentliche Meetings, jedoch blieben die Ziele im allg. gleich.

So definiert sich als Hauptziel, die Entwicklung eines Systems zur Verarbeitung von Kartenbildern und Überführung in ein System mit anschließender Fehlerkorrektur, Datenaufbereitung/Visualisierung, sowie evtl. Datenextraktion.
Daraus definieren sich Meilensteine die im Wochenplan festgehalten wurden. Diese unterscheiden sich je nach Anwendungsgebiet.
Der größte Meilenstein des Projektes, war klar die Präsentation auf der Messe der HTW, diese war ein voller Erfolg, so dass das Projekt als solches als Erfolg verbucht werden kann, auch wenn nicht alle Meilensteine gänzlich erfüllt wurden.
Die Meilensteine definieren sich aus dem aktuellsten Wochenplan, der für das Projekt angelegt wurde.
OCR
TODO JAKOB: Hast du alles erreicht?

Korrektur
Im Großen und Ganzen wurden alle Meilensteine abgearbeitet und umgesetzt. Dazu gehört das entwickeln eines Systems inkl. ElasticSearch integration, der Prozessmodelierung und Abarbeitung, Entwicklung eines Persitenzmodels, Anlegen eines Jobsystems für asynchrone Tasks, Korrektur von Ergebnissen auf Basis von GND Daten.
Aufgrund der Veränderung des Prozesses, wurden GND Daten nichtmehr Live über Pazpar2 abgerufen, sondern extern extrahiert. Dies schließt Daten externer Anbieter derzeit aus, da dafür keine Daten erhoben wurden, in diesem Punkt kann nur eine Teilweise Erfüllung angesehen werden.
Die Technik dahinter ist jedoch vorhanden, so dass einfach weiteren Daten importiert werden können, wen diese erhoben wurden.
Durch Zeitmangel vor allem am Ende des Projektes, wurde die Accountverwaltung nicht implementiert, diese war zwar immer optimal, war aber theoretisch im ersten Plan festgehalten.
Der Export von Daten war theoretisch vorgesehen, wurde jedoch nicht umgesetzt, dies würde neu kalkuliert werden müssen.



Ergebnisse
Für das Masterprojekt 1 und 2 wurde ein System Entwickelt, das aufzeigt, dass eine automatisierte Erfassung technisch möglich ist. So wurden Bilder in Texte umgewandelt und anschließend versucht, diese zu korrigieren, um abschließend Daten aus diesen gewinnen zu können.
Die Ergebnisse sind sehr stark abhängig vom gewählten Katalog und der Qualität desselben. So spielte auch die Sprache eine große Rolle, da die OCR ursprünglich auf Englischem Text trainiert wurde. Dies führt zu einer verschobenen Spracherkennung. Dies kann mit mehr validen Trainingsdaten umgangen werden, wofür jedoch eine händische Erfassung notwendig wäre. Dies wäre deshalb voraussichtlich ein Problem an Ressourcen.
Mit Verbesserung der OCR, ist davon auszugehen das sich das Ergebnis aller anderen Schritte anhebt. Da dies jedoch nicht zu 100% erreicht werden kann, produziert die Korrektur bereits zufriedenstellende Ergebnisse. Diese ist jedoch abhängig von den bereits erhobenen Daten. So zeigte sich, dass vor allem die Inhalte der Karten selbst ein Problem darstellen, da diese zwar logisch strukturiert sind, jedoch nicht ausreichend klare Daten beinhalten. Da dies die letzte Instanz in der Kette vor der Nutzerinteraktion darstellt, sind hier die Korrekturen maßgeblich, dazu gehören natürlich auch die Fehlerraten die durch die Korrektur selbst erzeugt werden. Die abschließende Extraktion stützt sich dann auf die korrekte Korrektur, weshalb dort Misserkennung  das größte Problem darstellt. Sollten Bestandteile weder durch die OCR noch durch die Korrektur genau ermittelt worden sein, ist es sehr schwierig Daten zu erheben. Dies zeigte sich Maßgeblich an den Signaturen, die je nach Katalogart sehr durchwachsende oder sehr gute Ergebnisse lieferten.
Maßgeblich ist hier auch die Datenbasis die zugrunde liegt, Daten die nicht existieren, können nicht gefunden werden, weshalb eine weitere Datenspeisung ratsam ist.
Trotz der angesprochenden Probleme, zeigt das Projekt, das es möglich ist, maschinell Daten zu erheben. Diese entsprechen jedoch voraussichtlich nicht den Anforderungen die ein Bibliothekar an seine Sammlung stellt. Hierbei ist jedoch zu betrachten, das Daten die nicht existieren, nicht gefunden werden können und so das in Kauf nehmen von Fehlerraten besser wäre, als 100%tige Ergebnisse. Jedoch ist eine Fehlerrate gegen Null immer anzustreben, weshalb eine weitere Beschäftigung mit dem Projekt ratsam ist.
