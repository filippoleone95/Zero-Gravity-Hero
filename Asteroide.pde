import java.util.Arrays;
import java.util.List;
import gifAnimation.*;

class Asteroide {

  PImage asteroide;
  PImage[] asteroidi;

  float asteroideX;
  float asteroideY;

  float velocitaAsteroide = 2;

  boolean cadutaAsteroide = false;

  int i;

  // Renderizzo un nuovo frame dell'asteroide ogni 10 fps del gioco
  int[] framesAsteroide = {4, 9, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59};

  Asteroide(PApplet parent) {
    // Carico le immagini per gli sprite
    this.asteroidi = Gif.getPImages(parent, "assets/ast.gif");
    this.i = 0;
  }

  void disegnaAsteroide(int frameWidth, int frameHeight) {
    asteroide = asteroidi[this.i];
    asteroide.resize(0, 60);

    // Incremento la variabile i che conta il frame da stampare a schermo, se ho raggiunto l'ultimo frame, resetto la variabile i
    for (int index = 0; index < framesAsteroide.length; index++) {
      if (framesAsteroide[index] == countFrame) {
        if (this.i<asteroidi.length-1) {
          this.i++;
        } else {
          this.i=0;
        }
      }
    }

    // Creo un nuovo asteroide che parte dall'alto appena l'asteroide precedentemente creato raggiunge il fondo dello schermo
    if (!cadutaAsteroide) {
      asteroideX = random(frameWidth - asteroide.width);
      asteroideY = -asteroide.height;
      cadutaAsteroide = true;
    }

    // Agguirna e disegna la posizione dell'asteroide
    asteroideY += velocitaAsteroide;
    image(asteroide, asteroideX, asteroideY);


    // Se l'asteroide arriva a terra, crea un nuovo asteroide
    if (asteroideY > frameHeight)
      cadutaAsteroide = false;
      
  }
  
  float getX() {
    return this.asteroideX;
  }
  
  float getY() {
    return this.asteroideY;
  }
  
  int getWidth() {
    return asteroide.width; 
  }
  
  int getHeight() {
    return asteroide.height; 
  }
  
  PImage getPimage() {
    return this.asteroide; 
  }
  
  void setCadutaAsteroide(boolean cadutaAsteroide) {
    this.cadutaAsteroide = cadutaAsteroide;
  }
  
}
