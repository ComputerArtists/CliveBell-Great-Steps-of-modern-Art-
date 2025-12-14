PGraphics canvas;
PImage original;
boolean showOriginal = false;
int numFragments = 800;  // Startwert

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
  
  // Originalbild als Referenz unterlegen (nur wenn vorhanden)
  if (showOriginal && original != null) {
    tint(255, 150);  // Leicht transparent für bessere Sicht auf Kubismus
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
  text("O = Bild laden (additiv kubistisch)\n" +
       "S = Speichern\n" +
       "N = Reset\n" +
       "M = Originalbild ein/ausblenden " + (showOriginal ? "(AN)" : "(AUS") + ")\n" +
       "+ / - = Fragmente: " + numFragments + " (aktuell)\n", 
       20, 40);
}

void keyPressed() {
  if (key == 'o' || key == 'O') {
    selectInput("Wähle ein Bild für kubistische Zerlegung...", "fileSelected");
  } else if (key == 's' || key == 'S') {
    String filename = "glowing_cubist_" + year() + nf(month(),2) + nf(day(),2) + "_" 
                      + nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    canvas.save(filename);
    println("Gespeichert als: " + filename);
  } else if (key == 'n' || key == 'N') {
    canvas.beginDraw();
    canvas.background(240);
    canvas.endDraw();
    showOriginal = false;
    original = null;  // Sicherstellen, dass M nichts anzeigt
    println("Alles zurückgesetzt");
  } else if (key == 'm' || key == 'M') {
    if (original != null) {
      showOriginal = !showOriginal;
      println("Originalbild " + (showOriginal ? "eingeblendet" : "ausgeblendet"));
    } else {
      println("Noch kein Bild geladen – drücke erst 'O'");
    }
  } else if (key == '+' || key == '=') {
    numFragments += 50;
    numFragments = constrain(numFragments, 100, 3000);
    println("Fragmente erhöht auf: " + numFragments);
  } else if (key == '-') {
    numFragments -= 50;
    numFragments = constrain(numFragments, 100, 3000);
    println("Fragmente verringert auf: " + numFragments);
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
  
  println("Erzeuge " + numFragments + " leuchtende Fragmente...");
  
  for (int i = 0; i < numFragments; i++) {
    float x = random(width);
    float y = random(height);
    float size = random(30, 220);
    
    int type = int(random(3));
    
    float offsetX = random(-140, 140);
    float offsetY = random(-140, 140);
    
    int sampleX = constrain(int(x + offsetX), 0, original.width-1);
    int sampleY = constrain(int(y + offsetY), 0, original.height-1);
    color c = original.get(sampleX, sampleY);
    
    // Glowing-Effekt: Hohe Sättigung, Helligkeit boosten, leichter Glow
    float h = hue(c);
    float s = saturation(c) * 1.6;  // Sättigung stark erhöhen
    float b = brightness(c) * 1.4; // Helligkeit boosten
    s = constrain(s, 0, 255);
    b = constrain(b, 100, 255);    // Mindesthelligkeit für Glow
    
    color glowingColor = color(h, s, b, 180);  // Transparenz für Überlagerungs-Glow
    
    layer.pushMatrix();
    layer.translate(x, y);
    layer.rotate(random(TWO_PI));
    layer.shearX(random(-0.5, 0.5));
    layer.shearY(random(-0.3, 0.3));
    
    // Innerer Glow: Heller Kern
    layer.fill(h, s*0.8, min(b*1.3, 255), 220);
    if (type == 0) {
      layer.triangle(-size*0.5, -size*0.4, size*0.5, -size*0.4, 0, size*0.6);
    } else if (type == 1) {
      layer.quad(-size*0.5, -size*0.4, size*0.5, -size*0.4, size*0.4, size*0.5, -size*0.4, size*0.5);
    } else {
      layer.ellipse(0, 0, size, size*random(0.7, 1.3));
    }
    
    // Äußerer Rand: Originalton mit Glow
    layer.fill(glowingColor);
    layer.stroke(h, s, b, 220);
    layer.strokeWeight(2);
    if (type == 0) {
      layer.triangle(-size*0.5, -size*0.4, size*0.5, -size*0.4, 0, size*0.6);
    } else if (type == 1) {
      layer.quad(-size*0.5, -size*0.4, size*0.5, -size*0.4, size*0.4, size*0.5, -size*0.4, size*0.5);
    } else {
      layer.ellipse(0, 0, size, size*random(0.7, 1.3));
    }
    
    layer.popMatrix();
  }
  
  layer.endDraw();
  
  canvas.beginDraw();
  canvas.image(layer, 0, 0);
  canvas.endDraw();
  
  println("Neue leuchtend-kubistische Schicht hinzugefügt!");
}
