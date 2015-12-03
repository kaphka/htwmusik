# Texterkennung

## Zielstellung
Anwendung und Anpassung eines OCR-Verfahrens um
eine ausreichend hohe Genauigkeit zu erhalten (> 95%)

## Ergebniss
Textinhalt jeder Karte( und jedes Kartensegments)

## Evaluation 
Abbleich mit korrigierten Daten ("ground truth").

# Probleme
## Datenformat
Formate und Konvetionen können sich je nach Tool unterscheiden.
Ocropy und Tesseract nutzen hOCR: https://de.wikipedia.org/wiki/HOCR_(Standard)
PAGE XML (http://www.primaresearch.org/tools.php)

## Unterschiedliche Dokumenttypen
Eine Kategorisierung der Karten nach verwendeter Schrift wird wahrscheinlich eine wichter
Punkt bei der Texterkennung sein. Im Katalog 2 gibt es zwar nur wenige Schrifttypen, 
aber der Katalog 1 hat Karten mit sehr unterschiedlichen Handschriften und Schreibmaschinenschriften.

## Durchführung
![Durchführung](/bilder/ocr-detail-entwurf.jpg)
### Trainingsdaten erstellen
OCR für alle Karten anwenden
Möglichkeiten um mehr Trainingsdaten zu erhalten:
* Die Arbeit des manuelles Korrigieren und Kategorisieren verteilen (Webapp im Stil von Mechanical Turk?)
* Rechtschreibkontrolle auf Segmenteanwenden und korrekte Segmente als ground truth akzeptieren
* Autoren und Eigennamenerkennen und korrigieren

"ground truth" in einen Git-Repository speichern
csv-Datei für Kartenkategorie
.gt.txt-Datei pro Textzeile oder csv mit allen Segmenten + Text

Aufteilen der Daten in Trainings- und Testset (70:30 Split)

### OCR trainieren
Evaluierne von:
* https://github.com/tesseract-ocr
* https://github.com/tmbdev/ocropy
* https://github.com/tmbdev/clstm
