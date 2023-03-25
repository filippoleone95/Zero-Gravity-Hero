class Vite {
  int quantita = 1, maxQuantita = 5;
  PImage sprite; 
  boolean inGioco;
  
  Vite(int bonus){
    this();
    this.quantita += bonus;
  }
  
  Vite(){
    inGioco = true;
    sprite = loadImage("assets/astronave.png");
    sprite.resize(0, 20);
  }
  
  void inc(int vite){
    quantita += vite;
    if (quantita > maxQuantita)
      quantita = maxQuantita;
  }
  
  void dec(int vite){
    quantita -= vite;
    if(quantita <=0)
      inGioco = false;
  }
  
  boolean isInGioco(){
    return inGioco;
  }
  
  int getQuantita(){
    return quantita;
  }
  
  void mostra(){
    for (int i = 0; i < quantita; i++)
      image(sprite, width - (sprite.width * (i+1)) - 5, height - sprite.height - 3);
    
  }
  
}
