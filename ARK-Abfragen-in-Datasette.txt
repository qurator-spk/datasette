# ARK-Abfragen in Datasette
Die ARK-Metadaten-Tabelle ist hier zu erreichen (nur intern über SPK-VPN):
http://datasette.lx0246.sbb.spk-berlin.de/ARK-MetaData

In neuem Tab: Wie lauten alle Spaltennamen?
http://datasette.lx0246.sbb.spk-berlin.de/ARK-MetaData/ark_metadata?sql=SELECT+*+FROM+ark_metadata+WHERE+1%3D0

## Eine erste SQL-Abfrage
```sql
select rowid, "Pica-Produktionsnummer 0100", "Bibliografische Gattung und Status 0500", "Inhaltstyp 0501"
from ark_metadata
where "Bibliografische Gattung und Status 0500" = "Aaa";
```
126 Zeilen

## Abfrage Häufigkeiten von Schlagworten
```sql
select [Schlagwortfolgen (GBV, SWB, K10plus) 5550] as Schlagwort, count([Schlagwortfolgen (GBV, SWB, K10plus) 5550]) as Häufigkeit
from ark_metadata
group by "Schlagwortfolgen (GBV, SWB, K10plus) 5550"
order by Häufigkeit desc;
```
265913 nan

```sql
select [Schlagwortfolgen 5551] as Schlagwort, count([Schlagwortfolgen 5551]) as Häufigkeit
from ark_metadata
group by "Schlagwortfolgen 5551"
order by Häufigkeit desc;
```
2283231 nan


## Anzahl belegter und leerer Felder in einer Spalte \
Wieviele leere Felder ("nan") gibt es in einer bestimmten Spalte?

```sql
select count(*) from ark_metadata where "Schlagwortfolgen 5551" = 'nan';
```

Wieviele belegte und leere Felder gibt es in einer Spalte?
```sql
select
  count(CASE WHEN "Schlagwortfolgen 5551" <> 'nan' THEN 1 END) AS Belegte_Felder,
  count(CASE WHEN "Schlagwortfolgen 5551" = 'nan' THEN 1 END) AS Leere_Felder
from ark_metadata;
```
Belegte Felder: 356323 \
Leere Felder: 2283231 \
Zusammen: 2.639.554 (stimmt, das entspricht der Gesamtanzahl der Zeilen) \

## Wieviele Vorkommen eines bestimmten Begriffs?
```sql
select count(*) from y where x = '$AARK';
```

```sql
select count(*) from ark_metadata where [Lokale Notationen 6010] = 'B 6430 ff.';
```
2

```sql
select count(*) from ark_metadata where "Basisklassifikation 5301" like '%$AARK%';
```
2404636

```sql
select count(*) from ark_metadata where "Schlagwortfolgen 5551" like '%$AARK%';
```
338117


## Suche nach SW aus der Kategorie 555x
```sql
select "Pica-Produktionsnummer 0100", "Schlagwortfolgen 5551"
from ark_metadata
where "Schlagwortfolgen 5551" like '%!10482638X!Berlin%';
```

## Suche nach Form-SW aus der Kategorie 1131
```sql
select "Pica-Produktionsnummer 0100", "Art des Inhalts 1131"
from ark_metadata
where "Art des Inhalts 1131" like '%!104213493!Biografie%';
```

## Suche nach Notationen der Basisklassifikation 5301 in numerischer Form (z.B. 17.71) aus der Kategorie 5301
```sql
select "Pica-Produktionsnummer 0100", "Basisklassifikation 5301"
from ark_metadata
where "Basisklassifikation 5301" like '%!17.71$%';
```
da Basisklassifikation 5301 ein Textfeld ist, wird strenggenommen nicht nach numerischen Werten gesucht, sondern nach der Zeichenfolge "17.71"


## Wie viele SW haben in der Kategorien 555X die Kennung $AARK?
```sql
select count(*) from ark_metadata where "Schlagwortfolgen (GBV, SWB, K10plus) 5550" like '%$AARK%'
```
2196993

```sql
select count(*) from ark_metadata where "Schlagwortfolgen 5551" like '%$AARK%';
```
338117

```sql
select 
  (select count(*) from ark_metadata where "Schlagwortfolgen (GBV, SWB, K10plus) 5550" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5551" like '%$AARK%')
  as aark_occurrences;
```
2535110 = 2196993 + 338117

