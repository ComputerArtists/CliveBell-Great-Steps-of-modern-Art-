# Große Ideen der Kunst in Processing  
### Ein kreatives Experimentier-Projekt

Dieses Projekt entstand aus einer intensiven, spielerischen Auseinandersetzung mit zentralen Strömungen der modernen und zeitgenössischen Kunst. Ziel war es, **große Ideen der Kunstgeschichte** nicht nur theoretisch zu verstehen, sondern sie mit eigenen Händen (und Code) nachzubauen und zu variieren – alles in Processing.

Jede Stilrichtung wurde als eigenständiges, interaktives Processing-Skript umgesetzt. Alle Skripte teilen eine einheitliche Bedienung, sodass du nahtlos zwischen den Stilen wechseln und experimentieren kannst.

## Gemeinsame Bedienung (gilt für alle Skripte)

| Taste       | Funktion |
|-------------|--------------------------------------------------|
| **O**       | Neue Schicht erstellen (additiv) + optional Bild laden |
| **S**       | Aktuelles Bild speichern (mit Timestamp im Dateinamen) |
| **N**       | Alles zurücksetzen (leerer Canvas) |
| **M**       | Originalbild stark/schwach ein-/ausblenden (falls geladen) |
| **+ / -**   | Parameter anpassen (je nach Stil: Anzahl Elemente, Dichte, Größe, etc.) |
| **F**       | Fallback-Farbe wechseln (bei abstrakten Varianten) |
| **H**       | Richtung wechseln (horizontal/vertikal, falls vorhanden) |

## Die entstandenen Stilrichtungen

### 1. Surrealismus – Persistence of Collage
Inspiriert von Salvador Dalí (schmelzende Uhren, traumhafte Verzerrungen)  
- Lädt Bilder und verzerrt sie mit sinusbasierter „Schmelz“-Verzerrung  
- Additive Kollage: Mehrere verzerrte Bilder überlagern sich zu einer surrealen Traumlandschaft  
- Lebendige Animation durch zeitbasierte Wellen

### 2. Analytischer Kubismus
Inspiriert von Pablo Picasso und Georges Braque  
- Zerlegt ein Bild in überlappende Dreiecke, Vierecke und Kreise  
- Jede Form sampelt Farbe aus einer leicht verschobenen Position → Simultaneität mehrerer Perspektiven  
- Gedämpfte Farben mit optionalem „Glowing“-Twist (moderner Verrat am Originalstil)

### 3. Pointillismus
Inspiriert von Georges Seurat und Paul Signac  
- Reine Punkte (Kreise) mit variierender Dichte  
- Optische Farbmischung: Aus der Nähe chaotisch, aus Distanz entsteht ein Bild  
- Dichte steuerbar – für feine Details oder grobe, vibrierende Flächen

### 4. Minimalismus – Variationen & Kombinationen
Eine ganze Serie reduzierter, meditativer Skripte:

#### a) Fluoreszierende Stacks (Donald Judd + Dan Flavin)
Serielle Rechtecke („Stacks“) mit sanftem Neon-Glow

#### b) Fluoreszierendes Grid (Agnes Martin + Dan Flavin)
Feines Liniengrid, das leise leuchtet – meditativ und präzise

#### c) Fluoreszierende Wall Drawings (Sol LeWitt + Dan Flavin)
Regelbasierte Bögen von den Ecken, diagonale Wellenlinien – mit variabler Geometrie und Glow

#### d) Fluoreszierende Black Stripes (Frank Stella + Dan Flavin) – Abschluss
Parallele monochrome Bänder mit kontrolliertem Neon-Leuchten  
Horizontale oder vertikale Ausrichtung, Anzahl und Farbe steuerbar  
Besonders stark gegen Überhelligkeit abgesichert

## Philosophie des Projekts

- **Kunst als Experiment**: Keine perfekte Nachbildung, sondern lebendige Interpretation  
- **Digitaler Verrat erlaubt**: Moderne Twists (Glow, Animation, Interaktivität) wurden bewusst eingebaut, um zu zeigen, wie zeitlos diese Ideen sind  
- **Weniger ist mehr – aber mit Leuchten**: Besonders im Minimalismus-Bereich wurde der Spagat zwischen strenger Reduktion und digitaler Magie gesucht  
- **Additive Kollage als roter Faden**: Fast alle Skripte erlauben das schichtweise Aufbauen von Kompositionen – wie ein digitales Atelier

## Technische Hinweise

- Alle Skripte laufen in **Processing 4.x** (Java Mode)  
- Empfohlene Canvas-Größe: 1200 × 800 (anpassbar)  
- Speichern mit **S** erzeugt datumsbasierte PNG-Dateien  
- Bei hellen Bildern manchmal Glow reduzieren (durch Parameter oder Farbauswahl)

## Danksagung

Dieses Projekt entstand in einem wunderbaren dialogischen Prozess – Idee für Idee, Bug für Bug, Variation für Variation. Es hat gezeigt, wie lebendig Kunstgeschichte werden kann, wenn man sie selbst in Code übersetzt.

Viel Freude beim Weiterexperimentieren – die Skripte sind dein Atelier.  
Lass die großen Ideen weiter leuchten! 🎨✨

*Dezember 2025*
