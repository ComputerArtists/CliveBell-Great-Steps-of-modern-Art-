PGraphics canvas;
PImage original;
boolean showOriginal = true;
int numStripes = 8;         // Startwert – mit + / - (5–20)
int colorMode = 0;
boolean horizontal = true;  // Start: horizontal – mit H wechseln

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
  text("O = Neue Stripe-Schicht erstellen (auch ohne Bild)\n" +
       "S = Speichern\n" +
       "N = Reset\n" +
       "M = Originalbild stark/schwach anzeigen\n" +
       "+ / - = Anzahl Streifen: " + numStripes + "\n" +
       "F = Fallback-Farbe wechseln (aktuell: " + getColorName(colorMode) + ")\n" +
       "H = Richtung wechseln (aktuell: " + (horizontal ? "horizontal" : "vertikal") + ")\n", 
       20, 40);
}

String getColorName(int m) {
  switch(m) {
    case 0: return "Rosa";
    case 1: return "Blau";
    case 2: return "Grün";
    case 3: return "Gelb";
    case 4: return "Weiß";
    default: return "";
  }
}

void keyPressed() {
  if (key == 'o' || key == 'O') {
    createNewStripeLayer();
    selectInput("Optional: Neues Bild laden (beeinflusst nächste Farbe)", "fileSelected");
  } else if (key == 's' || key == 'S') {
    String filename = "minimal_fluo_blackstripes_" + year() + nf(month(),2) + nf(day(),2) + "_" 
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
    numStripes = constrain(numStripes + 1, 5, 20);
    println("Streifen: " + numStripes);
  } else if (key == '-') {
    numStripes = constrain(numStripes - 1, 5, 20);
    println("Streifen: " + numStripes);
  } else if (key == 'f' || key == 'F') {
    colorMode = (colorMode + 1) % 5;
    println("Farbe gewechselt zu: " + getColorName(colorMode));
  } else if (key == 'h' || key == 'H') {
    horizontal = !horizontal;
    println("Richtung gewechselt zu: " + (horizontal ? "horizontal" : "vertikal"));
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

void createNewStripeLayer() {
  PGraphics layer = createGraphics(width, height);
  layer.beginDraw();
  layer.background(0, 0);
  
  color base;
  
  if (original != null) {
    original.loadPixels();
    color cCenter = original.get(width/2, height/2);
    base = cCenter;
    
    // Starker Schutz gegen Überhelligkeit
    float bright = brightness(base);
    if (bright > 150) {
      float factor = map(bright, 150, 255, 0.8, 0.4);
      base = lerpColor(base, color(20), factor);  // Mischung mit dunklem Hintergrund
    }
    
    // Kontrollierter, sanfter Boost
    base = color(
      constrain(red(base)*1.1, 0, 220),
      constrain(green(base)*1.2, 0, 220),
      constrain(blue(base)*1.1, 0, 220)
    );
  } else {
    base = fallbackColors[colorMode];
  }
  
  float totalSpace = horizontal ? height : width;
  float stripeThickness = totalSpace * 0.7 / numStripes;
  float spacing = (totalSpace * 0.9 - numStripes * stripeThickness) / (numStripes + 1);
  float start = spacing;
  
  layer.blendMode(ADD);
  
  // Reduzierter, kontrollierter Glow
  for (int glow = 8; glow > 0; glow--) {
    float alpha = map(glow, 1, 8, 15, 70);
    float thick = stripeThickness + glow * 8;
    float offset = glow * 5;
    
    layer.noStroke();
    layer.fill(red(base), green(base), blue(base), alpha);
    
    for (int i = 0; i < numStripes; i++) {
      float pos = start + i * (stripeThickness + spacing);
      if (horizontal) {
        layer.rect(0 - offset, pos - offset, width + offset*2, thick);
      } else {
        layer.rect(pos - offset, 0 - offset, thick, height + offset*2);
      }
    }
  }
  
  // Heller, aber nicht zu weißer Kern
  layer.fill(red(base), green(base), blue(base), 180);
  for (int i = 0; i < numStripes; i++) {
    float pos = start + i * (stripeThickness + spacing);
    if (horizontal) {
      layer.rect(0, pos, width, stripeThickness);
    } else {
      layer.rect(pos, 0, stripeThickness, height);
    }
  }
  
  layer.endDraw();
  
  canvas.beginDraw();
  canvas.image(layer, 0, 0);
  canvas.endDraw();
  
  println("Neue fluoreszierende Black-Stripes-Schicht hinzugefügt (" + numStripes + " Streifen, " + (horizontal ? "horizontal" : "vertikal") + ")!");
}
