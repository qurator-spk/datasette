### Ein Volltextdatenset über die OAI-PMH-Schnittstelle laden

# Einrichten der Arbeitsumgebung

# Zuallererst sollten Sie das Arbeitsverzeichnis, in dem Sie die im Verlauf dieses 
# Tutorials anfallenden Dateien speichern, festlegen. Dafür können Sie mit getwd() 
# herausfinden, wo RStudio Ihre Dateien speichern würde, und dies gegebenenfalls 
# mit setwd() ändern.

getwd()

setwd("pfad/zu/meinem/arbeitsverzeichnis")

# Danach wird die Arbeitsumgebung eingerichtet, indem die benötigten Bibliotheken 
# installiert werden.

install.packages("oai")
install.packages("stringr")
install.packages("jsonlite")

# Um die installierten Bibliotheken zu verwenden, rufen Sie diese bitte nun auf, 
# damit RStudio auf den darin enthaltenen Code zurückgreifen kann.

library(oai)
library(stringr)
library(jsonlite)

# Abfrage der OAI-Schnittstelle

# Im ersten Schritt betrachten wir erst einmal die grundlegenden Informationen der 
# OAI-PMH-Schnittstelle der Staatsbibliothek zu Berlin – PK, 
# dafür wird der Befehl identify id() und die Basis-URL der OAI-Schnittstelle 
# (https://oai.sbb.berlin) genutzt.

id("https://oai.sbb.berlin/")

# Abfrage aller Datensets

# Im nächsten Schritt werden alle verfügbaren Datensets mit der Funktion list_sets 
# abgefragt und angezeigt.

list_sets("https://oai.sbb.berlin/?verb=ListSets")

# Um die Abfrageergebnisse leichter lesbar darzustellen, nutzen Sie den 
# nachfolgenden Code, der die Ergebnisse in tabellarischer Form präsentiert.

SBB_Sets <- list_sets("https://oai.sbb.berlin/?verb=ListSets")
View(SBB_Sets)

# Um herauszufinden, in welchen Metadatenformaten die OAI-Schnittstelle Datensätze
# ausgibt, können wir folgenden Code verwenden.

Metadata <- list_metadataformats(url = "https://oai.sbb.berlin/")
View(Metadata)

# Darüber hinaus können wir uns anzeigen lassen, wie viele Datensätze in dem 
# jeweiligen Metadatenformat vorhanden sind.

count_identifiers(url = "https://oai.sbb.berlin/metadataPrefix=mets")

# Insgesamt 234.975 mets Datensätze (Stand 25.11.2025)

count_identifiers(url = "https://oai.sbb.berlin/metadataPrefix=oai_dc")

# Insgesamt = 234.975 oai Datensätze

# Im folgenden Beispiel betrachten wir nun das Set „VDLied Digital“. Mehr Infos:
# https://staatsbibliothek-berlin.de/die-staatsbibliothek/abteilungen/handschriften-und-historische-drucke/sammlungen/historische-drucke-ab-1501/projekte/vd-lied-digital
# bzw. generell zu den Sammlungen:
# https://digital.staatsbibliothek-berlin.de/ueber-digitalisierte-sammlungen/projekte
# Zuerst schauen wir uns an, wie viele Datensätze dieses Set enthält.

count_identifiers(url = "https://oai.sbb.berlin/?verb=ListIdentifiers&set=VDLieddigital", 
                  prefix = "oai_dc")

# Insgesamt sind hier 2.918 Datensätze aufgelistet

# Darauf aufbauend betrachten wir alle Datensätze und lassen uns diese 
# zur besseren Lesbarkeit in Form einer Tabelle ausgeben.

record_list <- list_records("https://oai.sbb.berlin/", 
                            metadataPrefix="oai_dc", 
                            set="VDLieddigital")

# Betrachten der Tabelle

View(record_list)

# Hier gibt es zwei verschiedene unique identifiers, die wiederum durch PPNs gebildet werden:
# identifier.3 (Spalte 16): Das ist die PPN des Digitalisats; diese PPN kann 
# genutzt werden, um ein Werk in den Digitalisierten Sammlungen der Staatsbibliothek 
# zu Berlin anzuzeigen
# PPN771709331
# siehe
# https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN771709331&PHYSID=PHYS_0001
#
# identifier.1 (Spalte 17): Dies ist das analoge Werk, d.h. die physische Vorlage 
# des Digitalisats:
# PPN567470350
# siehe
# https://stabikat.de/Record/567470350
#
# Die PPNs dienen auch zum Abruf von Volltexten. Die PPN des Digitalisats ermöglicht es,
# den Volltext vom content server der SBB im Format ALTO abzurufen, 
# z.B. komplett als .zip-Datei
# https://content.staatsbibliothek-berlin.de/dc/PPN771709331.ocr.zip
# oder auch als Einzelseite
# https://content.staatsbibliothek-berlin.de/dc/PPN771709331-0006.ocr.xml
# Ansicht in den Digitalisierten Sammlungen
# https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN771709331&PHYSID=PHYS_0006&view=fulltext-endless&DMDID=DMDLOG_0001
# oder Ansicht der ALTO-Datei mit Hilfe des Tools "PAGE Viewer"
# Downloadbar für alle Plattformen von https://www.primaresearch.org/tools/PAGEViewer


