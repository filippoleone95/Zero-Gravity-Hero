import java.util.List;

class Navicella {
  
  Proiettile proiettile;

  PImage sprite;
  PImage[] navicelle;

  // Dichiaro posizione sprites
  float x,y;

  int frame;
  
  int counter = 0;

  // Dichiaro e inizializzo le rispettive velocità
  float velocita = 3;

  float getX(){
    return this.x;
  }
  
  float getY(){
    return this.y;
  }
  
  PImage getSprite(){
    return this.sprite;
  }

  // Costruttore
  Navicella(PApplet parent) {

    // Carico le immagini per gli sprite "assets/nav.gif"
    navicelle = Gif.getPImages(parent, "assets/nav.gif");
    
    //Imposto la dimensione di ogni sprite a 80
    for (PImage navicella : navicelle)
      navicella.resize(0, 80);

    // Variabile che permette di alternare le schermate della navicella
    frame = 0;

    // Inizializzo l'array con il primo frame della navicella
    this.sprite = navicelle[frame];

    // Iniziallizzo la posizione della navicella
    this.x = width/2 - sprite.width/2;
    this.y = height - sprite.height - 50;
    
    proiettile = new Proiettile();
  }

  void disegnaNavicella() {

    this.sprite = navicelle[frame];    
    
    if (counter++ % 30 == 29) {
        if (frame < navicelle.length-1) {
          frame++;
        } else {
          frame=0;
        }
    }
    
    if (counter == 60)
      counter = 0;

    // Disegna la navicella
    image(this.sprite, this.x, this.y);

    // Aggiorna la posizione della navicella
    if (keyPressed && keyCode == RIGHT) {
      this.x += this.velocita;
    } else if (keyPressed && keyCode == LEFT) {
      this.x -= this.velocita;
    }

    // Limita la posizione della navicella all'interno della finestra
    this.x = constrain(x, 0, width - sprite.width);
    this.y = constrain(y, 0, height - sprite.height);
  }

  // per il momento è qui, bisogna capire se spostarlo nei powerUp o altro
  void spara() {

    //spara sempre - da ottimizzare con la variabile attivo
    if (!proiettile.isInVolo()) {
      proiettile.setX(this.x + sprite.width/2);
      proiettile.setY(this.y);
      proiettile.setInVolo(true);
      proiettile.disegna();
    } 
    else {
      proiettile.muovi();

      if (proiettile.getY() <= 0)
        proiettile.setInVolo(false);

      else {
        proiettile.disegna();
      }
    }
  }
  
  Proiettile getProiettile(){
    return this.proiettile;
  }
}
