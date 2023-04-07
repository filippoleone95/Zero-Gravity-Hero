import gifAnimation.*;
import java.util.prefs.*;
import processing.sound.*;

// Oggetto che gestisce la creazione e visualizzazione del background
PImage backImg;

int score = 0;
int scoreRaggiunto = 0;
int maxScore = 0;

final int starsR=2000;

// Velocità da passare nella creazione del meteorite
float maxVelocitaMeteorite = 5;

// Velocità asteroide da passare alla funzione per disegnare l'asteroide
float velocitaAsteroide = 4;

final boolean DESTRA = true;
final boolean SINISTRA = false;

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
Proiettile proiettile;

Meteorite[] meteoriti;
int maxMeteoriti = 1;


int caricatoreProiettili;
boolean powerUpVisibile;


SoundFile songIntro;

// Definisco un oggetto che contiene i dati che voglio rendere persistenti
Preferences prefs = Preferences.userRoot().node("ZeroGravityHero");

void setup() {
  // Dimensione finestra gioco
  size(800, 600);

  //Imposto il nome della finestra di gioco
  surface.setTitle("Zero gravity hero");

  gameState = -1;

  defaultFont = createFont("Arial", 20);

  titolo = new Title(this);
  vite = new Vite();
  meteoriti = new Meteorite[10];
  gameOver = new GameOver();
  navicella = new Navicella(this);
  proiettile = navicella.getProiettile();

  powerUp = new PowerUp();

  songIntro = new SoundFile(this, "gameSong.mp3");
  songIntro.play();

  for (int i = 0; i < meteoriti.length; i++) {
    meteoriti[i] = new Meteorite(this, maxVelocitaMeteorite);
  }

  // Creo il background
  backImg = createImage(800, 600, RGB);

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

    powerUp.disegna();

    // Disegno la navicella
    navicella.disegnaNavicella();

    if (score != 0 && score % 100 == 0 && countFrame == 30) {
      vite.inc(1);  //TODO da gestire per bene il punteggio perché il valore preciso potrebbe essere saltato a causa di oggetti che danno più punti (es. meteorite)
    }

    if (score > maxScore) {
      maxScore = score;
      // Salvo il record in maniera persistente
      prefs.putInt("maxScore", score);
    }


    //if ( (powerUp.getPowerUpX() + (powerUp.getPowerUpWidth() / 2)) > navicella.getX() && (powerUp.getPowerUpY() + powerUp.getPowerUpHeight()) > navicella.getY() ) {
    //  powerUpProiettili = true;
    //  caricatoreProiettili = 50;
    //  powerUpVisibile = true;
    //}

    //if (powerUpProiettili == true && caricatoreProiettili > 0)
    //{
    //  caricatoreProiettili--;
    //  navicella.spara();
    //}

    //TODO BISOGNA RICREARE OGNI TOT TEMPO UN NUOVO OGGETTO ASTEROIDE ASTEROIDE

    if (score != 0 && score % 15 == 0 && countFrame == 30){
      asteroide = new Asteroide(this, velocitaAsteroide);
      asteroide.disegna();
      
      if (velocitaAsteroide < 9)
        velocitaAsteroide += 0.5;
    }
    
    else if (asteroide != null && asteroide.isVisibile()){
      asteroide.disegna();
      // Controlla se la navicella è colpita dall'asteroide
      verificaCollisioneAsteroide();
  }
    disegnaMeteoriti();

    mostraPunteggio();
    vite.mostra();
    mostraRecord();

    if (++countFrame == 60) {
      countFrame = 0;
      score++;
    }
  }
  // Il giocatore ha perso, mostro GameOver
  else if (gameState == 1) {

    for (int i = 0; i < maxMeteoriti && i < meteoriti.length; i++)
      meteoriti[i].disegnaStatico();
      
    if (asteroide != null && asteroide.isVisibile())
      asteroide.disegnaStatico();

    proiettile.disegna();

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
      meteoriti[i] = new Meteorite(this, maxVelocitaMeteorite);

    meteoriti[i].disegna();
  }

  for (int i = 0; i <maxMeteoriti && i< meteoriti.length; i++) {

    if (!meteoriti[i].isColpito() && proiettile.isAttivo() && proiettile.isInVolo() && dist(proiettile.getX(), proiettile.getY(), meteoriti[i].x, meteoriti[i].y) < proiettile.sprite.width + meteoriti[i].sprite.width/2) {
      meteoriti[i].colpisci();
      proiettile.setInVolo(false);
      score += 2;
    }

    // Controlla se la navicella è colpita dalla meteorite
    if (!meteoriti[i].isColpito() && dist(navicella.getX() + navicella.getSprite().width/2, navicella.getY() + navicella.getSprite().width/2, meteoriti[i].x, meteoriti[i].y)
      < navicella.getSprite().width/2 + meteoriti[i].sprite.width/2) {
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
      songIntro.stop();
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
  vite.setQuantita(1);

  for (int i = 0; i <maxMeteoriti && i < meteoriti.length; i++) {
    meteoriti[i].setVisibile(false);
  }
  if(asteroide != null && asteroide.isVisibile())
    asteroide.setVisibile(false);
    
  proiettile.setInVolo(false);
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
  maxVelocitaMeteorite++;
}

void verificaCollisioneAsteroide() {

  if (asteroide.getDirezione() == SINISTRA) {
    if (dist(navicella.getX() + navicella.getSprite().width/2, navicella.getY() + navicella.getSprite().height/2, asteroide.getX() + asteroide.getSprite().width/4, asteroide.getY() + 3*asteroide.getSprite().height/4)
      < navicella.getSprite().width/3 + asteroide.getSprite().width/4)
      gameState = 1;
  } else {
    if (dist(navicella.getX() + navicella.getSprite().width/2, navicella.getY() + navicella.getSprite().height/2, asteroide.getX() + 3*asteroide.getSprite().width/4, asteroide.getY() + 3*asteroide.getSprite().height/4)
      < navicella.getSprite().width/3 + asteroide.getSprite().width/4)
      gameState = 1;
  }
}