### Download der Volltexte aus einer mit datasette erzeugten PPN-Liste
# Laden einer Beispieldatei, erzeugt mit Hilfe der Abfrage
# select modsinfo.PPN, name0_displayForm, titleInfo_title, titleInfo_subTitle, 
# [originInfo-publication0_place_placeTerm], [originInfo-publication0_dateIssued] 
# from modsinfo
# where [originInfo-publication0_dateIssued] = 1910
# order by modsinfo.ppn
#
# und abgelegt im Arbeitsvereichnis unter dem Namen PPNBeispielliste-1910.csv

PPNBeispielliste <- read.csv("PPNBeispielliste-1910.csv", encoding = "UTF-8", header = T)
# 86 Zeilen bzw. PPNs in Spalte 1

# Spalte 1 enthält die PPN-Liste; diese modifizieren wir nun so,
# dass die Volltexte als .zip heruntergeladen werden können
PPNBeispielliste$ppn <- gsub("^", "https://content.staatsbibliothek-berlin.de/dc/", PPNBeispielliste$ppn)
PPNBeispielliste$ppn <- gsub("$", ".ocr.zip", PPNBeispielliste$ppn)

# Nun downloaden wir alle 86 .zip-Dateien und legen sie in ein Verzeichnis,
# das wir "VolltexteAlsZip" nennen

dir.create("VolltexteAlsZip")

library(purrr)
walk(PPNBeispielliste$ppn, ~{
  message("Downloading: ", .x) # zeige uns, was Du gerade machst
  httr::GET(
    url = .x,
    httr::write_disk(file.path("VolltexteAlsZip", basename(.x)))
  )
  Sys.sleep(3) # sei freundlich zur Schnittstelle, kleine Pause zwischendrin
})

# 86 zip-files, 250 MB

### Download von Bildern über die IIIF-Schnittstelle 
# Ganz analog funktioniert der Download von Bildern über die IIIF-Schnittstelle.
# Im Gegensatz zur OAI-Schnittstelle gibt es aber dafür kein eigenes R-Package.
# Daher erstellen wir uns selbst einen beispielhaften Dataframe aus den Beispielen, 
# die die Suche nach Elefanten-Bildern 
# (http://bildsuche.lx0246.sbb.spk-berlin.de/searchfor?img_id=306409) 
# ergeben hat:

IIIFAbfrage <- as.data.frame(c("https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN745237185&PHYSID=PHYS_0150",
                               "https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN745594883&PHYSID=PHYS_0347",
                               "https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN612748480&PHYSID=PHYS_0085",
                               "https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN612748480&PHYSID=PHYS_0264",
                               "https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN776803336&PHYSID=PHYS_0111",
                               "https://digital.staatsbibliothek-berlin.de/werkansicht?PPN=PPN742563820&PHYSID=PHYS_0114"))

# Die erste Spalte umbenennen
colnames(IIIFAbfrage)[1] <- "Bilderliste"
# Eine PPN-Spalte hinzufügen
IIIFAbfrage$PPN <- ""
# Eine Seiten-Spalte hinzufügen
IIIFAbfrage$Seite <- ""


# Ein paar Veränderungen der Abfragelinks, hier werden einige escapes benötigt:

IIIFAbfrage$Bilderliste <- gsub("https:\\/\\/digital.staatsbibliothek-berlin.de\\/werkansicht\\?PPN=", 
                                "", 
                                IIIFAbfrage$Bilderliste)

PPN_pattern <- "(?<=PPN)\\w+"
# Finde den Substring PPN gefolgt von einem alphanumerischem Unterstring

Page_pattern <- "(?<=PHYS_)\\w+"
# Finde den Substring PHYS_ gefolgt von einem alphanumerischem Unterstring

library(dplyr)
# damit kann man den mutate-Befehl benutzen

IIIFAbfrage %>%
  mutate(
    PPN = str_extract(Bilderliste, PPN_pattern)) -> IIIFAbfrage

