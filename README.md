# Einführung in Datasette

Datasette ist ein Werkzeug, das es Nutzer:innen ermöglicht, Datensätze zu analysieren und zu erforschen, sie dynamisch zusammenzustellen und zu exportieren. Datasette ermöglicht exploratorische Datenanalyse (EDA), Datenvisualisierungen und -export. Es setzt auf SQLite-Datenbanken auf, d.h. auf einer Programmbibliothek, die ein relationales Datenbanksystem enthält. Abfragen können standardisiert oder durch Nutzer:innen individuell in der Datenbanksprache SQL formuliert werden. Datasette stellt ein grafisches Web-Interface bereit, das über den Browser abgerufen werden kann. Hier können sich Nutzer:innen zunächst einmal mit Hilfe verschiedener Werkzeuge mit den tabellarischen Daten vertraut machen, bevor sie komplexere Analysen oder Visualisierungen vornehmen.

Datenbanktabellen haben Spalten und Zeilen. Im Idealfall sind es \"tidy data\". Sie folgen dami einem Konzept, das Hadley Wickham entwickelt hat, siehe [https://doi.org/10.18637/jss.v059.i10](https://doi.org/10.18637/jss.v059.i10). Die Grundidee von \"tidy data\" ist ihre spezifische Struktur:
- Jede Variable bildet eine eigene Spalte
- Jede Beobachtung bildet eine eigene Zeile
- Jeder Typ einer beobachtbaren Einheit bildet eine Tabelle

Anders als Exceltabellen können die Zellen von Datenbanktabellen nicht zusammengefasst oder formatiert werden.\
Jede Spalte in einer Datenbanktabelle hat einen Typ. In SQLite können das *integer*, *real* oder *text* sein (für Gleitkommawerte), oder *blob* (für Binärdaten). Der Typ der Spalte ist wichtig, weil er sich darauf auswirkt, was passiert, wenn die Tabelle nach dieser Spalte sortiert wird, oder welche mathematischen Operationen für diese Werte verwendet werden können.

Da SQLite-Datenbanken relational sind, kommt es vor, dass eine Spalte in einer Tabelle auf eine Spalte in einer anderen Tabelle verweist. In der angezeigten Tabelle werden diese Zellen dann als Links hervorgehoben. In einer Datenbank werden diese Links als \"Fremdschlüssel\" bezeichnet - sie funktionieren, indem sie die ID einer Zeile aus einer anderen Tabelle in einer speziellen Fremdschlüsselspalte speichern. Anhand von Fremdschlüsseln wird deutlich, warum relationale Datenbanken so viel leistungsfähiger sind als voneinander separierte Tabellen oder Datendateien, die in einem Format wie CSV gespeichert werden. 

In der Standardansicht gibt es ein Suchfeld, über das die Inhalte sämtlicher Datenbankfelder in der aktuellen Tabelle abgefragt werden (Wert eingeben und Enter drücken). Alternativ können sämtliche Spalten einzeln ausgewählt sowie ein Operator (=, !=, starts with, usf.) festgelegt werden und dann nach einem bestimmten Wert in dieser Spalte gesucht werden.

Unterhalb des Abfragebereichs werden dann die Ergebnisse ausgegeben: Eine Ergebnisliste; falls vorhanden, eine Visualisierung; darunter der Ergebnisauszug aus der Tabelle. Bei den meisten Spalten können weitere Einstellungen über das Zahnrad vorgenommen werden: Auf- oder absteigende Sortierung, Spalte verbergen, oder die Auswahl der Spalte als Facette. Ein Klick auf das Zahnrad zeigt darüber hinaus an, welchen Datentyp eine Tabellenspalte enthält (s.o.), eine Information, die für die Eingabe / Suche wichtig ist.

Facetten sind eine der leistungsfähigsten Datasette-Funktionen. Mit ihrer Hilfe können aus einer Tabelle mit Tausenden von Zeilen schnell interessante Trends und Muster in diesen Daten erkannt werden. Facetten können auf zwei Arten angewendet werden: Man kann eine Option aus der Liste \"suggested facets\" auswählen, oder man kann die Option \"Facet by this\" aus dem Zahnradmenü neben jeder Spalte auswählen.

Jede Facette zeigt eine Liste der häufigsten Werte für diese Spalte an, mit einer Gesamtzahl für jeden dieser Werte. Diese Zahlen werden aktualisiert, wenn die Daten weiter gefiltert werden; dazu wird wieder das Zahnrad benutzt. Wählt man eine Facette aus, dann wendet man einen Filter auf die Daten an. Das sieht man dann auch an den Boxen am Kopf der Seite.

Jede Seite in Datasette ist so konzipiert, dass sie weitergegeben werden kann. Dazu kann man einfach die URL der Seite kopieren und dort einfügen, wo sie geteilt werden soll. Dies gilt auch für angewandte Filter und Facetten.

Rohdaten in Datasette können im Format csv und .json exportiert werden. Das Feld \"Adavanced Export\" bietet zusätzliche Optionen. Der Knopf \"download file\" kann genutzt werden, um die CSV-Datei auf den Computer herunterzuladen. Die Option \"expand labels\" fügt eine zusätzliche Spalte mit der Beschriftung hinzu, die mit den Fremdschlüsselspalten verbunden ist. Zusätzliche Formate können über Plugins aktiviert werden. Datasette kann auch so konfiguriert werden, dass Benutzer die gesamte Datenbank als eine einzige Datei herunterladen können. Das macht allerdings nur bei überschaubar großen Datenbanken Sinn.

Datenvisualisierungen werden in Datasette über Plugins realisiert. Hier werden etwa interaktive Karten oder Cluster-Maps angeboten.


# SQL-Tutorials

## Basis-Abfragen

Jede SQL-Abfrage enthält die drei Hauptbefehle `select` (engl. auswählen), `from` (engl. von) und `where` (engl. wo). Mit select gibt man an, welche Spalten der aktuell gewählten Tabelle man ausgegeben haben möchte; mit from gibt man die Tabelle an, aus der die Spalten stammen; mit where gibt man die Bedingung an, unter der die Datensätze ausgesucht werden. Where muss nicht vorkommen, wenn es keine Bedingung gibt. Mit den Operatoren <, <=, =, <>, >= und > kann man Vergleichsbedingungen in der where-Klausel formulieren.


