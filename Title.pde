class Title {
  PImage sfondo;
  String[] options= {"GIOCA", "ESCI"};
  int selected = 0;
  PFont titolo;

  Title() {
    titolo = createFont("SPACE.ttf", 40);
    sfondo = loadImage("sfondoTest.jpg");
  }

  void mostra() {
    image(sfondo, 0, 0);
    textFont(titolo);
    
    if (selected == 0) {
      fill(255, 255, 0);
      text(options[0], width/2 +20, height/2 - 50);
      fill(0);
      text(options[1], width/2 +20, height/2 + 10);
    }
    else if (selected == 1){
      fill(0);
      text(options[0], width/2 +20, height/2 - 50);
      fill(255, 255, 0);
      text(options[1], width/2 +20, height/2 + 10);
    }
    
    fill(255);
  }
  
  void changeOption(){
    if (selected == 0)
      selected = 1;
    else if (selected == 1)
      selected = 0;
  }
  
  String getSelected(){
    return options[selected];
  }
}