```sql
select 
  (select count(*) from ark_metadata where "Schlagwortfolgen (GBV, SWB, K10plus) 5550" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5551" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5552" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5553" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5554" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5555" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5556" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5557" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5558" like '%$AARK%') +
  (select count(*) from ark_metadata where "Schlagwortfolgen 5559" like '%$AARK%')
  as aark_occurrences;
```

2575853

## Wie oft ist die Kategorie 6011 insgesamt in den ARK-Daten (nur gedruckt: A.. oder Mikrofiche: E..) belegt?

```sql
select count(*) as Häufigkeit
from ark_metadata
where "Lokale Notationen 6011" <> 'nan' and "Bibliografische Gattung und Status 0500" like 'A%';
```
32403

```sql
select count(*) as Häufigkeit
from ark_metadata
where "Lokale Notationen 6011" <> 'nan' and "Bibliografische Gattung und Status 0500" like 'E%';
```
295


## Suche mir die Digitalisate eines bestimmten oder mehrerer Notationsbereiche
```sql
SELECT "Pica-Produktionsnummer 0100", "Bibliografische Gattung und Status 0500", "Erscheinungsdatum/Entstehungsdatum 1100", "URL zum Volltext 4950", "Lesesaalsystematik der SBB 6210", "Lesesaalsystematik der SBB 6211"
FROM ark_metadata
WHERE
  "Bibliografische Gattung und Status 0500" like 'o%'
  AND ("Lesesaalsystematik der SBB 6210" LIKE '%Uq 1311%'
  OR "Lesesaalsystematik der SBB 6211" LIKE '%Uq 1311%'
  OR "Lesesaalsystematik der SBB 6210" LIKE '%Uq 1324 - Uq 2068/68%'
  OR "Lesesaalsystematik der SBB 6211" LIKE '%Uq 1324 - Uq 2068/68%');
```
4 Treffer 

## Wieviele A- und O-Aufnahmen gibt? Nach Feld Bibliografische Gattung und Status 0500

```sql
select [Bibliografische Gattung und Status 0500] as BBG, count([Bibliografische Gattung und Status 0500]) as Häufigkeit
from ark_metadata
group by "Bibliografische Gattung und Status 0500"
order by BBG collate nocase;
```
175 Zeilen

## Mengengerüst erstellen - alle Titel beginnend mit "Us" in der 6210 finden

```sql
select "Pica-Produktionsnummer 0100", "Erscheinungsdatum/Entstehungsdatum 1100", "URL zum Volltext 4950", "Lesesaalsystematik der SBB 6210"
from ark_metadata
where "Lesesaalsystematik der SBB 6210" like 'Us%';
```

Mengengerüst erstellen, dabei mehrere Notationsbereiche abfragen: In der ARK-Systematik die jeweils unterste Ebene suchen und die interessierenden Notationsbereiche einsammeln; diese dann systematisch aus den beiden Feldern "Lesesaalsystematik der SBB 6210" und "Lesesaalsystematik der SBB 6211" auslesen:

```sql
select "Pica-Produktionsnummer 0100", "Erscheinungsdatum/Entstehungsdatum 1100", "URL zum Volltext 4950", "Lesesaalsystematik der SBB 6210",  "Lesesaalsystematik der SBB 6211"
from ark_metadata
where
  "Lesesaalsystematik der SBB 6210" like '%Uq 1311%'
  OR "Lesesaalsystematik der SBB 6211" like '%Uq 1311%'
  OR "Lesesaalsystematik der SBB 6210" like '%Uq 1324 - Uq 2068/68%'
  OR "Lesesaalsystematik der SBB 6211" like '%Uq 1324 - Uq 2068/68%'
 ```
 
Das gewählte Beispiel "Neger · Sklavenhandel" (relevant für den Kolonialismus) weist nur zwei darunterliegende Ebenen auf, es werden 139 Treffer angezeigt.
Auf https://ark.staatsbibliothek-berlin.de/index.php?recherche=002.015.006.019.005&ACT=&IKT=&TX=&SET=&NSI=SYS#ebene=94941,100807,146865,146872 werden aktuell (24.09.2025) 142 Titel angezeigt, was leider nicht korrekt ist. \
Titelanzahl rücküberprüfen in der WinIBW: \
sc no1 Uq 01311 # 1 Titel \
sc no1 Uq 01324 - Uq 02068/00068 # 138 Titel \
zusammen 139 Titel

