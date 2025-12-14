PGraphics canvas;
PImage original;
boolean showOriginal = true;
int numElements = 12;       // Startwert – mit + / - änderbar (8–30)
int colorMode = 0;          // Jetzt wirkt es sofort!

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
  text("O = Neue Wall-Drawing-Schicht erstellen (auch ohne Bild)\n" +
       "S = Speichern\n" +
       "N = Reset\n" +
       "M = Originalbild stark/schwach anzeigen\n" +
       "+ / - = Elemente: " + numElements + "\n" +
       "F = Farbe wechseln (wirkt bei nächster Schicht – aktuell: " + getColorName(colorMode) + ")\n", 
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
    createNewWallDrawingLayer();
    selectInput("Optional: Neues Bild laden (beeinflusst nächste Farbe)", "fileSelected");
  } else if (key == 's' || key == 'S') {
    String filename = "minimal_fluo_walldrawing_" + year() + nf(month(),2) + nf(day(),2) + "_" 
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
    numElements = constrain(numElements + 4, 8, 30);
    println("Elemente: " + numElements);
  } else if (key == '-') {
    numElements = constrain(numElements - 4, 8, 30);
    println("Elemente: " + numElements);
  } else if (key == 'f' || key == 'F') {
    colorMode = (colorMode + 1) % 5;
    println("Farbe gewechselt zu: " + getColorName(colorMode) + " (wirkt bei nächster Schicht mit 'O')");
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

void createNewWallDrawingLayer() {
  PGraphics layer = createGraphics(width, height);
  layer.beginDraw();
  layer.background(0, 0);
  
  color base;
  
  if (original != null) {
    original.loadPixels();
    color c1 = original.get(width/4, height/3);
    color c2 = original.get(width/2, height/2);
    color c3 = original.get(3*width/4, 2*height/3);
    base = lerpColor(lerpColor(c1, c2, 0.5), c3, 0.33);
    
    if (brightness(base) > 200) {
      base = lerpColor(base, color(red(base)*0.7, green(base)*0.7, blue(base)*0.7), 0.5);
    }
    
    base = color(red(base)*1.3, green(base)*1.4, blue(base)*1.3);
  } else {
    base = fallbackColors[colorMode];  // Jetzt korrekt verwendet
  }
  
  layer.blendMode(ADD);
  layer.noFill();
  
  // Mehr Variation in der Geometrie
  float maxRadius = min(width, height) * 0.8;
  float step = maxRadius / (numElements + 2.0);
  
  for (int glow = 10; glow > 0; glow--) {
    float alpha = map(glow, 1, 10, 20, 100);
    float thick = 1 + glow * 1.8;
    layer.stroke(red(base), green(base), blue(base), alpha);
    layer.strokeWeight(thick);
    
    for (int i = 1; i <= numElements; i++) {
      float r = i * step + random(-step*0.2, step*0.2);  // Leichte organische Variation
      
      // 1. Konzentrische Bögen von den vier Ecken (mit variierendem Winkel)
      float angleVar = random(-QUARTER_PI/2, QUARTER_PI/2);
      layer.arc(0, 0, r*2, r*2, angleVar, HALF_PI + angleVar);
      layer.arc(width, 0, r*2, r*2, HALF_PI + angleVar, PI + angleVar);
      layer.arc(width, height, r*2, r*2, PI + angleVar, PI + HALF_PI + angleVar);
      layer.arc(0, height, r*2, r*2, PI + HALF_PI + angleVar, TWO_PI + angleVar);
      
      // 2. Diagonale Wellenlinien statt gerader Linien
      layer.beginShape();
      float waveAmp = random(20, 80);
      for (float x = 0; x <= width; x += 20) {
        float y = map(x, 0, width, 0, height) + sin(x * 0.02 + i) * waveAmp;
        layer.curveVertex(x + random(-5,5), y + random(-5,5));
      }
      layer.endShape();
      
      // 3. Zufällige horizontale/vertikale Segmente für mehr Komplexität
      if (random(1) < 0.4) {
        float x1 = random(width);
        float y1 = random(height * 0.3);
        float x2 = random(width);
        float y2 = height - y1;
        layer.line(x1, y1, x2, y2);
      }
    }
  }
  
  // Scharfe Kernlinien mit leichter Variation
  layer.stroke(red(base), green(base), blue(base), 220);
  layer.strokeWeight(1.5);
  
  for (int i = 1; i <= numElements; i++) {
    float r = i * step + random(-step*0.15, step*0.15);
    float angleVar = random(-QUARTER_PI/3, QUARTER_PI/3);
    layer.arc(0, 0, r*2, r*2, angleVar, HALF_PI + angleVar);
    layer.arc(width, 0, r*2, r*2, HALF_PI + angleVar, PI + angleVar);
    layer.arc(width, height, r*2, r*2, PI + angleVar, PI + HALF_PI + angleVar);
    layer.arc(0, height, r*2, r*2, PI + HALF_PI + angleVar, TWO_PI + angleVar);
  }
  
  layer.endDraw();
  
  canvas.beginDraw();
  canvas.image(layer, 0, 0);
  canvas.endDraw();
  
  println("Neue variierte fluoreszierende Wall-Drawing-Schicht hinzugefügt!");
}
