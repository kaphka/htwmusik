# Erschließungs- und Visualisierungswerkzeuge für den Imagekatalog der Musikabteilung der Staatsbibliothek zu Berlin

### Kernaspekte: OCR, Information Retrieval, Information Visualization, Linked Data

Der „Alphabetische Imagekatalog der Musikabteilung“ umfasst ca. eine Million gescannte Katalogzettel, die mittels einer Web-Anwendung interessierten Nutzerinnen und Nutzer präsentiert werden (http://musikipac.staatsbibliothek-berlin.de/catalog/toc). Um diese teils unikalen Bestände der Staatsbibliothek besser durchsuchbar zu machen, muss der Katalog mittelfristig einer Retrokonversion (http://de.wikipedia.org/wiki/Retrokonversion) unterzogen werden. Ziel des Projektes ist es, geeignete Werkzeuge zu entwickeln, die sowohl Bibliothekarinnen und Bibliothekare sowie Nutzerinnen und Nutzer bei folgenden Tätigkeiten zu unterstützen:

1. Überführung der teils handschriftlichen, mehrsprachigen Katalogscans in ein strukturiertes Datenformat, welches z.B. Signaturen, Komponisten oder Titel umfasst

2. Durchsuchung des erzeugten, fehlerhaften Datenbestands mittels geeigneter Information-Retrieval-Algorithmen

3. Visualisierung des entstandenen Datenraums z.B. mittels Cluster-Algorithmen, um ähnliche Datensätze darzustellen

4. Präsentation der Arbeitsergebnisse mittels einer Web-Anwendung, die gängigen Usability- und Accessibility-Anforderungen genügt

Um die vier Aufgabengebiete zu bearbeiten bietet sich der Einsatz folgender Technologien an bzw. sind folgende Anforderungen denkbar.

## Aufgabengebiet 1

* Mustererkennung und Segmentierung, um bestimmte Bereiche auf einem Katalogzettel seiner Funktion (z.B. Signaturnummer) zuzuordnen
* Training und Anpassung von OCR-Software (z.B. Tesseract OCR) aufgrund der Mehrsprachigkeit und der teils handschriftlichen Beschriftung der Zettel
* Plausibilitätsüberprüfung der zu erwartenden OCR-Ergebnisse durch den Abgleich mit bibliothekarischen Normdaten (z.B. Existenz des Komponistennamens)
* Speicherung dieser Daten in maschinenlesbaren Form

## Aufgabengebiet 2

* Aufbau eines Information-Retrieval-Systems (z.B. SOLR oder ElasticSearch), welches mit den erzeugten, fehlerbehafteten Daten umgehen kann
* Bereitstellung gängiger Informationssuche-Strategien wie Faceted Navigation, Browsing und Keyword/Bag-of-Words-Queries
* Evaluierung des Systems

## Aufgabengebiet 3

* Clustering der entstandenen Daten nach verschiedenen Ähnlichkeitskriterien (z.B. Schreibung des Komponisten), um falsch erkannte Datensätze einfach korrigieren zu können oder verwandten Aufnahmen zu finden (vgl. der „Meinten Sie…“-Funktion von Google)
* Untersuchung möglicher Explorationsmöglichkeiten des entstandenen Datenraums
* Web-basierte Präsentation der Cluster-Visualisierung und Ermöglichung der Editierung bereits bestehender Datensätze

## Aufgabengebiet 4
* Präsentation der Ergebnisse mittels einer Web-Anwendung (kein Java, kein Flash) für Nutzerinnen und Nutzer der Staatsbibliothek
* Implementierung einer internen Web-Anwendung, welche die Bearbeitung und Exploration der erzeugten Daten ermöglicht

Für die Staatsbibliothek zu Berlin hat das Projekt einen deutlich experimentellen, forschungsnahen Charakter, d.h. dass uns bewusst ist, welche Probleme gerade die Erkennung von handgeschriebenen Katalogzetteln bereitet. Um trotzdem alle vier Aufgabengebiete bearbeiten zu können, bietet es sich deshalb an, zuerst mit maschinengeschriebenen Katalogzetteln zu beginnen und sich dann nach und nach an die komplizierten Zettel heranzuwagen.