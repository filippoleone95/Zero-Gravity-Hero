import java.util.Arrays;
import java.util.List;
import gifAnimation.*;

class Asteroide {

  PImage sprite;

  PImage[] asteroidi;

  float x, y, velocita;

  boolean visibile;

  int frame, counter;

  // true = destra; false = sinistra;
  boolean direzione;

  Asteroide(PApplet parent, float velocita) {
    // Carico le immagini per gli sprite
    this.asteroidi = Gif.getPImages(parent, "assets/ast.gif");

    int dimensione = floor(random(100, 201));

    for (PImage asteroide : asteroidi)
      asteroide.resize(0, dimensione);

    setDirezione();

    if (getDirezione() == DESTRA)
      this.asteroidi = riflettiOrizz(this.asteroidi);      
    
    this.frame = 0;
    this.sprite = asteroidi[frame];
    posiziona();

    this.velocita = velocita;
    
    this.counter = 0;
    
  }

  void setDirezione() {
    
    if (floor(random(2)) == 1)
      this.direzione = SINISTRA;
    else
      this.direzione = DESTRA;
  }

  //true = destra; false = sinistra;
  boolean getDirezione() {
    return this.direzione;
  }

  void disegna() {
    if (visibile) {
      this.sprite = asteroidi[frame];
      disegnaStatico();
      aggiornaPosizione();
      
      //cambio sprite ogni 5 frame
      if (counter++ % 5 == 4)
        prossimoFrame();
      
      if (counter == 5)
        counter = 0;
    }
  }

  void disegnaStatico() {
    image(this.sprite, this.x, this.y);
  }

  void aggiornaPosizione() {
    this.y += this.velocita;
    
    if (getDirezione() == SINISTRA)
      this.x -= this.velocita/2;
    else
      this.x += this.velocita/2;
  }

  void prossimoFrame() {
    if (this.frame<asteroidi.length-1) {
      this.frame++;
    } else {
      this.frame=0;
    }
  }

  float getX() {
    return this.x;
  }

  float getY() {
    return this.y;
  }

  PImage getSprite(){
    return this.sprite;
  }

  void setVisibile(boolean visibile) {
    this.visibile = visibile;
  }
  
  boolean isVisibile(){
    return this.visibile;
  }

  void posiziona() {
    if (getDirezione() == SINISTRA)
      this.x = random(330, width - sprite.width);
    else
      this.x = random(width - 330);

    this.y = -sprite.height;
    setVisibile(true);
  }

  PImage[] riflettiOrizz(PImage[] images) {

    ArrayList<PImage> reverse = new ArrayList<>();

    for (PImage sprite : images) {
      PImage asteroide = new PImage(sprite.width, sprite.height);
      for ( int i=0; i < sprite.width; i++ ) {
        for (int j=0; j < sprite.height; j++) {
          //scambia i pixel dell'immagine
          asteroide.set( sprite.width - 1 - i, j, sprite.get(i, j) );
        }
      }
      reverse.add(asteroide);
    }

    return reverse.toArray(new PImage[reverse.size()]);
  }
 
}
