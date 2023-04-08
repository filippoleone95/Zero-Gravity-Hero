class PowerUp {

  float x, y, velocita = 2;
  PImage sprite;
  int tipo;
  boolean visibile;

  PowerUp() {
    this.tipo = floor(random(5));
    this.visibile = true;

    switch (tipo) {
      //proiettili
    case 0:
    case 1:
      this.sprite = loadImage("assets/powerUpSparo.png");
      break;

      //velocita
    case 2:
    case 3:
      this.sprite = loadImage("assets/PowerUpVelocita.png");
      break;

      //boom
    case 4:
      this.sprite = loadImage("assets/PowerUpEsplosione.png");
      break;
    }
    this.x = random(sprite.width + 10, (width - sprite.width) - 10);
    this.y = -sprite.height;
  }

  void setVisibile(boolean visibile) {
    this.visibile = visibile;
  }

  void disegna() {

    image(sprite, this.x, this.y);
    y += velocita;

    if (this.y > height)
      this.visibile = false;
  }

  float getY() {
    return this.y;
  }

  float getX() {
    return this.x;
  }


  boolean isVisibile() {
    return this.visibile;
  }

  void performaPowerUp() {

    switch (this.tipo) {

    case 0:
    case 1:
      proiettile.caricatore += 25;
      proiettile.setAttivo(true);
      break;

    case 2:
    case 3:
      navicella.counterPowerUpVelocita = 600;
      break;

    case 4:
      for (Meteorite meteorite : meteoriti) {
        if (meteorite == null)
          break;

        meteorite.colpisci();
      }
      suoniAndFX.meteoriteExplosion();
      break;
    }
  }
}
