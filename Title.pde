class Title {
  PImage sfondo;
  String[] options= {"GIOCA", "ESCI"};
  int selected = 0;
  PFont titolo;
  String suggerimenti= "Freccia su/giu: modifica opzione\nBarra spaziatrice: conferma";
  PImage nave, asteroidi[];
  int frame = 0, img = 0;

  Title(PApplet parent) {
    titolo = createFont("SPACE.ttf", 40);
    sfondo = loadImage("alex.png");
    nave = loadImage("assets/astronave.png");
    nave.resize(0, 40);
    asteroidi = Gif.getPImages(parent, "assets/ast.gif");
    for (PImage asteroide : asteroidi)
      asteroide.resize(100,0);
  }

  void mostra() {
    skyScrolling();
    image(sfondo, 0, 0);
    textFont(titolo);
    
    
    if (selected == 0) {
      fill(255, 255, 0);
      //textSize(45);
      textSize(40);
      float x = textWidth(options[0]);
      text(options[0], width/2 +20, height/2 - 50);
      image(nave,width/2 +30 + x , height/2 - 45 - nave.height);
      fill(255);
      
      text(options[1], width/2 +20, height/2 + 10);
    }
    else if (selected == 1){
      fill(255);
      textSize(40);
      text(options[0], width/2 +20, height/2 - 50);
      fill(255, 255, 0);
      //textSize(45);
      float x =textWidth(options[1]);
      text(options[1], width/2 +20, height/2 + 10);
      image(nave,width/2 + 30 + x, height/2 + 15 - nave.height);
    }
    
    disegnaAsteroide();
    
    textFont(defaultFont);
    fill(255);
    textSize(15);
    text(suggerimenti, width/2 + 20, height - 50);
    
    
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
  
  void disegnaAsteroide(){
    image(asteroidi[img], width - asteroidi[img].width - 100, 50);
    if (++frame % 10 == 0)
      img++;
      
    if (img == asteroidi.length)
      img = 0;
      
    if (frame == 60)
      frame = 0;
  }
}
