import processing.sound.*;

class SuoniAndFX {

  SoundFile songMenu;
  SoundFile songGame;

  SoundFile asteroidCollision;
  SoundFile meteoriteCollision;
  SoundFile meteoriteExplosion;
  SoundFile fire;
  SoundFile powerUp;

  int volumeState = 3; // Valore iniziale del volume
  boolean muted = false;

  SuoniAndFX(PApplet parent) {
    this.songMenu = new SoundFile(parent, "songMenu.mp3");
    this.songGame = new SoundFile(parent, "songGame.wav");
    this.asteroidCollision = new SoundFile(parent, "asteroidCollision.wav");
    this.meteoriteCollision = new SoundFile(parent, "meteoriteCollision.mp3");
    this.meteoriteExplosion = new SoundFile(parent, "meteoriteExplosion.wav");
    this.fire = new SoundFile(parent, "fire.mp3");
    this.powerUp = new SoundFile(parent, "powerUp.wav");
  }

  void playSongMenu() {
    if (!muted) {
      this.songMenu.play();
      this.songMenu.loop();
    }
  }

  void stopSongMenu() {
    this.songMenu.stop();
  }

  void playSongGame() {
    if (!muted) {
      this.songGame.play();
    }
  }

  void stopSongGame() {
    this.songGame.stop();
  }

  void asteroidCollision() {
    if (!muted) {
      this.songGame.stop();
      this.asteroidCollision.play();
    }
  }

  void meteoriteCollision() {
    if (!muted) {
      this.songGame.stop();
      this.meteoriteCollision.play();
    }
  }

  void meteoriteExplosion() {
    if (!muted) {
      this.meteoriteExplosion.play();
    }
  }

  void playFire() {
    if (!muted) {
      this.fire.play();
    }
  }

  void playPowerUp() {
    if (!muted) {
      this.powerUp.play();
    }
  }

  void muteSounds() {
    if (this.songMenu.isPlaying()) {
      this.songMenu.pause();
    }
    if (this.songGame.isPlaying()) {
      this.songGame.pause();
    }
    this.asteroidCollision.stop();
    this.meteoriteCollision.stop();
    this.meteoriteExplosion.stop();
    this.fire.stop();
    this.powerUp.stop();
  }
  
  void decrementVolume() {
    this.volumeState = max(1, suoniAndFX.volumeState - 1);
    setVolume();
  }
  
  void incrementVolume() {
    this.volumeState = min(5, suoniAndFX.volumeState + 1);
    setVolume();
  }
  
  void setVolume() {
    this.songMenu.amp(map(volumeState, 1, 5, 0.2, 1.0));
    this.songGame.amp(map(volumeState, 1, 5, 0.2, 1.0));
    this.asteroidCollision.amp(map(volumeState, 1, 5, 0.2, 1.0));
    this.meteoriteCollision.amp(map(volumeState, 1, 5, 0.2, 1.0));
    this.fire.amp(map(volumeState, 1, 5, 0.2, 1.0));
    this.powerUp.amp(map(volumeState, 1, 5, 0.2, 1.0));
  }
  
  void unmuteSounds(int gameState) {
     if (gameState == -1) songMenu.play();
     else if(gameState == 0) songGame.play();
  }
}
