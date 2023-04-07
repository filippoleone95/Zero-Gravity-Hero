class Vite {
  int quantita = 1, maxQuantita = 5;
  PImage sprite; 
  boolean inGioco;
  
  Vite(){
    inGioco = true;
    sprite = loadImage("assets/astronave.png");
    sprite.resize(0, 20);
  }
  
  void inc(int vite){
    this.quantita += vite;
    if (this.quantita > this.maxQuantita)
      this.quantita = this.maxQuantita;
  }
  
  void dec(int vite){
    this.quantita -= vite;
    if(this.quantita <=0)
      this.inGioco = false;
  }
  
  void mostra(){
    for (int i = 0; i < quantita; i++)
      image(sprite, width - (sprite.width * (i+1)) - 5, height - sprite.height - 3);    
  }
  
  void setQuantita(int vite){
    this.quantita = vite;
  }
  
   int getQuantita(){
    return quantita;
  }
  
  void setInGioco(boolean inGioco){
    this.inGioco = inGioco;
  }
  
   boolean isInGioco(){
    return this.inGioco;
  }
}
