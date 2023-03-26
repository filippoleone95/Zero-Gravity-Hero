import java.util.Arrays;
import java.util.List;

class Meteorite {

  PImage sprite;
  PImage[] sprites;
  float x, y, velocita, angolo;
  boolean colpito = false;
  int i = 0;
  int counter = 0;
  List<Integer> frameEsplosione = Arrays.asList(9, 19, 29, 39, 49, 59);  //Lista e non array per poter sfruttare il metodo contains()
  boolean visibile;
  
  Meteorite(PApplet parent, float velocitaMax){
    
    this.sprite = loadImage("assets/MeteoriteIntero.png");
    this.sprites = Gif.getPImages(parent, "assets/MeteoriteDistrutto.gif");
    int size = floor(random(50, 100));
    
    sprite.resize(0, size);
    for (PImage sprite : sprites)
      sprite.resize(0, (int)(size * 2.53));  // rapporto di grandezza tra sprite e sprites
    
    this.y = -sprite.height/2;
    this.x = random(sprite.width, width - sprite.width);
    
    visibile = true;
    
    if (this.x < width/2)
      this.angolo = random(0, PI/6);
      
    else
      this.angolo = random(-PI/6, 0) ;
      
    
    this.velocita = random(2, velocitaMax);
    
  }
  
  void disegnaMovimento(){
    
    if(!colpito){
      
      x+= velocita*sin(angolo);
      y+= velocita*cos(angolo);
      
      disegna();
            
      // se l'immagine esce dallo schermo in basso || a sinistra || a destra
      if (y > height + sprite.height/2 || x < 0 - sprite.width/2 || x > width + sprite.width/2) 
        visibile = false;    
    }
    else {
      
      if (i >= sprites.length){
        visibile = false;
        return;
      }
        
      if ( frameEsplosione.contains(counter++) )
        sprite = sprites[i++]; 
      
      disegna();      
    }
  }
  
  void disegna(){
    
    imageMode(CENTER);
    image(sprite, x, y);
    imageMode(CORNER);
  }
  
  void colpisci(){
    colpito = true;
  }
  
  boolean isColpito(){
    return colpito;
  }
  
  void setVisibile(boolean visibile){
    this.visibile = visibile;
  }
  
  boolean isVisibile(){
    return visibile;
  }
}
