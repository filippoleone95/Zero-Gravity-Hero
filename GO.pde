class GameOver {
  String message = "GAME OVER";
  PImage restartButton;
  int buttonWidth;
  int buttonHeight;
  int buttonX;
  int buttonY;

  GameOver() {
    restartButton = loadImage("assets/restart_button.png");
    restartButton.resize(250, 100);
    buttonWidth = restartButton.width;
    buttonHeight = restartButton.height;
    buttonX = (width - buttonWidth) / 2;
    buttonY = (height - buttonHeight) / 2;
  }

  void display() {
    textFont(defaultFont);
    textAlign(CENTER, CENTER);
    textSize(48);
    fill(255, 0, 0);
    text(message, width/2, height/2 - 100);
    fill(255);
    textSize(25);
    text("premi spazio per ricominciare", width/2, height - 100);

    image(restartButton, buttonX, buttonY);
  }
}