Anderes Beispiel: Suche mir alle PPNs der mit der Systemstelle „Alchemie“ (https://ark.staatsbibliothek-berlin.de/#ebene=70237,73891) verknüpften Titel 
Folgendes Vorgehen ist angezeigt:

```sql
SELECT "Pica-Produktionsnummer 0100", "Erscheinungsdatum/Entstehungsdatum 1100", "URL zum Volltext 4950", "Lesesaalsystematik der SBB 6210",  "Lesesaalsystematik der SBB 6211"
FROM ark_metadata
WHERE
  "Lesesaalsystematik der SBB 6210" LIKE '%Mu 6 - Mu 9/50%'
  OR "Lesesaalsystematik der SBB 6211" LIKE '%Mu 6 - Mu 9/50%'
  OR "Lesesaalsystematik der SBB 6210" LIKE '%Mu 76 - Mu 251/600%'
  OR "Lesesaalsystematik der SBB 6211" LIKE '%Mu 76 - Mu 251/600%'
  OR "Lesesaalsystematik der SBB 6210" LIKE '%Mu 410 - Mu 559%'
  OR "Lesesaalsystematik der SBB 6211" LIKE '%Mu 410 - Mu 559%'
  OR "Lesesaalsystematik der SBB 6210" LIKE '%Mu 766 - Mu 780%'
  OR "Lesesaalsystematik der SBB 6211" LIKE '%Mu 766 - Mu 780%'
  OR "Lesesaalsystematik der SBB 6210" LIKE '%Mu 76 - Mu 251/600%'
  OR "Lesesaalsystematik der SBB 6211" LIKE '%Mu 76 - Mu 251/600%'
  OR "Lesesaalsystematik der SBB 6210" LIKE '%Mu 950 - Mu 1022/90%'
  OR "Lesesaalsystematik der SBB 6211" LIKE '%Mu 950 - Mu 1022/90%'
  OR "Lesesaalsystematik der SBB 6210" LIKE '%[Mu 1023]%'
  OR "Lesesaalsystematik der SBB 6211" LIKE '%[Mu 1023]%'
```

Liefert bereits 216 Ergebnisse, muss aber noch weiter für die Werke einzelner Alchemisten durchgearbeitet werden, dabei bitte jeweils die unterste Ebene auswählen


## weitere Abfragen

```sql
select "Pica-Produktionsnummer 0100", "Lesesaalsystematik der SBB 6213"
from ark_metadata;
```

```sql
select "Pica-Produktionsnummer 0100", "Lesesaalsystematik der SBB 6213"
from ark_metadata
where "Lesesaalsystematik der SBB 6213" != "nan";
```

```sql
select "Pica-Produktionsnummer 0100", "Lesesaalsystematik der SBB 6213"
from ark_metadata
group by "Lesesaalsystematik der SBB 6213";
```

## Titel, in denen in 6010 dasselbe steht wie in 6211 \
Die Abfrage wird grundsätzlich so formuliert:

```sql
select "Pica-Produktionsnummer 0100", "Lokale Notationen 6010", "Lesesaalsystematik der SBB 6211"
from ark_metadata
where "Lokale Notationen 6010" = "Lesesaalsystematik der SBB 6211"
```

```sql
select "Pica-Produktionsnummer 0100", "Lokale Notationen 6010", "Lesesaalsystematik der SBB 6210"
from ark_metadata
where "Lokale Notationen 6010" = "Lesesaalsystematik der SBB 6210"
and "Lesesaalsystematik der SBB 6210" != "nan";
```
liefert 53 Ergebnisse


## Auszählung der Häufigkeit bestimmter Schlagworte, jeweils in den beiden Feldern "Lesesaalsystematik der SBB 6210" und "Lesesaalsystematik der SBB 6211"
```sql
select "Lokale Notationen 6010" as Schlagwort, count("Lokale Notationen 6010") as Häufigkeit
from ark_metadata
group by "Lokale Notationen 6010"
order by Häufigkeit desc;
```

```sql
select "Lesesaalsystematik der SBB 6210" as Schlagwort, count("Lesesaalsystematik der SBB 6210") as Häufigkeit
from ark_metadata
group by "Lesesaalsystematik der SBB 6210"
order by Häufigkeit desc;
```
