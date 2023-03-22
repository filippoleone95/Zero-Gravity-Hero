class GameOver {
  String message = "GAME OVER\nPremi spazio per ricominciare";
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
    textAlign(CENTER, CENTER);
    textSize(48);
    fill(255, 0, 0);
    text(message, width/2, height/2 - 100);
    
    image(restartButton, buttonX, buttonY);
  }
  
  boolean buttonPressed() {
    return mousePressed && mouseX >= buttonX && mouseX <= buttonX + buttonWidth && mouseY >= buttonY && mouseY <= buttonY + buttonHeight;
  }
  
}
