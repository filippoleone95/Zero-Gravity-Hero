import gifAnimation.*;

// Dichiaro Sprites
PImage backImg = createImage(800, 600, RGB);
PImage navicella;
PImage meteorite;
PImage[] navicelle;
PImage asteroide;
PImage[] asteroidi;

final int starsR=600;

// Dichiaro posizione sprites
float naveX;
float naveY;
float meteoriteX;
float meteoriteY;
float asteroideX;
float asteroideY;

// Dichiaro e inizializzo le rispettive velocità
float velocitaNave = 3;
float velocitaMeteorite = 5;
float velocitaAsteroide = 5;

boolean cadutaMeteorite = false;
boolean cadutaAsteroide = false;

int i;
int j;

// Contatore del frame attuale
int countFrame;

//variabile dello stato di gioco
int gameState;

// Dichiaro schermata per il gameover
GameOver gameOver;

// Renderizzo un nuovo frame dell'asteroide ogni 10 fps del gioco
int[] framesNavicella = {29, 59};
// Renderizzo un nuovo frame dell'asteroide ogni 10 fps del gioco
int[] framesAsteroide = {9, 19, 29, 39, 49, 59};

void setup() {
  // Dimensione finestra gioco
  size(800, 600);
  gameState = 0;
  // Carico le immagini per gli sprite
  asteroidi = Gif.getPImages(this, "assets/ast.gif");
  navicelle = Gif.getPImages(this, "assets/nav.gif");
  meteorite = loadImage("assets/meteorite.png");
  meteorite.resize(0, 40);

  // Creo il background
  backImg = createImage(800, 600, RGB);

  // Variabile che permette di alternare le schermate della navicella
  i = 0;
  j = 0;

  // Inizializzo il cielo
  initSky();

  // Inizializzo l'array con il primo frame della navicella
  navicella = navicelle[j];

  // Iniziallizzo la posizione della navicella
  naveX = width/2 - navicella.width/2;
  naveY = height - navicella.height - 50;

  // Inizializzo la schermata di game over
  gameOver = new GameOver();

  // inizializzo il contatore
  countFrame = 0;
}

void draw() {
  
  if (gameState == 0) {
    // Disegno il cielo
  skyScrolling();

  // Disegno la navicella
  navicella();

  // Disegno gli ostacoli
  meteorite();

  if(++countFrame == 60) countFrame = 0;
  }
  
  else if (gameState == 1){
    image(meteorite, meteoriteX, meteoriteY);
    image(asteroide, asteroideX, asteroideY);
    
    gameOver.display();
  }
  
}



void initSky() {
  for (int y=0; y<backImg.height; y++)
    for (int x=0; x<backImg.width; x++) {
      float r=random(starsR);
      if (r<1)
        backImg.pixels[y*backImg.width+x]=color(168, 164, 50);
      else
        backImg.pixels[y*backImg.width+x]=color(0, 0, 0);
    }
}

void skyScrolling() {
  for (int y=backImg.height-2; y>=0; y--)
    for (int x=0; x<backImg.width; x++) {
      backImg.pixels[(y+1)*backImg.width+x]=backImg.pixels[y*backImg.width+x];
    }
  for (int x=0; x<backImg.width; x++) {
    float r=random(starsR);
    if (r<1)
      backImg.pixels[x]=color(168, 164, 50);
    else
      backImg.pixels[x]=color(0, 0, 0);
  }
  background(backImg);
}

void navicella() {
  navicella = navicelle[j];
  navicella.resize(0, 80);

  for (int index = 0; index < framesNavicella.length; index++) {
    if (framesNavicella[index] == countFrame) {
      if (j<navicelle.length-1) {
        j++;
      } else {
        j=0;
      }
    }
  }

  // Disegna la navicella
  image(navicella, naveX, naveY);

  // Aggiorna la posizione della navicella
  if (keyPressed && keyCode == RIGHT) {
    naveX += velocitaNave;
  } else if (keyPressed && keyCode == LEFT) {
    naveX -= velocitaNave;
  }

  // Limita la posizione della navicella all'interno della finestra
  naveX = constrain(naveX, 0, width - navicella.width);
  naveY = constrain(naveY, 0, height - navicella.height);
}

void meteorite() {

  asteroide = asteroidi[i];
  asteroide.resize(0, 60);

  for (int index = 0; index < framesAsteroide.length; index++) {
    if (framesAsteroide[index] == countFrame) {
      if (i<asteroidi.length-1) {
        i++;
      } else {
        i=0;
      }
    }
  }

  // Crea un nuovo oggetto se non è ancora caduto
  if (!cadutaMeteorite) {
    meteoriteX = random(width - meteorite.width);
    meteoriteY = -meteorite.height;
    cadutaMeteorite = true;
  }

  if (!cadutaAsteroide) {
    asteroideX = random(width - asteroide.width);
    asteroideY = -asteroide.height;
    cadutaAsteroide = true;
  }

  // Disegna e aggiorna la posizione della meteorite
  image(meteorite, meteoriteX, meteoriteY);
  meteoriteY += velocitaMeteorite;

  // Se la meteorite arriva a terra, crea una nuova meteorite
  if (meteoriteY > height) {
    cadutaMeteorite = false;
  }

  // Disegna e aggiorna la posizione dell'asteroide
  image(asteroide, asteroideX, asteroideY);
  asteroideY += velocitaAsteroide;

  // Se l'asteroide arriva a terra, crea un nuovo asteroide
  if (asteroideY > height) {
    cadutaAsteroide = false;
  }

  // Controlla se la navicella è colpita dalla meteorite
  if (dist(naveX + navicella.width/2, naveY + navicella.height/2, meteoriteX + meteorite.width/2, meteoriteY + meteorite.height/2) < navicella.width/2 + meteorite.width/2) {
    gameState = 1;
  }

  // Controlla se la navicella è colpita dall'asteroide
  if (dist(naveX + navicella.width/2, naveY + navicella.height/2, asteroideX + asteroide.width/2, asteroideY + asteroide.height/2) < navicella.width/2 + asteroide.width/2) {
    gameState = 1;
    
  }
}

void keyPressed(){
  if (gameState == 1 && key == ' '){
    gameState = 0;
    
    cadutaMeteorite = false;
    cadutaAsteroide = false;
  }
}

void mousePressed(){
  if ( gameState == 1 && mouseX >= gameOver.buttonX
       && mouseX <= gameOver.buttonX + gameOver.buttonWidth
       && mouseY >= gameOver.buttonY
       && mouseY <= gameOver.buttonY + gameOver.buttonHeight) {
         
        gameState = 0;
        
        cadutaMeteorite = false;
        cadutaAsteroide = false;
       }
  
}
