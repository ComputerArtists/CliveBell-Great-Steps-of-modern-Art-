PGraphics canvas;
PImage original;
boolean showOriginal = true;
int gridLines = 20;         // Startwert (Anzahl Linien horizontal + vertikal) – mit + / - änderbar (10–50)
int colorMode = 0;

color[] fallbackColors = {
  color(255, 100, 200),  // Rosa
  color(100, 200, 255),  // Blau
  color(100, 255, 150),  // Grün
  color(255, 255, 100),  // Gelb
  color(255, 255, 255)   // Weiß
};

void setup() {
  size(1200, 800);
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(20);
  canvas.endDraw();
  
  displayHelp();
}

void draw() {
  background(20);
  
  if (original != null) {
    if (showOriginal) {
      image(original, 0, 0, width, height);
    } else {
      tint(255, 60);
      image(original, 0, 0, width, height);
      noTint();
    }
  }
  
  image(canvas, 0, 0);
  
  displayHelp();
}

void displayHelp() {
  fill(200);
  textSize(18);
  textAlign(LEFT);
  text("O = Neue Grid-Schicht erstellen (auch ohne Bild)\n" +
       "S = Speichern\n" +
       "N = Reset\n" +
       "M = Originalbild stark/schwach anzeigen\n" +
       "+ / - = Grid-Linien: " + gridLines + " pro Richtung\n" +
       "F = Fallback-Farbe wechseln\n", 
       20, 40);
}

void keyPressed() {
  if (key == 'o' || key == 'O') {
    createNewGridLayer();
    selectInput("Optional: Neues Bild laden (beeinflusst nächste Grid-Farbe)", "fileSelected");
  } else if (key == 's' || key == 'S') {
    String filename = "minimal_fluo_grid_" + year() + nf(month(),2) + nf(day(),2) + "_" 
                      + nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    save(filename);
    println("Gespeichert als: " + filename);
  } else if (key == 'n' || key == 'N') {
    canvas.beginDraw();
    canvas.background(20);
    canvas.endDraw();
    original = null;
    showOriginal = true;
    println("Alles zurückgesetzt");
  } else if (key == 'm' || key == 'M') {
    showOriginal = !showOriginal;
  } else if (key == '+' || key == '=') {
    gridLines = constrain(gridLines + 5, 10, 50);
    println("Grid-Linien: " + gridLines);
  } else if (key == '-') {
    gridLines = constrain(gridLines - 5, 10, 50);
    println("Grid-Linien: " + gridLines);
  } else if (key == 'f' || key == 'F') {
    colorMode = (colorMode + 1) % 5;
    println("Fallback-Farbe gewechselt");
  }
}

void fileSelected(File selection) {
  if (selection == null) return;
  
  original = loadImage(selection.getAbsolutePath());
  if (original != null) {
    original.resize(width, height);
    showOriginal = true;
    println("Neues Bild geladen");
  }
}

void createNewGridLayer() {
  PGraphics layer = createGraphics(width, height);
  layer.beginDraw();
  layer.background(0, 0);
  
  color base;
  
  if (original != null) {
    original.loadPixels();
    color c1 = original.get(width/3, height/2);
    color c2 = original.get(width/2, height/2);
    color c3 = original.get(2*width/3, height/2);
    base = lerpColor(lerpColor(c1, c2, 0.5), c3, 0.33);
    
    // Bei zu hellen Farben abdunkeln, um Überstrahlung zu vermeiden
    if (brightness(base) > 200) {
      base = lerpColor(base, color(red(base)*0.7, green(base)*0.7, blue(base)*0.7), 0.5);
    }
    
    base = color(red(base)*1.3, green(base)*1.4, blue(base)*1.3);
  } else {
    base = fallbackColors[colorMode];
  }
  
  float spacingH = width / (gridLines + 1.0);
  float spacingV = height / (gridLines + 1.0);
  
  layer.blendMode(ADD);
  
  // Mehrfacher Glow für jede Linie
  for (int glow = 8; glow > 0; glow--) {
    float alpha = map(glow, 1, 8, 20, 80);
    float thick = 1 + glow * 1.5;
    
    layer.stroke(red(base), green(base), blue(base), alpha);
    layer.strokeWeight(thick);
    layer.noFill();
    
    // Horizontale Linien
    for (int i = 1; i <= gridLines; i++) {
      float y = i * spacingV;
      layer.line(0 - glow*10, y, width + glow*10, y);
    }
    
    // Vertikale Linien
    for (int i = 1; i <= gridLines; i++) {
      float x = i * spacingH;
      layer.line(x, 0 - glow*10, x, height + glow*10);
    }
  }
  
  // Scharfe Kernlinien
  layer.stroke(red(base), green(base), blue(base), 200);
  layer.strokeWeight(1);
  
  for (int i = 1; i <= gridLines; i++) {
    float y = i * spacingV;
    layer.line(0, y, width, y);
  }
  
  for (int i = 1; i <= gridLines; i++) {
    float x = i * spacingH;
    layer.line(x, 0, x, height);
  }
  
  layer.endDraw();
  
  canvas.beginDraw();
  canvas.image(layer, 0, 0);
  canvas.endDraw();
  
  println("Neue fluoreszierende Grid-Schicht mit " + gridLines + " Linien pro Richtung hinzugefügt!");
}