Beispiel-Abfragen:
Aus der Tabelle Text soll der Volltext eines einzelnen Werks exportiert werden. Das Werk ist über die PPN (Pica Production Number) identifizierbar. Um den Volltext aller einzelnen Seiten zu erhalten, werden die Seiten aufsteigend sortiert.
Abfrage: Zeige mir in der Tabelle volltext das Werk mit der PPN 770575986 in der aufsteigenden Reihenfolge der Seiten an:

select rowid, id, filename, PPN, text from volltext where PPN = "PPN770575986" order by filename

Jede Seite in Datasette ist so konzipiert, dass sie weitergegeben werden kann. Dazu kann man einfach die URL der Seite kopieren und dort einfügen, wo sie geteilt werden soll. Dies gilt auch für angewandte Filter und Facetten. Rohdaten in Datasette können im Format csv und .json exportiert werden. 

### SQL-Tutorial online
- Einführung deutsch: [https://sql-tutorial.de/home/start.php](https://sql-tutorial.de/home/start.php)
- Full Text Search fts: [https://sqlite.org/fts5.html](https://sqlite.org/fts5.html)

# Use Cases für die dynamische Zusammenstellung und den Export von Kulturdaten

Die datasette-Instanz der Staatsbibliothek zu Berlin findet sich unter diesem Link (nur über SPK-VPN erreichbar):
[http://datasette.lx0246.sbb.spk-berlin.de/](http://datasette.lx0246.sbb.spk-berlin.de/)

**Vorbemerkung:**
Diese Datasette-Instanz ermöglicht SQL-Abfragen über vier Datenbanken: 

Die Datenbank DigiSam (mit den Untertabellen volltext, sprachinfo, modsinfo, volltext_mit_titel_und_ort) stellt eine Volltextdatenbannk dar, die aus den [digitalisierten Sammlungen der Staatsbibliothek zu Berlin](https://digital.staatsbibliothek-berlin.de/) generiert wurde.

Eine zweite Datenbank (ARK-MetaData) ermöglicht die Analyse der Metadaten von 2,6 Millionen Titeln des [Alten Realkatalogs](https://ark.staatsbibliothek-berlin.de/) der Staatsbibliothek zu Berlin.

Eine dritte Datenbank (DigiSam-Win-IBW) enthält sämtliche Metadaten der in den digitalisierten Sammlungen enthaltenen Werke (auch der Archivalien), aber aus einer anderen Datenquellen, nämlich dem Verbundkatalog K10plus; vergleiche dazu die Ausführungen unten.

Die vierte Datenbank (_memory) macht Abfragen über unterschiedliche Datenbanken hinweg möglich. Man kann also z.B. die DigiSam-Win-IBW gegen die ARK-MetaData über einen gemeinsamen Identifikator joinen.

Die Tabelle [volltext](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/volltext) enthält fast fünf Millionen Seiten Volltexte von 28.909 Werken. Die Tabelle [modsinfo](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/modsinfo) enthält Metadaten der von der Staatsbibliothek zu Berlin digitalisierten Werke. Die Tabelle [sprach_info](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/sprach_info) enthält automatisch bestimmte Angaben zur Sprache auf jeder Volltextseite sowie zur Konfidenz dieser Angabe (Erwartungsbereich). Die Tabelle [volltext_mit_titel_und_ort](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/volltext_mit_titel_und_ort) ermöglicht eine Visualisierung der Druckorte der digitalisierten Werte bzw. eine Recherche über Längen- und Breitengrade. Alle Tabellen enthalten eine Spalte mit Identifikatoren; hierfür wird die PPN genutzt, d.h die **P**ica **P**roduction **N**umber, die im deutschen Bibliothekssystem benutzt wird. PPNs sind eindeutige Identifikatoren, die auch für jedes Werk in den [Digitalisierten Sammlungen der Staatsbibliothek zu Berlin](https://digital.staatsbibliothek-berlin.de/) verwendet werden. Beispielsweise findet sich die PPN63354499X im Link zu diesem Werk https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN63354499X in den digitalisierten Sammlungen.

Im folgenden werden Beispiele für SQL-Abfragen präsentiert, die es den Nutzenden ermöglichen sollen, die Logik dieser Abfragen zu verstehen und selbst SQL-Abfragen zu formulieren. Grundsätzlich sind die SQL-Queries in der Tabelle [volltext](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/volltext) auszuführen. Die einzige Ausnahme bilden Suchen, die innerhalb der einzelnen Textseiten bzw. im ganzen Korpus ausgeführt werden; vergleiche dazu die Ausführungen unten.



#  Inhaltsverzeichnis

- [Zusammenstellung von Datensets](#zusammenstellung-von-datensets)
	- [Einzelnen Text oder Textkorpus zusammenstellen und exportieren](#einzelnen-text-oder-textkorpus-zusammenstellen-und-exportieren)
  		- [Einzelnen Text exportieren](#einzelnen-text-exportieren)
  		- [Textkorpus nach PPN exportieren](#textkorpus-nach-ppn-exportieren)
  		- [Textkorpus nach Begriffen im Werktitel identifizieren](#textkorpus-nach-begriffen-im-werktitel-identifizieren)
  		- [Textkorpus nach Sprache identifizieren](#textkorpus-nach-sprache-identifizieren)
  		- [Textkorpus über Suchworte im Text identifizieren](#textkorpus-über-suchworte-im-text-identifizieren)
  		- [Textkorpus nach Publikationsdatum und Ort zusammenstellen](#textkorpus-nach-publikationsdatum-und-ort-zusammenstellen)
 	- [Suche über Schlagworte](#suche-über-schlagworte)
 	- [Suche über Kategorien oder Materialart](#suche-über-kategorien-oder-materialart)
 	- [Suche über technische Metadaten](#suche-über-technische-metadaten)
 		- [Umfang der Werke](#umfang-der-werke)
 	- [Suche über Visualisierung auf Karte](#suche-über-visualisierung-auf-karte)
 - [Datenanalyse und Bibliometrie](#datenanalyse-und-bibliometrie)
 	- [Sprachen](#sprachen)
  		- [Auszählung Seiten nach Sprache](#auszählung-seiten-nach-sprache)
  		- [Auszählung Werke nach Sprache](#auszählung-werke-nach-sprache)
	- [Auszählung Publikationsort, Publikationsdatum oder Anzahl der Seiten](#auszählung-publikationsort-publikationsdatum-oder-anzahl-der-seiten) 
		- [Publikationsort](#publikationsort)
		- [Publikationsjahr](#publikationsjahr)
		- [Anzahl der Seiten](#anzahl-der-seiten)
- [Ein Bilddatenset erstellen](#ein-bilddatenset-erstellen)
- [Download von Volltexten und Bildern über die Schnittstellen der Staatsbibliothek zu Berlin](#download-von-volltexten-und-bildern-über-die-schnittstellen-der-staatsbibliothek-zu-berlin)
- [Anhang Erläuterungen zu den Datenquellen](#anhang-erläuterungen-zu-den-datenquellen)



# Zusammenstellung von Datensets

## Einzelnen Text oder Textkorpus zusammenstellen und exportieren
Zusammenstellung von Datensets anhand formaler (Publikationsdatum, Sprache), technischer (Metadaten, Seitenformate) und inhaltlicher (Titel, Schlagworte, Kategorien, Volltextsuche) Kriterien aus den Recherchesystemen der SBB



### Einzelnen Text exportieren
Über die digitalisierten Sammlungen einen Text identifizieren (Volltext muss vorhanden sein) und die PPN notieren. Die PPN dann in die folgende SQL-Query eingeben; PPNs benötigen immer Anführungszeichen und beginnen mit PPN:

```sql
select rowid, id, filename, PPN, text
from volltext
where "PPN" = 'PPN63354499X'
order by filename
```
(33 Zeilen)

Auf der Ergebnisseite finden sich dann links, über die das Ergebnis als [.json](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam.json?sql=select+rowid%2C+id%2C+filename%2C+PPN%2C+text%0D%0Afrom+volltext%0D%0Awhere+%22PPN%22+%3D+%27PPN63354499X%27%0D%0Aorder+by+filename) oder [CSV](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam.csv?sql=select+rowid%2C+id%2C+filename%2C+PPN%2C+text%0D%0Afrom+volltext%0D%0Awhere+%22PPN%22+%3D+%27PPN63354499X%27%0D%0Aorder+by+filename&_size=max) exportiert werden kann.

### Textkorpus nach PPN exportieren
Über die digitalisierten Sammlungen ein Textkorpus identifizieren und die PPNs notieren.

Bei der folgenden Abfrage zuerst wird zuerst nach PPN, dann nach filename sortiert.

```sql
select rowid, id, filename, PPN, text
from volltext
where "PPN" in ('PPN633196762', 'PPN63354499X', 'PPN636876446', 'PPN636879666', 'PPN641477597')
order by PPN, filename
```
(5 Texte, zusammen 801 Zeilen)


### Textkorpus nach Begriffen im Werktitel identifizieren
Suche nach einem exakten Werktitel: "Kriegslieder und Kriegsgedichte"

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, [originInfo-publication0_dateIssued], filename, volltext.PPN, text
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and titleInfo_title = "Kriegslieder und Kriegsgedichte"
order by filename
```
(29 Zeilen)

Suche nach Werken mit "Gedichte" im Titel

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], filename, volltext.PPN, text
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and titleInfo_title like "%Gedichte%"
and "originInfo-publication0_dateIssued" = "1914"
order by modsinfo.PPN, filename
```
(279 Zeilen)

Suche nach Werken mit dem Begriff "Erzählung" im Untertitel

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], filename, volltext.PPN, text
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and titleInfo_subTitle like "%Erzählung%"
and "originInfo-publication0_dateIssued" = "1914"
order by modsinfo.PPN, filename
```
(3 Werke, 595 Zeilen)

### Textkorpus nach Sprache identifizieren

Hierzu wird die Tabelle [modsinfo](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/modsinfo) benutzt. Sie enthält bibliothekarisch erfasste Sprachangaben zu ganzen Werken. Die für dieses Beispiel gewählte Sprache ist "rus" [nach ISO 639-2 Russisch](https://www.loc.gov/standards/iso639-2/php/code_list.php). Die SQL-Abfrage lautet:

```sql
select modsinfo.PPN, name0_displayForm as Autor, language_languageTerm as Sprache, [originInfo-publication0_dateIssued] as Erscheinungsjahr
from modsinfo
where "language_languageTerm" = "rus"
order by Erscheinungsjahr
```
(72 Zeilen bzw. Werke; hier müssen dann zunächst die PPNs extrahiert und anschließend wie oben beschrieben die Volltexte exportiert werden)

**Zum Vergleich:** Man kann auch die Tabelle [sprach_info](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/sprach_info) nach den auf einzelnen Seiten erkannten Sprachen abfragen. Die Tabelle "sprach_info" enthält automatisch generierte Sprachangaben zu einzelnen Seiten sowie Konfidenzen zur Verlässlichkeit dieser Angabe. Die für dieses Beispiel gewählte Sprache ist "ru" [nach ISO 639-1 Russisch](https://www.loc.gov/standards/iso639-2/php/code_list.php); die Konfidenz soll höher oder gleich 80% sein; sortiert wird zuerst nach PPN, dann nach filename. Angezeigt werden die ersten 1.500 Zeilen, derzeit ist die Anzeige bzw. der Export auf diese Zahl limitiert.

```sql
select rowid, id, PPN, filename, language, confidence
from sprach_info
where "language" = "ru" and "confidence" >= 0.8
order by PPN, filename
```
(mehr als 1.500 Zeilen)

Die über die obige Suche identifizierten PPNs werden durch folgende Suchabfrage aufgelistet:

```sql
select distinct(PPN)
from sprach_info
where "language" = "ru" and "confidence" >= 0.8
order by PPN
```
(63 Zeilen)

### Textkorpus über Suchworte im Text identifizieren

Für die Suche nach Begriffen oder Phrasen kann ausschließlich die Tabelle [volltext](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/volltext) genutzt werden. Dort gibt es ein Suchfeld ("Search"), in das ein einzelnes oder mehrere Wörter eingegeben werden können. Wird eine bestimmte Phrase gesucht, muss diese durch Anführungszeichen umschlossen werden.

**Beispiele:**
Die Suche nach dem Begriff "Satrapen" (ohne Anführungszeichen) liefert 136 Zeilen, d.h. auf 136 Textseiten kommt dieser Begriff mindestens einmal vor. Die Suche mit den zwei Begriffen "Silbermünzen Satrapen" (ohne Anführungszeichen) liefert zwei Zeilen: PPN768209382 und PPN636879666, wobei die beiden Begriffe gemeinsam (aber unverbunden) auf einer Textseite vorkommen. Die Phrasensuche "Silbermünzen der Satrapen" (**MIT** Anführungszeichen) liefert nur eine Zeile (PPN636879666). 


**Wortteile:**
Darüber hinaus kann auch nach Wortteilen gesucht werden. Dies geschieht über eine SQL-Query in der Datenbank [DigiSam](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam). Für die Suche wird der zu suchende Begriff mit Prozentzeichen % umschlossen; diese stehen für eine beliebige Folge von Zeichen, d.h. es werden ggf. auch Wortteile angezeigt.

SQL-Query zur Abfrage eines einzelnen Wort / eines Wortteils im Text:

```sql
select rowid, id, filename, PPN, text
from volltext
where "text" like '%Diphtheritis%'
```
(819 Zeilen)

Ähnliche Abfrage, Diphteritis mit nur einem h:

```sql
select rowid, id, filename, PPN, text
from volltext
where "text" like '%Diphteritis%'
```
(180 Zeilen)

SQL-Query nach mehreren Suchworten im Text, hier "Diphteritis" und "Cholera":

```sql
select rowid, id, filename, PPN, text
from volltext
where "text" like '%Diphteritis%' and "text" like '%Cholera%'
```
(53 Zeilen, d.h. 53 Textseiten auf denen beiden Begriffe mindestens je einmal vorkommen)

Der Unterschied zwischen beiden Suchmöglichkeiten wird an folgendem Beispiel deutlich: \
Die unscharfe Suche nach dem Begriff "Diphtheritis" (ohne Anführungszeichen) in der Tabelle [volltext](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/volltext) liefert 786 Zeilen. 
Die Suche nach dem Begriff '%Diphtheritis%' (mit Prozentzeichen) in der Datenbank [DigiSam](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam)

```sql
select rowid, id, filename, PPN, text
from volltext
where "text" like '%Diphtheritis%'
```

liefert 819 Zeilen.

Anders als bei der ersten Suche sind hier weitere Begriffe mit eingeschlossen, beispielsweise "Diphtheritisfälle", "Diphtheritisfällen", "Diphtheritisepidemie", oder auch "diphtheritischen" (denn diese Worte enthalten ja auch "Diphtheritis" als Wortteil)



### Textkorpus nach Publikationsdatum und Ort zusammenstellen
Hierfür wird die Tabelle [modsinfo](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/modsinfo) genutzt, die Metadaten zum digitalisierten Werk enthält, wie etwa Publikationsdatum und -ort. 

Die Abfrage nach einem Datum erfolgt über die Spalte **originInfo-publication0_dateIssued**, die nach einem Ort (z.B. Leipzig) in der Spalte **originInfo-publication0_place_placeTerm**

Alle Werke mit einem bestimmten Publikationsdatum, nur Volltexte:

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_place_placeTerm], [originInfo-publication0_dateIssued]
from modsinfo
where [originInfo-publication0_dateIssued] = 1910 and [mets_fileSec_fileGrp-FULLTEXT-count] > 1
order by modsinfo.PPN
```
(134 Zeilen)

Alle Werke, die an einem bestimmten Publikationsort gedruckt wurden:

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_place_placeTerm], [originInfo-publication0_dateIssued]
from modsinfo
where [originInfo-publication0_place_placeTerm] = "Paris"
order by modsinfo.PPN
```
(566 Zeilen)

Alle Werke aus einem bestimmten Publikationszeitraum:

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_place_placeTerm], [originInfo-publication0_dateIssued]
from modsinfo
where [originInfo-publication0_dateIssued] between 1900 and 1908
order by modsinfo.PPN
```
(1.444 Zeilen)

**Musterabfrage Publikationsort und -datum**

```sql
select [gewünschte Spalten auswählen]
from modsinfo
where "originInfo-publication0_dateIssued" = "XXXX" and "originInfo-publication0_place_placeTerm" = "XXXXX"
order by PPN
```

**Beispielabfrage:**
```sql
select PPN, name0_displayForm, [name0_namePart-given], [name0_namePart-family],  titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [originInfo-publication0_place_placeTerm]
from modsinfo
where "originInfo-publication0_dateIssued" = "1915" and "originInfo-publication0_place_placeTerm" = "Nürnberg"
order by PPN
```
(12 Zeilen)

**Nun die obige Titelliste zusammen mit ihren Volltexten**\
Die Abfrage dieser Titel erfolgt über das Zusammenführen zweier Tabellen in einem **Join**. Dabei wird immer ein Datensatz aus der ersten Tabelle (modsinfo) mit einem Datensatz aus der zweiten Tabelle (volltext) zu einem neuen Datensatz zusammengesetzt. Das macht man natürlich nur für die Datensätze, die auch zusammen gehören, bei denen also der Wert des Primärschlüssels mit dem Wert des Fremdschlüssels übereinstimmt. Bei den digitalisierten Sammlungen ist es ratsam, die PPN als gemeinsamen Schlüssel zu verwenden. Die Gleichheit der beiden Werte wird durch eine entsprechende Bedingung in der where-Klausel ausgedrückt. In der from-Klausel muss man die beiden gewünschten Tabellen angeben. 

**Beispielabfrage:** 

Zunächst werden die Spalten ausgewählt, die angezeigt werden sollen; ist der Spaltenname in zwei Tabellen identisch, müssen diese durch ein vorangestelltes \"Spaltenname.\" angesprochen werden; dann folgt die erste Tabelle, dann die inner join-Abfrage mit der Angabe des gemeinsamen Schlüssels, dann die Angabe der Suchparameter

```sql
select modsinfo.PPN, name0_displayForm, [originInfo-publication0_place_placeTerm], [originInfo-publication0_dateIssued], filename, volltext.PPN, text
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN and "originInfo-publication0_dateIssued" = "1915" and "originInfo-publication0_place_placeTerm" = "Nürnberg"
order by modsinfo.PPN
```
(630 Zeilen)


## Suche über Schlagworte

Nicht alle Schlagwort-Spalten in der Metadaten-Tabelle [modsinfo](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/modsinfo) sind gleichmäßig gut gefüllt. Zur Verfügung stehen die Spalten \"genre-aad\", \"subject-EC1418_genre\", \"classification-ddc\" sowie \"classification-sbb\" und \"classificaton-ZVDD\". Die Spalte \"genre-aad\" entspricht dem von der Arbeitsgemeinschaft Alte Drucke im MARC-Feld hinterlegten Genre (\"Erzählung, Roman, Novelle, Medizin, Tagebuch, Briefsammlung\"); etwa ein Viertel aller Felder sind gefüllt. Die Spalte \"subject-EC1418_genre\" enthält die Genrebezeichnungen, die für das Projekt \"Europeana Collections 1914-1918: Remembering the First World War – a digital collection of outstanding sources from European national libraries\" angelegt wurden; diese Titel beziehen sich auschließlich auf den Ersten Weltkrieg. Hier finden sich rund 25.000 Einträge wie \"album, book, diary, photograph, poem, sheet music, song book, trench journal\". Die Spalte \"classification-ddc\" enthält Einträge mit einer Dewey Decimal Classification Nummer, z.B. 508 für \"Naturgeschichte\", 641 für \"Essen und Trinken\" oder 745 \"Dekorative Künste\"; hier sind etwa 10% der Felder befüllt. Die Spalte \"genre-marcgt\" enthält Genrebezeichnungen nach der MARC Genre Term List, z.B. \"Jugendbuch, Kinderbuch, Anthologie, Lesebuch, Biografie, Schulbuch\"; hier sind ebenfalls nur etwa 10% der Felder befüllt.

**Beispielabfragen:** 

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [genre-aad]
from modsinfo
where "genre-aad" like "%Epikedeion%"
```
(190 Zeilen)

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [subject-EC1418_genre]
from modsinfo
where "subject-EC1418_genre" like "%poem%"
```
(244 Zeilen)

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [classification-ddc]
from modsinfo
where "classification-ddc" like "%745%"
```
(23 Zeilen)

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [classification-sbb]
from modsinfo
where "classification-sbb" like "%Ng%"
```
(64 Zeilen; Ng entspricht Pädagogik/Kinderschriften im [ARK](https://ark.staatsbibliothek-berlin.de/#ebene=76295,76868))

Werden Volltexte in diesen Kategorien gesucht, dann erfolgt dies wieder über einen **Jointable**:

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [subject-EC1418_genre], text
from modsinfo, volltext
where volltext.PPN = modsinfo.PPN
and "subject-EC1418_genre" like "%poem%"
```
(mehr als 1,500 Zeilen)

## Suche über Kategorien oder Materialart

Die Tabelle mit den Metadaten kann nach Kategorien gefiltert werden; diese befinden sich in der Spalte \"classication-ZVDD\".

**Beispielabfragen:**
```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [classification-ZVDD]
from modsinfo
where "classification-ZVDD" like "%Jugendbücher%"
```
(790 Zeilen)

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [classification-ZVDD]
from modsinfo
where "classification-ZVDD" like '%Rechtswissenschaft%'
```
(Mehr als 1.500 Zeilen)

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [classification-ZVDD]
from modsinfo
where "classification-ZVDD" like '%Handschriften%'
```
(16 Zeilen; Achtung: hier kann die OCR minderwertig sein, da keine HTR angewendet wurde)

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [classification-ZVDD]
from modsinfo
where "classification-ZVDD" like '%Einblattdrucke%'
```
(1.266 Zeilen)

Werden Volltexte in diesen Kategorien gesucht, dann erfolgt dies wieder über einen **Jointable**:

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], [classification-ZVDD], filename, volltext.PPN, text
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and "classification-ZVDD" like '%Geschichte / Ethnographie / Geographie%'
```
(mehr als 1,500 Zeilen)

Auch kombinierte Kategorien (wie in der Präsentation der digitalisierten Sammlungen angegeben) können präzise angegeben werden:

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], filename, volltext.PPN, text
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and "classification-ZVDD" = "Historische Drucke, Sprachen / Literaturen"
```
(mehr als 1,500 Zeilen)


## Suche über technische Metadaten

### Umfang der Werke

In der Spalte **mets_fileSec_fileGrp-FULLTEXT-count** finden sich Angaben dazu, wie viele Seiten Volltext vorliegen. Daher kann nach dem Umfang der Werke gefiltert werden. Besonderheit: Zuerst muss die Spalte **mets_fileSec_fileGrp-FULLTEXT-count** vom *character*-Format ins *integer*-Format konvertiert werden.

Beispielabfrage: Alle Werke mit mehr als 699 Seiten

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], cast([mets_fileSec_fileGrp-FULLTEXT-count] as INT) as Seiten_Int
from modsinfo
where Seiten_Int > 699
```
(1.270 Zeilen)

Alle Werke mit mehr als 99, aber weniger als 200 Seiten

```sql
select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, [originInfo-publication0_dateIssued], cast([mets_fileSec_fileGrp-FULLTEXT-count] as INT) as Seiten_Int
from modsinfo
where Seiten_Int > 699
and Seiten_Int < 1000
```
(939 Zeilen)

## Suche über Visualisierung auf Karte 

Hierfür wird die Tabelle [volltext_mit_titel_und_ort](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/volltext_mit_titel_und_ort) genutzt.

Wo wurden die folgenden PPNs gedruckt?

```sql
select rowid, PPN, file, text, latitude, longitude
from volltext_mit_titel_und_ort
where "PPN" IN ('PPN633196762', 'PPN63354499X', 'PPN636876446', 'PPN636879666')
```
(Leipzig, Berlin, München, Wien)

Welche Bücher wurden gemäß [Geo-Koordinaten](https://geohack.toolforge.org/geohack.php?pagename=Shanghai&language=de&params=31.233333333333_N_121.46666666667_E_dim:90000_region:CN-SH_type:city(24870895)&title=Shanghai) in Shanghai (Schreibweisen auch Chang-hai, Chang-Hai, Shanghae, Shang-ʿhai, [Shanghai], [Shanghae], Shanghai [u.a], \"Shanghai, China\") gedruckt?

```sql
select rowid, PPN, file, text, latitude, longitude
from volltext_mit_titel_und_ort
where "latitude" = "31.166666666667" and "longitude" = "121.46666666667"
order by PPN, file;
```
(mehr als 1.500 Ergebnisse)

# Datenanalyse und Bibliometrie

## Sprachen
Welche Sprachen wurden von den Bibliothekar:innen notiert (Tabelle [modsinfo](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/modsinfo))?

```sql
select language_languageTerm as Sprache, count(language_languageTerm) as Häufigkeit
from modsinfo
group by "language_languageTerm"
order by Häufigkeit desc
```
(68 Zeilen)


Welche Sprachen wurden automatisch erkannt (Tabelle [sprach_info](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/sprach_info))?

```sql
select language as Sprache, count(language) as Häufigkeit
from sprach_info
group by "language"
order by Häufigkeit desc
```
(91 Zeilen)

Zeige mir alle Seiten, die  mit einer Konfidenz von über 90% in einer bestimmten Sprache vorliegen (hier: Chinesisch, zh)

```sql
select rowid, id, PPN, filename, language, confidence
from sprach_info
where "language" = "zh" and "confidence" >= 0.9
order by PPN, filename
```
(Mehr als 1.500 Zeilen)

### Auszählung Seiten nach Sprache

Beispiele (nach Tabelle [sprach_info](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/sprach_info)): 

Wieviele Seiten gibt es auf Spanisch?

```sql
select count(PPN) as Anzahl_Seiten
from sprach_info
where "language" = "es"
```
(68.908 Seiten)

Wieviele Werke gibt es auf Spanisch?

```sql
select count(distinct PPN) as Anzahl_Titel
from sprach_info
where "language" = "es"
```
(1.027 Titel)

Wieviele Seiten gibt es auf Spanisch mit einer Konfidenz über 90%?

```sql
select count(PPN) as Anzahl_Seiten
from sprach_info
where "language" = "es" and "confidence" > 0.9
```
(67.936 Seiten)

Wieviele Werke gibt es auf Spanisch mit einer Konfidenz über 90%?

```sql
select count(distinct PPN) as Anzahl_Titel
from sprach_info
where "language" = "es" and "confidence" > 0.9
```
(448 Titel)

Wieviele Werke mit Seiten in Spanisch wurden zwischen 1600 und 1920 publiziert (nach Tabelle [sprach_info](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/sprach_info))?

```sql
select language as Sprache, [originInfo-publication0_dateIssued] as Publikationsjahr, count(distinct volltext.PPN) as Häufigkeit
from sprach_info, modsinfo, volltext
where sprach_info.PPN = modsinfo.PPN
and sprach_info.PPN = volltext.PPN
and language = "es"
and [originInfo-publication0_dateIssued] between 1600 and 1920
group by "originInfo-publication0_dateIssued"
order by Publikationsjahr asc
```
(150 Zeilen)

Wieviele Werke auf Spanisch wurden zwischen 1600 und 1920 publiziert (nach Tabelle [modsinfo](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/modsinfo))?

```sql
select language_languageTerm as Sprache, [originInfo-publication0_dateIssued] as Publikationsjahr, count(distinct volltext.PPN) as Häufigkeit
from modsinfo, volltext
where volltext.PPN = modsinfo.PPN
and language_languageTerm = "spa"
and [originInfo-publication0_dateIssued] between 1600 and 1920
group by "originInfo-publication0_dateIssued"
order by Publikationsjahr asc
```
(61 Zeilen)

### Auszählung Werke nach Sprache 
Hier gibt es zwei Möglichkeiten:
a) über die automatisch erkannte Sprache in der Tabelle [sprach_info](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/sprach_info)
Die Sprachen werden hier im [ISO 639-1 Code](https://www.loc.gov/standards/iso639-2/php/code_list.php) angegeben, siehe zweite Spalte.

Wieviele Werke wurden im Publikationszeitraum 1900 bis 1920 auf Englisch veröffentlicht?

```sql
select language as Sprache, [originInfo-publication0_dateIssued] as Publikationsjahr, count(distinct volltext.PPN) as Häufigkeit
from sprach_info, modsinfo, volltext
where sprach_info.PPN = modsinfo.PPN
and sprach_info.PPN = volltext.PPN
and language = "en"
and [originInfo-publication0_dateIssued] between 1900 and 1920
group by "originInfo-publication0_dateIssued"
order by Publikationsjahr asc
```
(21 Zeilen)

b) über die von Bibliothekar:innen notierten Sprachangaben in der Tabelle [modsinfo](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/modsinfo).
Die Sprachen werden hier im [ISO 639-2 Code, siehe erste Spalte](https://www.loc.gov/standards/iso639-2/php/code_list.php) angegeben.

```sql
select language_languageTerm as Sprache, [originInfo-publication0_dateIssued] as Publikationsjahr, count(distinct volltext.PPN) as Häufigkeit
from modsinfo, volltext
where volltext.PPN = modsinfo.PPN
and language_languageTerm = "eng"
and [originInfo-publication0_dateIssued] between 1900 and 1920
group by "originInfo-publication0_dateIssued"
order by Publikationsjahr asc
```
(20 Zeilen)

## Auszählung Publikationsort, Publikationsdatum oder Anzahl der Seiten

### Publikationsort
**Abfrage Häufigkeiten Publikationsort, Ausgabe in absteigender Reihenfolge**

```sql
select [originInfo-publication0_place_placeTerm] as Publikationsort, count([originInfo-publication0_place_placeTerm]) as Häufigkeit
from modsinfo
group by "originInfo-publication0_place_placeTerm"
order by Häufigkeit desc
```
(mehr als 1.500 Zeilen)

Alternative: Abfrage des Feldes **originInfo-publication0_place_placeTerm-normalised**, dort finden sich die normalisierten Ortsnamen

### Publikationsjahr
**Abfrage Häufigkeiten Werke pro Publikationsjahr, Ausgabe in absteigender Reihenfolge der Häufigkeit**

```sql
select [originInfo-publication0_dateIssued] as Publikationsjahr, count([originInfo-publication0_dateIssued]) as Häufigkeit
from modsinfo
group by "originInfo-publication0_dateIssued"
order by Häufigkeit desc
```
(358 Zeilen)

**Abfrage Häufigkeiten Publikationsjahr in einem bestimmten Zeitraum**

```sql
select [originInfo-publication0_dateIssued] as Publikationsjahr, count([originInfo-publication0_dateIssued]) as Häufigkeit
from modsinfo
where [originInfo-publication0_dateIssued] between 1900 and 1920
group by "originInfo-publication0_dateIssued"
order by Publikationsjahr asc
```
(21 Zeilen)

### Anzahl der Seiten
**Anzahl Seiten in 2 PPNs zusammengenommen**

```sql
select count(PPN) as Anzahl_Seiten from volltext where "PPN" IN ("PPN642527652", "PPN642316899")
```
(174 Seiten)

**Anzahl Seiten in 6 PPNs je Text**

```sql
select PPN as PicaProduktionsNummer, count(PPN) as "Anzahl Seiten"
from volltext
where "PPN" IN ("PPN618440003", "PPN687699304", "PPN642191727", "PPN687955130", "PPN749599936", "PPN61844128X")
group by "PPN"
```
(6 Werke mit 628, 784, 430, 857, 961 und 173 Seiten)

**Anzahl Seiten in 6 PPNs je Text, aufsteigend sortiert nach Publikationsjahr**

```sql
select volltext.PPN as PicaProduktionsNummer,  [originInfo-publication0_dateIssued] as Publikationsjahr, count(volltext.PPN) as "Anzahl Seiten"
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and volltext.PPN IN ("PPN618440003", "PPN687699304", "PPN642191727", "PPN687955130", "PPN749599936", "PPN61844128X")
group by PicaProduktionsNummer
order by Publikationsjahr asc
```
(628, 857, 430, 961, 173 und 784 Seiten)

**Anzahl Seiten je PPN mit Volltext aus dem Zeitraum 1900 bis 1905**

```sql
select volltext.PPN as PicaProduktionsNummer, [originInfo-publication0_dateIssued] as Publikationsjahr, count(volltext.PPN) as "Anzahl Seiten"
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and volltext.PPN IN (select modsinfo.PPN from modsinfo where [originInfo-publication0_dateIssued] between 1900 and 1905)
group by PicaProduktionsNummer
order by Publikationsjahr asc
```
(1.137 Zeilen)

**Durchschnittliche Anzahl Seiten pro Publikationsjahr aus dem Zeitraum 1900 bis 1915**

```sql
select [originInfo-publication0_dateIssued] as Publikationsjahr, cast(round((count(volltext.PPN) * 1.0 / count(distinct volltext.PPN)), 2) as dec) as "Durchschnittliche Anzahl Seiten"
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and volltext.PPN IN (select modsinfo.PPN from modsinfo where [originInfo-publication0_dateIssued] between 1900 and 1915)
group by Publikationsjahr
order by Publikationsjahr asc
```
(16 Zeilen)


**Durchschnittliche Anzahl Seiten pro Publikationsjahr nach ausgewählten PPNs**

```sql
select [originInfo-publication0_dateIssued] as Publikationsjahr, cast(round((count(volltext.PPN) * 1.0 / count(distinct volltext.PPN)), 2) AS DEC) as "Durchschnittliche Anzahl Seiten"
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and volltext.PPN IN ("PPN618440003", "PPN618747648", "PPN642188432", "PPN642322031", "PPN642344817", "PPN749600373", "PPN687699304", "PPN74959473X", "PPN642191727", "PPN687955130", "PPN687955386", "PPN687955629", "PPN687955947", "PPN749599839", "PPN749599936", "PPN61844128X", "PPN749600217", "PPN642527652", "PPN656981652", "PPN749600241", "PPN642316899", "PPN663380839", "PPN642321957", "PPN858815532")
group by Publikationsjahr
order by Publikationsjahr asc
```
(9 Zeilen)

**Durchschnittliche Anzahl Seiten pro Publikationsjahr nach ausgewählter Sprache**

```sql
select language_languageTerm as Sprache, [originInfo-publication0_dateIssued] as Publikationsjahr, cast(round((count(volltext.PPN) * 1.0 / count(distinct volltext.PPN)), 2) AS DEC) as "Durchschnittliche Anzahl Seiten"
from volltext, modsinfo
where volltext.PPN = modsinfo.PPN
and volltext.PPN IN (select modsinfo.PPN from modsinfo where [originInfo-publication0_dateIssued] between 1908 and 1912)
and language_languageTerm = "spa"
group by Publikationsjahr
order by Publikationsjahr asc
```
(5 Zeilen)


# Ein Bilddatenset erstellen

Die (nur über SPK-VPN zugängliche) Instanz der Bildsuche findet sich unter
http://bildsuche.lx0246.sbb.spk-berlin.de/

Vorgehen: Mit der Bildähnlichkeitssuche interessierende Bilder identifizieren, z.B. Fotos von Elefanten.

Aus den [Suchergebnissen](http://bildsuche.lx0246.sbb.spk-berlin.de/searchfor?img_id=306409) eine Liste von einzelnen Bildern erstellen, indem jeweils der Link zu den Bildern kopiert wird, die man erhalten möchte, beispielsweise\
https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN745237185&PHYSID=PHYS_0150 \
https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN745594883&PHYSID=PHYS_0347 \
https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN612748480&PHYSID=PHYS_0085 \
https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN612748480&PHYSID=PHYS_0264 \
https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN776803336&PHYSID=PHYS_0111 \
https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN742563820&PHYSID=PHYS_0114 

Diese Links enthalten die PPN und die Seitenangabe (d.h. die Zahl hinter PHYS_).

Die Bilder wiederum können über die IIIF-API der Staatsbibliothek zu Berlin bezogen werden, indem die PPN und die Seitenzahl sowie die gewünschte Bildbreite angegeben werden; die Höhe des Bildes wird dann automatisch angepasst: \
https://content.staatsbibliothek-berlin.de/dc/PPN745237185-00000150/full/1200,/0/default.jpg \
https://content.staatsbibliothek-berlin.de/dc/PPN745594883-00000347/full/1200,/0/default.jpg \
https://content.staatsbibliothek-berlin.de/dc/PPN612748480-00000085/full/1200,/0/default.jpg \
https://content.staatsbibliothek-berlin.de/dc/PPN612748480-00000264/full/1200,/0/default.jpg \
https://content.staatsbibliothek-berlin.de/dc/PPN776803336-00000111/full/1200,/0/default.jpg \
https://content.staatsbibliothek-berlin.de/dc/PPN742563820-00000114/full/1200,/0/default.jpg 

Der IIIF-Standard erlaubt weitere Bildmanipulationen über die URL. So kann, neben der Anpassung der Größe, ein Ausschnitt des Bildes gewählt werden. Im folgenden Beispiel wird ein 1300 x 12500 Pixel großer Ausschnitt ausgeliefert.\
https://content.staatsbibliothek-berlin.de/dc/PPN612748480-00000264/250,600,1300,1250/full/0/default.png

Ebenso ist es möglich, das Original-TIFF Bild zu erhalten, indem default.tif anstatt default.jpg in der URL verwendet wird:\
https://content.staatsbibliothek-berlin.de/dc/PPN612748480-00000264/full/full/0/default.tif

Auch eine Bilddrehung ist möglich:\
https://content.staatsbibliothek-berlin.de/dc/PPN742563820-00000114/full/1200,/90/default.jpg

Weitere Möglichkeiten der Manipulation einzelner Bilder können der [Dokumentation der IIIF Image API 2.1.1](https://iiif.io/api/image/2.1/) entnommen werden, die der Contentserver der Staatsbibliothek implementiert.


# Download von Volltexten und Bildern über die Schnittstellen der Staatsbibliothek zu Berlin

Für diese Möglichkeiten wurden Skripte in der Programmiersprache R erstellt.
Sie finden sich hier [auf dem GitHub-Repositorium des Referats IDM4](https://github.com/qurator-spk/datasette/blob/main/Download-Volltexte-via-OAI-PMH%2BIIIF%2BManifeste.R) 

# Anhang Erläuterungen zu den Datenquellen

Die in datasette verfügbar gemachten Daten stammen aus einer Reihe verschiedener Quellen. Im weiteren Text wird eine kurze Information zu jeder Quelle geliefert; eine ausführliche [Beschreibung der Datenstrukturen findet sich hier](https://github.com/qurator-spk/datasette/blob/main/Datenstrukturen.md).

## Volltexte
Die Tabellen volltext und sprach_info entstammen aus einer auf Zenodo publizierten sqlite-Datenbank, die ALLE Volltexte enthält, die in den digitalisierten Sammlungen der Staatsbibliothek zu Berlin zum 21. August 2019 verfügbar waren. Die Informationen zu Sprachen und Entropie wurden am 1. März 2023 hinzugefügt. Die Größe der sqlite-Datei beträgt etwa 15,8 GB, in der Datasette-Instanz belegt sie ca. 40 GB.  

Diese Volltexte wurden durch die Implementierung einer optischen Zeichenerkennung (OCR) digitalisierter Bücher gewonnen. In den digitalisierten Sammlungen der Staatsbibliothek zu Berlin (SBB) können die Volltexte manuell (Werk für Werk) heruntergeladen werden. Die Veröffentlichung eines Datensatzes mit etwa 5 Millionen OCR-Seiten erleichtert prinzipiell den Zugang zu den Volltexten sowie ihre Nutzung z.B. zum Training von machine learning-Modellen. 

Der Datensatz wurde im März 2023 unter der DOI [https://doi.org/10.5281/zenodo.7716097](https://doi.org/10.5281/zenodo.7716097) publiziert.


## Metadaten (Auszug aus den digitalisierte Sammlungen)

Die Tabelle modsinfo enthält die Metadaten jener rund 30.000 Werke, deren Volltexte in der volltext-Tabelle verfügbar sind. Diese Metadaten wurden am 25. Mai 2025 aus den digitalisierten Sammlungen der Staatsbibliothek zu Berlin (SBB) bezogen. In einem Schritt der Datenanreicherung wurden die Druckorte der Werke normalisiert (daher gibt es die Spalte "originInfo.publication0_place_placeTerm.normalised") und dann mit dem Tool OpenRefine mit GeoDaten angereichert (Spalten latitude, longitude). Daraus resultiert eine weitere datasette-Tabelle namens volltext_mit_titel_und_ort; sie realisiert die Visualisierung der Druckorte jeder einzelnen in der Tabelle volltext vorhandenen Seite. Diese Visualisierung wurde mit einem für datasette verfügbaren Plugin implementiert. Bitte nicht verwechseln: volltext_mit_titel_und_ort bezieht sich auf die einzelnen Volltext-Seiten, die oberhalb der Tabelle [modsinfo](http://datasette.lx0246.sbb.spk-berlin.de/DigiSam/modsinfo) sichtbare Karte hingegen auf die einzelnen Werke.

Die in der Datasette-Instanz verwendete Tabelle stellt einen kleinen Auszug aus einer größeren Datenpublikation dar, der auf Zenodo publiziert wurde. Dieser Datensatz besteht aus einer einzigen Tabelle im Format .parquet, die die Metadaten aller 219.419 Werke enthält, die am 29. Juli 2024 in den digitalisierten Sammlungen der Staatsbibliothek zu Berlin verfügbar waren. Die Größe der .parquet-Datei beträgt etwa 46 MB. Der Datensatz wurde im August 2024 unter [https://doi.org/10.5281/zenodo.7716031](https://doi.org/10.5281/zenodo.7716031) publiziert. 


## Metadaten (Alter Realkatalog)

Die Tabelle ark-metadata besteht aus einer einzelnen Tabelle. Dieser Datensatz enthält beschreibende Metadaten zu 2.639.554 Titeln, die zusammengenommen den "Alten Realkatalog" der Staatsbibliothek zu Berlin bild. Die Metadaten entstammen dem Gesamtkatalog K10plus, einer Datenbank mit etwa 200 Millionen Datensätzen aus Bibliotheken in 11 deutschen Bundesländern. Ausgewählt wurden alle Datensätze, die Systemstellen aus der historischen Klassifikation des "Alten Realkatalogs" enthalten. Dieser Sachkatalog bezieht sich auf Publikationen aus den Jahren 1501 bis 1955 und deren Reproduktionen. Die Titeldaten enthalten Schlagwörter und Basisklassifikations-Signaturen, die aus der "Historischen Systematik", d.h. der [Online-Darstellung der ARK-Klassifikation](https://ark.staatsbibliothek-berlin.de/) übernommen wurden. Der Datenabzug stammt aus dem August 2025 und wurde auf Zenodo im Format .parquet unter [https://doi.org/10.5281/zenodo.17406448](https://doi.org/10.5281/zenodo.17406448) publiziert.


## Metadaten der vollständigen digitalisierten Sammlungen (K10plus)
Die Tabelle DigisamWinIBW schließlich enthält die Metadaten sämtlicher in den digitalisierten Sammlungen der Staatsbibliothek zu Berlin verfügbaren Werke, d.h. sowohl Druckerzeugnisse als auch Manuskripte. Im Gegensatz zur modsinfo enthält dieser Datensatz aber nicht nur die Metadaten jener Werke, die geOCRt wurden und deren Volltexte in der Tabelle volltext verfügbar gemacht wurden, sondern hier finden sich die Metadaten ALLER in den digitalisierten Sammlungen verfügbaren Werke. Die Datenquelle ist in diesem Fall auch nicht die digitalisierten Sammlungen, sondern, wie im Fall des ARK auch, der Gesamtkatalog K10plus. Daher ist dieser Datensatz auch deutlich umfangreicher, die Werke werden mit 267 Variablen beschrieben. Dieser Datensatz wurde für interne Recherchezwecke erstellt, liegt im .csv-Format vor und hat eine Größe von etwa 550 MB. Er wurde bislang nicht publiziert.

