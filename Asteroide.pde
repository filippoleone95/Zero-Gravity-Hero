import java.util.Arrays;
import java.util.List;
import gifAnimation.*;

class Asteroide {

  PImage asteroide;
  PImage asteroideFlip;
  PImage[] asteroidi;

  float asteroideX;
  float asteroideY;

  boolean cadutaAsteroide = false;

  int i;
  float flip;

  // Renderizzo un nuovo frame dell'asteroide ogni 10 fps del gioco
  int[] framesAsteroide = {4, 9, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59};

  Asteroide(PApplet parent) {
    // Carico le immagini per gli sprite
    this.asteroidi = Gif.getPImages(parent, "assets/ast.gif");
    this.i = 0;
    flip = random(50);
  }

  boolean disegnaAsteroide(int frameWidth, int frameHeight, float velocitaAsteroide) {
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

      flip = random(50);
      // 330 = quantità di pixel in cui l'asteroide si muove sull'asse X calcolata

      if (flip < 25)
        //asteroide va da destra verso sinistra
        asteroideX = random(330, frameWidth - asteroide.width);
      else
        //asteroide va da sinistra verso destra
        asteroideX = random(frameWidth - 330);

      asteroideY = -asteroide.height;
      cadutaAsteroide = true;
    }

    // Agguirna e disegna la posizione dell'asteroide
    asteroideY += velocitaAsteroide;
    if (flip < 25) {
      asteroideX -= 1;
      image(asteroide, asteroideX, asteroideY);
    } else {
      pushMatrix();
      scale(-1, 1);
      image(asteroide, -asteroideX, asteroideY);
      asteroideX += 1;
      popMatrix();
    }

    // Se l'asteroide arriva a terra, crea un nuovo asteroide
    if (asteroideY > frameHeight)
      cadutaAsteroide = false;

    if (flip < 25)
      return true;
    else
      return false;
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
