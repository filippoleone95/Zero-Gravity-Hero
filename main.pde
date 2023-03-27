import gifAnimation.*;
import java.util.prefs.*;

// Dichiaro Sprites
PImage backImg;

PImage asteroide;
PImage[] asteroidi;

int score = 0;
int scoreRaggiunto = 0;
int maxScore = 0;

PImage proiettile;

final int starsR=2000;

float asteroideX;
float asteroideY;

float velocitaMeteorite = 2;
float velocitaAsteroide = 2;

boolean cadutaAsteroide = false;

boolean powerUpProiettili = true;
boolean voloProiettile = false;
float proiettileX;
float proiettileY;
float velocitaProiettile = 10;

int bonusVite = 0;

int i;
//int j;

PFont defaultFont;
// Contatore del frame attuale
int countFrame;

//variabile dello stato di gioco
int gameState;

// Dichiaro schermata per il gameover
GameOver gameOver;
Title titolo;
Vite vite;
Navicella navicella;

Meteorite[] meteoriti;
int maxMeteoriti = 1;

// Renderizzo un nuovo frame dell'asteroide ogni 10 fps del gioco
int[] framesAsteroide = {4, 9, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59};

// Definisco un oggetto che contiene i dati che voglio rendere persistenti
Preferences prefs = Preferences.userRoot().node(this.getClass().getName());

void setup() {
  // Dimensione finestra gioco
  size(800, 600);


  gameState = -1;

  defaultFont = createFont("Arial", 20);

  titolo = new Title(this);
  vite = new Vite();
  meteoriti = new Meteorite[10];
  gameOver = new GameOver();
  navicella = new Navicella(this, "assets/nav.gif");

  for (int i = 0; i < meteoriti.length; i++) {
    meteoriti[i] = new Meteorite(this, velocitaMeteorite);
  }

  // Carico le immagini per gli sprite
  asteroidi = Gif.getPImages(this, "assets/ast.gif");

  proiettile = loadImage("assets/proiettile.png");

  // Creo il background
  backImg = createImage(800, 600, RGB);

  i = 0;

  // Inizializzo il cielo
  initSky();

  // inizializzo il contatore
  countFrame = 0;
  
  // Leggo il punteggio record dalle preferenze
  maxScore = prefs.getInt("maxScore", 0);
}

void draw() {
  if (gameState == -1) {
    titolo.mostra();
  } else if (gameState == 0) {

    textFont(defaultFont);
    fill(255);
    // Disegno il cielo
    skyScrolling();

    // Disegno la navicella
    navicella.disegnaNavicella();

    if (score != 0 && score % 30 == 0) {
      vite.inc(1);  //TODO da gestire per bene il punteggio perché il valore preciso potrebbe essere saltato a causa di oggetti che danno più punti (es. meteorite)
      score++;  //valore incrementato dato che score aumenta ogni 60 frame e quindi avrebbe massimizzato il numero di vite invece che incrementate solo di una
    }

    if (score > maxScore) {
      maxScore = score;
      // Salvo il record in maniera persistente
      prefs.putInt("maxScore", score);
    }


    if (powerUpProiettili == true)
      navicella.spara();

    asteroide();

    // Disegno gli ostacoli
    disegnaMeteoriti();

    mostraPunteggio();
    vite.mostra();
    mostraRecord();

    if (++countFrame == 60) {
      countFrame = 0;
      score++;
    }
  } else if (gameState == 1) {
    for (int i = 0; i < maxMeteoriti && i < meteoriti.length; i++)
      meteoriti[i].disegna();

    image(asteroide, asteroideX, asteroideY);
    image(proiettile, proiettileX, proiettileY);

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



void asteroide() {
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
  if (!cadutaAsteroide) {
    asteroideX = random(width - asteroide.width);
    asteroideY = -asteroide.height;
    cadutaAsteroide = true;
  }

  // Disegna e aggiorna la posizione dell'asteroide
  asteroideY += velocitaAsteroide;
  image(asteroide, asteroideX, asteroideY);


  // Se l'asteroide arriva a terra, crea un nuovo asteroide
  if (asteroideY > height)
    cadutaAsteroide = false;


  // Controlla se la navicella è colpita dall'asteroide
  if (dist(navicella.naveX + navicella.getWidthNav()/2, navicella.naveY + navicella.getHeightNav()/2, asteroideX + asteroide.width/3, asteroideY + 2*asteroide.height/3)
    < navicella.getWidthNav()/3 + asteroide.width/3)
    gameState = 1;
}


void disegnaMeteoriti() {

  for (int i = 0; i < maxMeteoriti && i< meteoriti.length; i++) {
    if (!meteoriti[i].isVisibile())
      meteoriti[i] = new Meteorite(this, velocitaMeteorite);

    meteoriti[i].disegnaMovimento();
  }

  for (int i = 0; i <maxMeteoriti && i< meteoriti.length; i++) {

    if (!meteoriti[i].isColpito() && powerUpProiettili && voloProiettile && dist(proiettileX, proiettileY, meteoriti[i].x, meteoriti[i].y) < proiettile.width + meteoriti[i].sprite.width/2) {
      meteoriti[i].colpisci();
      voloProiettile = false;
      score += 2;
    }

    // Controlla se la navicella è colpita dalla meteorite
    if (!meteoriti[i].isColpito() && dist(navicella.naveX + navicella.getWidthNav()/2, navicella.naveY + navicella.getHeightNav()/2, meteoriti[i].x, meteoriti[i].y) < navicella.getWidthNav()/2 + meteoriti[i].sprite.width/2) {
      vite.dec(1);

      if (vite.isInGioco()) {
        //realizzare classe Astronave per far sì che si possa rendere invincibile per pochi secondi
      }

      gameState = 1;
      return;
    }
  }
}

void keyPressed() {
  if (gameState == -1) {
    if (titolo.getSelected().equals("GIOCA") && key == ' ') {
      gameState = 0;
    } else if (titolo.getSelected().equals("ESCI") && key == ' ')
      exit();
    else if (keyCode == UP || keyCode == DOWN)
      titolo.changeOption();
  } else if (gameState == 1 && key == ' ')
    ricomincia();
}

void mousePressed() {
  if ( gameState == 1 && mouseX >= gameOver.buttonX
    && mouseX <= gameOver.buttonX + gameOver.buttonWidth
    && mouseY >= gameOver.buttonY
    && mouseY <= gameOver.buttonY + gameOver.buttonHeight)

    ricomincia();
}

void ricomincia() {
  gameState = 0;
  maxMeteoriti = 1;
  score = 0;
  vite.setQuantita(bonusVite + 1);

  for (int i = 0; i <maxMeteoriti && i < meteoriti.length; i++) {
    meteoriti[i].setVisibile(false);
  }
  cadutaAsteroide = false;
  voloProiettile = false;
}

void mostraPunteggio() {
  textAlign(RIGHT);
  textSize(20);
  fill(255, 255, 255);
  text("Punteggio: " + score, width - 10, height - 30);
}

void mostraRecord() {
  textAlign(LEFT);
  textSize(20);
  fill(255, 255, 255);
  text("Record: " + maxScore, 10, height - 30);
}

void incrementaDifficolta() {
  maxMeteoriti++; // TODO da ultimare - alternare velocità e numero - capire dopo quanto tempo/punteggio innalzare la difficoltà
  velocitaMeteorite++;
}
