import java.util.List;

class Navicella {

  Proiettile proiettile;

  PImage sprite;
  PImage[] navicelle;

  // Dichiaro posizione sprites
  float x, y;

  int frame;

  int counter = 0;

  // Dichiaro e inizializzo le rispettive velocità
  float velocita = 3;
  
  int lastToggleTime;
  boolean isRed = false;
  boolean isFlashing = false;
  int isColpita = 0;
  int startLampeggio = 0;

  int counterPowerUpVelocita = 0;

  float getX() {
    return this.x;
  }

  float getY() {
    return this.y;
  }

  PImage getSprite() {
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
      
    if(isColpita == 1) {
      // tempo da un lampeggio ad un altro
      lastToggleTime = millis();
      // tempo dall'inizio del lampeggio
      startLampeggio = millis();
      isFlashing = true;
      isColpita = 0;
    }
      
    if (isFlashing) {
      if (millis() - lastToggleTime > 300) {
        isRed = !isRed;
        lastToggleTime = millis();
      }
    }

    if (millis() - startLampeggio > 3000) {
      isFlashing = false;
      isRed = false;
    }

    tint(isRed ? color(255, 0, 0) : color(255));
    // Disegna la navicella
    image(this.sprite, this.x, this.y);
    tint(color(255));

    // Aggiorna la posizione della navicella
    if (keyPressed && keyCode == RIGHT) {
      this.x += this.velocita;
      if (counterPowerUpVelocita != 0)
        this.x += 3;
    } else if (keyPressed && keyCode == LEFT) {
      this.x -= this.velocita;
      if (counterPowerUpVelocita != 0)
        this.x -= 3;
    }

    if (powerUp != null && --counterPowerUpVelocita <0){
      counterPowerUpVelocita = 0;
    }
    // Limita la posizione della navicella all'interno della finestra
    this.x = constrain(x, 30, width - sprite.width - 30);//e lode
  }

  // per il momento è qui, bisogna capire se spostarlo nei powerUp o altro
  void spara() {

    //spara sempre - da ottimizzare con la variabile attivo
    if (!proiettile.isInVolo()) {
      proiettile.setX(this.x + this.sprite.width/2);
      proiettile.setY(this.y);
      proiettile.setInVolo(true);
      proiettile.disegna();
      suoniAndFX.playFire();
      proiettile.caricatore--;
    } else {
      proiettile.muovi();

      if (proiettile.getY() <= 0) {
        proiettile.setInVolo(false);
        if (proiettile.caricatore == 0){
          proiettile.setAttivo(false);
        }

      }
      proiettile.disegna();
        
      }
    }
  

  Proiettile getProiettile() {
    return this.proiettile;
  }
}
