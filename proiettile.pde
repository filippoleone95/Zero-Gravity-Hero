class Proiettile {

  PImage sprite;
  boolean attivo = false;
  boolean inVolo = false;
  float x, y;
  float velocita = 10;
  int caricatore = 0;

  Proiettile() {
    sprite = loadImage("assets/proiettileNuovo.png");
  }

  PImage getSprite() {
    return this.sprite;
  }

  float getX() {
    return this.x;
  }

  float getY() {
    return this.y;
  }

  float getVelocita() {
    return this.velocita;
  }

  boolean isInVolo() {
    return this.inVolo;
  }

  boolean isAttivo() {
    return this.attivo;
  }

  void setX(float x) {
    this.x = x;
  }

  void setY(float y) {
    this.y = y;
  }

  void setInVolo(boolean inVolo) {
    this.inVolo = inVolo;
  }

  void setAttivo(boolean attivo) {
    this.attivo = attivo;
  }

  void disegna() {
    imageMode(CENTER);
    image(this.sprite, this.x, this.y);
    imageMode(CORNER);
  }

  void muovi() {
    this.y -= this.velocita;
  }

  void resetCaricatore() {
    this.caricatore = 0;
    this.setAttivo(false);
    proiettile.setInVolo(false);
  }
}
