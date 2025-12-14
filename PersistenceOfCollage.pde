ArrayList<PImage> layers;  // Speichert alle verzerrten Schichten (optional, falls du später brauchst)
PGraphics canvas;          // Offscreen-Buffer für die finale Kollage

void setup() {
  size(1200, 800);
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  layers = new ArrayList<PImage>();
  
  textSize(20);
  fill(0);
  text("Drücke 'O' um ein Bild zu laden (additiv für Kollage)\nDrücke 'S' zum Speichern\nDrücke 'N' für Neue/leere Kollage", 20, 50);
}

void draw() {
  background(240);
  image(canvas, 0, 0);
  
  if (layers.size() == 0) {
    textSize(20);
    fill(100);
    text("Drücke 'O' um das erste Bild zu laden...", 20, height/2);
  }
}

void keyPressed() {
  if (key == 'o' || key == 'O') {
    selectInput("Wähle ein Bild zum verzerren...", "fileSelected");
  } else if (key == 's' || key == 'S') {
    String filename = "surreal_kollage_" + year() + nf(month(),2) + nf(day(),2) + "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    canvas.save(filename);
    println("Kollage gespeichert als: " + filename);
  } else if (key == 'n' || key == 'N') {
    // Alles zurücksetzen
    canvas.beginDraw();
    canvas.background(255);
    canvas.endDraw();
    layers.clear();
    println("Kollage zurückgesetzt – neuer leerer Canvas!");
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Kein Bild ausgewählt.");
    return;
  }
  
  PImage original = loadImage(selection.getAbsolutePath());
  if (original == null) {
    println("Fehler beim Laden des Bildes.");
    return;
  }
  
  // Verzerrtes Bild erzeugen (schmelzend/surreal)
  PImage distorted = createImage(original.width, original.height, ARGB);
  original.loadPixels();
  distorted.loadPixels();
  
  float time = frameCount * 0.02;  // Für Animation
  float intensity = random(0.8, 1.5);  // Variierende Stärke pro Schicht
  
  for (int x = 0; x < original.width; x++) {
    for (int y = 0; y < original.height; y++) {
      int index = x + y * original.width;
      
      // Surrealistische Verzerrung: Wellen + Schmelzen nach unten
      float offsetX = sin(y * 0.05 + time) * 30 * intensity;
      float offsetY = sin(x * 0.03 + time * 1.5) * 20 * intensity + (y * 0.1 * intensity);  // Schmelzen nach unten
      
      int srcX = constrain(int(x + offsetX), 0, original.width - 1);
      int srcY = constrain(int(y + offsetY), 0, original.height - 1);
      int srcIndex = srcX + srcY * original.width;
      
      distorted.pixels[index] = original.pixels[srcIndex];
    }
  }
  distorted.updatePixels();
  
  // Zufällige Position/Skalierung für Kollage-Effekt
  float scale = random(0.6, 1.4);
  float posX = random(-original.width * 0.5, width - original.width * scale * 0.5);
  float posY = random(-original.height * 0.5, height - original.height * scale * 0.5);
  
  // Additiv auf den Canvas zeichnen (mit leichter Transparenz für Überlagerung)
  canvas.beginDraw();
  canvas.tint(255, 220);  // Leichte Transparenz für surrealen Mix
  canvas.image(distorted, posX, posY, distorted.width * scale, distorted.height * scale);
  canvas.noTint();
  canvas.endDraw();
  
  layers.add(distorted);  // Optional: speichern der Schicht
  
  println("Neue verzerrte Schicht hinzugefügt!");
}
