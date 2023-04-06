class PowerUp {

  float powerUpX, powerUpY, valocitaPowerUp = 2;
  PImage powerUp;

  PowerUp () {
    this.powerUp = loadImage("assets/PowerUp.png");
    powerUpX = random(powerUp.width + 10, (frameWidth - powerUp.width) - 10);
    powerUpY = -powerUp.height;
  }

  void disegnaPowerUp(int frameWidth, int frameHeight) {

    if (this.powerUpY > frameHeight) {
      powerUpY = -powerUp.height;
      powerUpX = random(powerUp.width + 10, (frameWidth - powerUp.width) - 10);
    }

    powerUpY += valocitaPowerUp;
    image(powerUp, powerUpX, powerUpY);
  }

  float getPowerUpY() {
    return this.powerUpY;
  }
  
  float getPowerUpX() {
    return this.powerUpX;
  }
  
  float getPowerUpWidth() {
    return this.powerUp.width;
  }
  
  float getPowerUpHeight() {
    return this.powerUp.height;
  }
}
