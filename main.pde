import gifAnimation.*;
import java.util.prefs.*;
import processing.sound.*;

// Oggetto che gestisce la creazione e visualizzazione del background
PImage backImg;

int score = 0;
int scoreRaggiunto = 0;
int maxScore = 0;

PImage proiettile;

final int starsR=2000;

// Velocità asteroide da passare alla funzione per disegnare l'asteroide
float velocitaMeteorite = 5;

// Velocità asteroide da passare alla funzione per disegnare l'asteroide
float velocitaAsteroide = 4;

boolean powerUpProiettili = false;
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
Asteroide asteroide;
PowerUp powerUp;
SuoniAndFX suoniAndFX;

Meteorite[] meteoriti;
int maxMeteoriti = 1;

int frameWidth = 0;
int frameHeight = 0;

int caricatoreProiettili;
boolean powerUpVisibile;


SoundFile songIntro;

// Definisco un oggetto che contiene i dati che voglio rendere persistenti
Preferences prefs = Preferences.userRoot().node("ZeroGravityHero");

void setup() {
  // Dimensione finestra gioco
  size(800, 600);
  frameWidth = width;
  frameHeight = height;

  //Imposto il nome della finestra di gioco
  surface.setTitle("Zero gravity hero");

  gameState = -1;

  defaultFont = createFont("Arial", 20);

  titolo = new Title(this);
  vite = new Vite();
  meteoriti = new Meteorite[10];
  gameOver = new GameOver();
  navicella = new Navicella(this);
  asteroide = new Asteroide(this);
  powerUp = new PowerUp();
  suoniAndFX = new SuoniAndFX(this);

  for (int i = 0; i < meteoriti.length; i++) {
    meteoriti[i] = new Meteorite(this, velocitaMeteorite);
  }

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

  suoniAndFX.playSongMenu();
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

    if (score != 0 && score % 30 == 0 && countFrame == 30) {
      vite.inc(1);  //TODO da gestire per bene il punteggio perché il valore preciso potrebbe essere saltato a causa di oggetti che danno più punti (es. meteorite)
    }

    if (score > maxScore) {
      maxScore = score;
      // Salvo il record in maniera persistente
      prefs.putInt("maxScore", score);
    }


    if ( (powerUp.getPowerUpX() + (powerUp.getPowerUpWidth() / 2)) > navicella.naveX && (powerUp.getPowerUpY() + powerUp.getPowerUpHeight()) > navicella.naveY ) {
      powerUpProiettili = true;
      caricatoreProiettili = 50;
      powerUpVisibile = true;
    }

    if (powerUpProiettili == true && caricatoreProiettili > 0)
    {
      caricatoreProiettili--;
      navicella.spara();
    }

    // se restituisce true, l'asteroide va da destra verso sinistra
    boolean flip = asteroide.disegnaAsteroide(velocitaAsteroide);

    // Controlla se la navicella è colpita dall'asteroide
    if (flip) {
      if (dist(navicella.naveX + navicella.getWidthNav()/2, navicella.naveY + navicella.getHeightNav()/2, asteroide.getX() + asteroide.getWidth()/3, asteroide.getY() + 2*asteroide.getHeight()/3)
        < navicella.getWidthNav()/3 + asteroide.getWidth()/3) {
        gameState = 1;
        suoniAndFX.stopSongGame();
        suoniAndFX.asteroidCollision();
      }
    } else {
      if
        (dist(navicella.naveX + navicella.getWidthNav()/2, navicella.naveY + navicella.getHeightNav()/2, asteroide.getX() - asteroide.getWidth()/3, asteroide.getY() + 2*asteroide.getHeight()/3)
        < navicella.getWidthNav()/3 + asteroide.getWidth()/3) {
        gameState = 1;
        suoniAndFX.stopSongGame();
        suoniAndFX.asteroidCollision();
      }
    }

    // Disegno gli ostacoli
    disegnaMeteoriti();

    //stroke(0, 255, 0);
    //strokeWeight(10);
    //point((navicella.naveX + navicella.getWidthNav()/2), (navicella.naveY + navicella.getHeightNav()/2));

    mostraPunteggio();
    vite.mostra();
    mostraRecord();

    if (++countFrame == 60) {
      countFrame = 0;
      score++;
    }

    powerUp.disegnaPowerUp(frameWidth, frameHeight);
  }
  // Il giocatore ha perso, mostro GameOver
  else if (gameState == 1) {

    //for (int i = 0; i < maxMeteoriti && i < meteoriti.length; i++)
    //meteoriti[i].disegna();

    //image(asteroide.getPimage(), asteroide.getX(), asteroide.getY());
    //image(proiettile, proiettileX, proiettileY);
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

void disegnaMeteoriti() {

  for (int i = 0; i < maxMeteoriti && i< meteoriti.length; i++) {
    if (!meteoriti[i].isVisibile())
      meteoriti[i] = new Meteorite(this, velocitaMeteorite);

    meteoriti[i].disegnaMovimento();
  }

  for (int i = 0; i <maxMeteoriti && i< meteoriti.length; i++) {

    if (!meteoriti[i].isColpito() && powerUpProiettili && voloProiettile && dist(proiettileX, proiettileY, meteoriti[i].x, meteoriti[i].y) < proiettile.width + meteoriti[i].sprite.width/2) {
      suoniAndFX.meteoriteExplosion();
      meteoriti[i].colpisci();
      voloProiettile = false;
      score += 2;
    }

    // Controlla se la navicella è colpita dalla meteorite
    if (!meteoriti[i].isColpito() && dist(navicella.naveX + navicella.getWidthNav()/2, navicella.naveY + navicella.getHeightNav()/2, meteoriti[i].x, meteoriti[i].y) < navicella.getWidthNav()/2 + meteoriti[i].sprite.width/2) {
      vite.dec(1);
      
      //funzione da richiamare quando si muore perché stoppa la musica
      suoniAndFX.meteoriteCollision();
      
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
      suoniAndFX.stopSongMenu();
      suoniAndFX.playSongGame();
    } else if (titolo.getSelected().equals("ESCI") && key == ' ')
      exit();
    else if (keyCode == UP || keyCode == DOWN)
      titolo.changeOption();
  } else if (gameState == 1 && key == ' ') {
    ricomincia();
    suoniAndFX.playSongGame();
  }
  
  // GESTIONE SUONI
  if (key == ',') {
    suoniAndFX.decrementVolume();
  } else if (key == '.') {
    suoniAndFX.incrementVolume();
  } else if (key == 'm' && suoniAndFX.muted == false) {
    suoniAndFX.muteSounds();
    suoniAndFX.muted = true;
  } else if (key == 'm' && suoniAndFX.muted == true) {
    suoniAndFX.unmuteSounds(gameState);
    suoniAndFX.muted = false;
  }
  // GESTIONE SUONI
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
  asteroide.setCadutaAsteroide(false);
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
