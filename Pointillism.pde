PGraphics canvas;
PImage original;
boolean showOriginal = false;
int dotDensity = 30000;  // Startwert – mit + / - änderbar (10k–100k)

void setup() {
  size(1200, 800);
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(240);
  canvas.endDraw();
  
  displayHelp();
}

void draw() {
  background(220);
  
  if (showOriginal && original != null) {
    tint(255, 140);
    image(original, 0, 0, width, height);
    noTint();
  }
  
  image(canvas, 0, 0);
  
  displayHelp();
}

void displayHelp() {
  fill(0);
  textSize(18);
  textAlign(LEFT);
  text("O = Bild laden (pointillistisch, additiv)\n" +
       "S = Speichern\n" +
       "N = Reset\n" +
       "M = Originalbild ein/ausblenden " + (showOriginal ? "(AN)" : "(AUS") + ")\n" +
       "+ / - = Dichte (Punkte pro Schicht): " + dotDensity + " (aktuell)\n", 
       20, 40);
}

void keyPressed() {
  if (key == 'o' || key == 'O') {
    selectInput("Wähle ein Bild für pointillistische Zerlegung...", "fileSelected");
  } else if (key == 's' || key == 'S') {
    String filename = "pointillism_" + year() + nf(month(),2) + nf(day(),2) + "_" 
                      + nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    canvas.save(filename);
    println("Gespeichert als: " + filename);
  } else if (key == 'n' || key == 'N') {
    canvas.beginDraw();
    canvas.background(240);
    canvas.endDraw();
    showOriginal = false;
    original = null;
    println("Alles zurückgesetzt");
  } else if (key == 'm' || key == 'M') {
    if (original != null) {
      showOriginal = !showOriginal;
      println("Originalbild " + (showOriginal ? "eingeblendet" : "ausgeblendet"));
    } else {
      println("Noch kein Bild geladen – drücke erst 'O'");
    }
  } else if (key == '+' || key == '=') {
    dotDensity += 5000;
    dotDensity = constrain(dotDensity, 10000, 100000);
    println("Dichte erhöht auf: " + dotDensity + " Punkte");
  } else if (key == '-') {
    dotDensity -= 5000;
    dotDensity = constrain(dotDensity, 10000, 100000);
    println("Dichte verringert auf: " + dotDensity + " Punkte");
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Keine Datei ausgewählt.");
    return;
  }
  
  original = loadImage(selection.getAbsolutePath());
  if (original == null) {
    println("Bild konnte nicht geladen werden.");
    return;
  }
  
  original.resize(width, height);
  
  PGraphics layer = createGraphics(width, height);
  layer.beginDraw();
  layer.background(0, 0);  // Transparent
  layer.noStroke();
  
  float baseDotSize = 8.0;  // Feste, gute Größe für klassischen Pointillismus
  
  println("Erzeuge " + dotDensity + " Punkte mit Größe ~" + baseDotSize + " px...");
  
  for (int i = 0; i < dotDensity; i++) {
    float x = random(width);
    float y = random(height);
    
    // Leichte Verschiebung für Vibration und optische Mischung
    float offsetX = random(-12, 12);
    float offsetY = random(-12, 12);
    
    int sampleX = constrain(int(x + offsetX), 0, original.width-1);
    int sampleY = constrain(int(y + offsetY), 0, original.height-1);
    color c = original.get(sampleX, sampleY);
    
    // Punktgröße leicht variieren
    float dotSize = baseDotSize + random(-3, 3);
    dotSize = max(dotSize, 2.0);
    
    layer.fill(red(c), green(c), blue(c), 230);
    
    layer.ellipse(x, y, dotSize, dotSize);
  }
  
  layer.endDraw();
  
  canvas.beginDraw();
  canvas.image(layer, 0, 0);
  canvas.endDraw();
  
  println("Neue pointillistische Schicht mit " + dotDensity + " Punkten hinzugefügt!");
}