IIIFAbfrage %>%
  mutate(
    Seite = str_extract(Bilderliste, Page_pattern)) -> IIIFAbfrage

# Weitere Ersetzungen in der ersten Spalte
IIIFAbfrage$Bilderliste <- gsub("^", 
                                "https:\\/\\/content.staatsbibliothek-berlin.de\\/dc\\/", 
                                IIIFAbfrage$Bilderliste)


IIIFAbfrage$Bilderliste <- gsub("\\&PHYSID=PHYS_", 
                                "-0000", 
                                IIIFAbfrage$Bilderliste)


IIIFAbfrage$Bilderliste <- gsub("$", "\\/full\\/1200,\\/0\\/default.jpg", IIIFAbfrage$Bilderliste)

# Ein neues Verzeichnis erstellen
dir.create("IIIFBilder")

library(jpeg) # um Bilddateien lesen und schreiben zu können
setwd("./IIIFBilder") # um die Dateien am richtigen Ort zu speichern 

# Download der Bilder mit einem for-loop
for(i in 1:6){ # oder eine Auswahl in der Form 2:4 eintragen
  myurl <- paste(IIIFAbfrage[i,1], sep = "") # die Zahl hinter dem i ist die Spaltennummer
  z <- tempfile()
  download.file(myurl, destfile = z, mode="wb")
  pic <- readJPEG(z)
  writeJPEG(pic, paste("PPN", IIIFAbfrage[i,2], "-", IIIFAbfrage[i,3], ".jpg", sep = ""), quality = 1) 
  file.remove(z)
  Sys.sleep(3) # API schonen
}


### Download aller in einem IIIF-Manifest vorhandenen Bilder

# Arbeitsverzeichnis setzen
setwd("path/to/my/directory/datasette-Workshop-oder-so")

# Die Pakete "jsonlite" und "httr" installieren, wenn noch nicht geschehen
install.packages("jsonlite")
install.packages("httr")

# Diese beiden Pakete aufrufen
library(jsonlite)
library(httr)

# Die URL zum IIIF-Manifest einfügen, hier wieder ein Werk mit Elefanten-Beispiel
manifest_url <- "https://content.staatsbibliothek-berlin.de/dc/770468993/manifest"

# Ein Verzeichnis festlegen, in dem diese Bilder abglegt werden
out_dir <- "IIIFBilderAusManifest"

# Das Verzeichnis anlegen
if (!dir.exists(out_dir)) dir.create(out_dir)

# Download des Manifests und parsing
resp <- httr::GET(manifest_url)
stop_for_status(resp)
manifest <- jsonlite::fromJSON(content(resp, as = "text", encoding = "UTF-8"))

# Aus dem Canvas-Element die Bild-URLs extrahieren 
# Achtung, dies gilt nur für die IIIF Presentation 2.x Version der SBB
# nicht aber für die IIIF Presentation 3.x Version
tempframe <- as.data.frame(manifest[["sequences"]])
canvases <- as.data.frame(do.call(cbind, tempframe$canvases))

image_urls <- as.data.frame(canvases$`@id`)

filenames <- as.data.frame(image_urls$`canvases$\`@id\``)
colnames(filenames)[1] <- "Dateiname"

image_urls$`canvases$\`@id\`` <- gsub("canvas",
                            "full\\/full\\/0\\/default.jpg",
                            image_urls$`canvases$\`@id\``)

# Ersetzungen in der ersten Spalte, um schöne Dateienamen zu erhalten
filenames$Dateiname <- gsub("https:\\/\\/content.staatsbibliothek-berlin.de\\/dc\\/",
                            "",
                            filenames$Dateiname)

filenames$Dateiname <- gsub("\\/canvas",
                            "",
                            filenames$Dateiname)

# Vorbereitung Download
library(jpeg) # um Bilddateien lesen und schreiben zu können
setwd("./IIIFBilderAusManifest") # um die Dateien am richtigen Ort zu speichern 

# Die Gesamtzahl an Images in einen Vektor packen
x <- paste(1:nrow(image_urls))

for(i in x){ # hier die Länge des canvases-Dataframes oder eine Auswahl in der Form 5:130 eintragen
  myurl <- paste(image_urls[i,1], sep = "") # die Zahl hinter dem i ist die Spaltennummer
  z <- tempfile()
  download.file(myurl, destfile = z, mode="wb")
  pic <- readJPEG(z)
  writeJPEG(pic, paste("PPN", filenames[i,1], ".jpg", sep = ""), quality = 1) 
  file.remove(z)
  Sys.sleep(3) # API schonen
}

# Bingo! 147 Dateien mit insgesamt 38 MB heruntergeladen!


