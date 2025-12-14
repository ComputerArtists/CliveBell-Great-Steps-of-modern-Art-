PGraphics canvas;
PImage original;
boolean showOriginal = true;
int numStacks = 7;
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
  text("O = Neue Stacks-Schicht erstellen (auch ohne Bild)\n" +
       "S = Speichern\n" +
       "N = Reset\n" +
       "M = Originalbild stark/schwach anzeigen\n" +
       "+ / - = Anzahl Stacks: " + numStacks + "\n" +
       "F = Fallback-Farbe wechseln\n", 
       20, 40);
}

void keyPressed() {
  if (key == 'o' || key == 'O') {
    createNewStackLayer();
    selectInput("Optional: Neues Bild laden (beeinflusst nächste Schicht)", "fileSelected");
  } else if (key == 's' || key == 'S') {
    String filename = "minimal_fluo_stacks_" + year() + nf(month(),2) + nf(day(),2) + "_" 
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
    println("Originalbild jetzt " + (showOriginal ? "stark" : "schwach") + " sichtbar");
  } else if (key == '+' || key == '=') {
    numStacks = constrain(numStacks + 1, 4, 14);
    println("Stacks: " + numStacks);
  } else if (key == '-') {
    numStacks = constrain(numStacks - 1, 4, 14);
    println("Stacks: " + numStacks);
  } else if (key == 'f' || key == 'F') {
    colorMode = (colorMode + 1) % 5;
    println("Fallback-Farbe gewechselt");
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Kein neues Bild geladen");
    return;
  }
  
  original = loadImage(selection.getAbsolutePath());
  if (original != null) {
    original.resize(width, height);
    showOriginal = true;
    println("Neues Bild geladen");
  }
}

void createNewStackLayer() {
  PGraphics layer = createGraphics(width, height);
  layer.beginDraw();
  layer.background(0, 0);
  
  color base;
  
  if (original != null) {
    original.loadPixels();
    color c1 = original.get(width/4, height/2);
    color c2 = original.get(width/2, height/2);
    color c3 = original.get(3*width/4, height/2);
    base = lerpColor(lerpColor(c1, c2, 0.5), c3, 0.33);
    
    float brightness = brightness(base);
    if (brightness > 200) {
      base = lerpColor(base, color(red(base)*0.8, green(base)*0.8, blue(base)*0.8), 0.4);
    }
    
    base = color(red(base)*1.3, green(base)*1.4, blue(base)*1.3);
  } else {
    base = fallbackColors[colorMode];
  }
  
  // *** Hier wurde das Motiv deutlich kleiner gemacht ***
  float totalHeight = height * 0.55;  // Von 0.75 → 0.55 (ca. 27% kleiner)
  float stackHeight = totalHeight / numStacks;
  float spacing = stackHeight * 0.5;   // Etwas mehr Luft zwischen den Stacks
  
  float usedHeight = numStacks * stackHeight + (numStacks - 1) * spacing;
  float startY = (height - usedHeight) / 2;  // Perfekt vertikal zentriert
  
  float boxWidth = width * 0.35;    // Breite von 0.5 → 0.35 (schlanker)
  float xLeft = (width - boxWidth) / 2;  // Horizontal exakt zentriert
  
  layer.blendMode(ADD);
  
  for (int glow = 10; glow > 0; glow--) {
    float alpha = map(glow, 1, 10, 15, 100);
    float thick = stackHeight + glow * 8;  // Leicht reduzierter Glow-Radius
    float offset = glow * 6;
    
    layer.noStroke();
    layer.fill(red(base), green(base), blue(base), alpha);
    
    for (int i = 0; i < numStacks; i++) {
      float y = startY + i * (stackHeight + spacing);
      layer.rect(xLeft - offset, y - offset, boxWidth + offset*2, thick, 15 + glow*2);
    }
  }
  
  // Heller Kern
  layer.fill(red(base), green(base), blue(base), 200);
  for (int i = 0; i < numStacks; i++) {
    float y = startY + i * (stackHeight + spacing);
    layer.rect(xLeft, y, boxWidth, stackHeight, 12);
  }
  
  layer.endDraw();
  
  canvas.beginDraw();
  canvas.image(layer, 0, 0);
  canvas.endDraw();
  
  println("Neue kleinere, zentrierte Stacks-Schicht hinzugefügt!");
}
