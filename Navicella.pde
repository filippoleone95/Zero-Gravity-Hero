import java.util.List;

class Navicella {

  PImage navicella;
  PImage[] navicelle;

  // Dichiaro posizione sprites
  float naveX;
  float naveY;

  int frame;

  // Dichiaro e inizializzo le rispettive velocità
  float velocitaNave = 3;

  // Renderizzo un nuovo frame della navicella ogni 30 fps del gioco
  int[] framesNavicella = {29, 59};

  // Costruttore
  Navicella(PApplet parent, String imagePath) {

    // Carico le immagini per gli sprite "assets/nav.gif"
    navicelle = Gif.getPImages(parent, imagePath);

    // Variabile che permette di alternare le schermate della navicella
    frame = 0;

    // Inizializzo l'array con il primo frame della navicella
    navicella = navicelle[frame];

    // Iniziallizzo la posizione della navicella
    naveX = width/2 - navicella.width/2;
    naveY = height - navicella.height - 50;
  }

  // Metodo get per naveX
  public float getWidthNav() {
    return navicella.width;
  }

  // Metodo get per naveY
  public float getHeightNav() {
    return navicella.height;
  }

  void disegnaNavicella() {

    navicella = navicelle[frame];
    navicella.resize(0, 80);

    for (int index = 0; index < framesNavicella.length; index++) {
      if (framesNavicella[index] == countFrame) {
        if (frame < navicelle.length-1) {
          frame++;
        } else {
          frame=0;
        }
      }
    }

    // Disegna la navicella
    image(navicella, naveX, naveY);

    // Aggiorna la posizione della navicella
    if (keyPressed && keyCode == RIGHT) {
      naveX += velocitaNave;
    } else if (keyPressed && keyCode == LEFT) {
      naveX -= velocitaNave;
    }

    // Limita la posizione della navicella all'interno della finestra
    naveX = constrain(naveX, 0, width - navicella.width);
    naveY = constrain(naveY, 0, height - navicella.height);
  }

  // per il momento è qui, bisogna capire se spostarlo nei powerUp o altro
  void spara() {

    if (voloProiettile == false) {
      proiettileX = naveX + navicella.width/2;
      proiettileY = naveY;
      voloProiettile = true;
      imageMode(CENTER);
      image(proiettile, proiettileX, proiettileY);
      imageMode(CORNER);
    } else {
      proiettileY-= velocitaProiettile;

      if (proiettileY <= 0)
        voloProiettile = false;

      else {
        imageMode(CENTER);
        image(proiettile, proiettileX, proiettileY);
        imageMode(CORNER);
      }
    }
  }
}
