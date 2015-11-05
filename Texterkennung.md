# Texterkennung

## Zielstellung
Anwendung und Anpassung eines OCR-Verfahrens um
eine ausreichend hohe Genauigkeit zu erhalten (> 95%)

## Evaluation 
Abbleich mit korrigierten Daten ("ground truth").

# Probleme
## Datenformat
Ocropy und Tesseract nutzen hOCR: https://de.wikipedia.org/wiki/HOCR_(Standard)
PAGE XML (http://www.primaresearch.org/tools.php)

## Unterschiedliche Dokumenttypen
* Was könnte sich auf der Karte befinden? Trenner, Schreibmaschinenschrift, Korrekturen, Handschriften
* Testset: Kartenid -> Kartentyp

## Kategorisierung von Segmenten
Ist die Erkennung von Korrekturen, Stempeln, Unterstreichungen hilfreich?


## Durchführung
### Trainingsdaten erstellen
OCR für alle Karten
* manuelles Korrigieren und Kategorisieren 
* Rechtschreibkontrolle auf Segmente
* Autoren und Eigennamenerkennung

"ground truth" in einen Git-Repository speichern
csv-Datei für Kartenkategorie
.gt.txt-Datei pro Textzeile

Aufteilen der Daten in Trainings- und Testset (70:30 Split)

### OCR trainieren
