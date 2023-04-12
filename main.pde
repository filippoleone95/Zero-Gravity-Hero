import gifAnimation.*; //<>//
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
SuoniAndFX suoniAndFX;
Proiettile proiettile;

Meteorite[] meteoriti;
int maxMeteoriti = 1;


int caricatoreProiettili;
boolean powerUpVisibile;

SoundFile songIntro;

int elapsedSeconds = 0;

boolean isInvincibile = false;
int startInvincibile = 0;

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

  suoniAndFX = new SuoniAndFX(this);

  for (int i = 0; i < meteoriti.length && i < maxMeteoriti; i++) {
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

    if (elapsedSeconds != 0 && elapsedSeconds % 60 == 0)
      powerUp = new PowerUp();


    if (powerUp != null && powerUp.isVisibile())
      powerUp.disegna();

    // Disegno la navicella
    navicella.disegnaNavicella();

    if (proiettile.isAttivo())
      navicella.spara();

    if (elapsedSeconds != 0 && elapsedSeconds % 50 == 0 && countFrame == 30) {
      vite.inc(1);  //TODO da gestire per bene il punteggio perché il valore preciso potrebbe essere saltato a causa di oggetti che danno più punti (es. meteorite)
    }

    if (score > maxScore) {
      maxScore = score;
      // Salvo il record in maniera persistente
      prefs.putInt("maxScore", score);
    }

    if (powerUp != null && powerUp.isVisibile() && dist(powerUp.x + powerUp.sprite.width/2, powerUp.y + powerUp.sprite.height/2, navicella.getX() + navicella.sprite.width/2, navicella.getY() + navicella.sprite.height/2)
      < powerUp.sprite.width/2 + navicella.sprite.width/2) {
      powerUp.performaPowerUp();
      suoniAndFX.playPowerUp();
      powerUp.setVisibile(false);
    }

    //TODO BISOGNA RICREARE OGNI TOT TEMPO UN NUOVO OGGETTO ASTEROIDE ASTEROIDE


    if (elapsedSeconds != 0 && elapsedSeconds % 30 == 0 && countFrame == 30) {
      incrementaDifficolta();
    }

    if (score != 0 && score % 15 == 0 && countFrame == 30) {
      asteroide = new Asteroide(this, velocitaAsteroide);
      asteroide.disegna();

      if (velocitaAsteroide < 9)
        velocitaAsteroide += 0.5;
    } else if (asteroide != null && asteroide.isVisibile()) {
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
      elapsedSeconds++;
    }
  }
  // Il giocatore ha perso, mostro GameOver
  else if (gameState == 1) {

    for (int i = 0; i < maxMeteoriti && i < meteoriti.length; i++)
      meteoriti[i].disegnaStatico();

    if (asteroide != null && asteroide.isVisibile())
      asteroide.disegnaStatico();

    if (proiettile.isInVolo())
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
    if (meteoriti[i] == null || !meteoriti[i].isVisibile())
      meteoriti[i] = new Meteorite(this, maxVelocitaMeteorite);

    meteoriti[i].disegna();
  }

  for (int i = 0; i <maxMeteoriti && i< meteoriti.length; i++) {

    if (!meteoriti[i].isColpito() && proiettile.isAttivo() && proiettile.isInVolo() && dist(proiettile.getX(), proiettile.getY(), meteoriti[i].x, meteoriti[i].y) < proiettile.sprite.width + meteoriti[i].sprite.width/2) {
      suoniAndFX.meteoriteExplosion();
      meteoriti[i].colpisci();
      proiettile.setInVolo(false);
      score += 2;
    }

    // Controlla se la navicella è colpita dalla meteorite
    if (!isInvincibile && !meteoriti[i].isColpito() && dist(navicella.getX() + navicella.getSprite().width/2, navicella.getY() + navicella.getSprite().width/2, meteoriti[i].x, meteoriti[i].y)
      < navicella.getSprite().width/2 + meteoriti[i].sprite.width/2) {
      vite.dec(1);
      isInvincibile = true;
      startInvincibile = millis();

      navicella.isColpita = 1;
      //funzione da richiamare quando si muore perché stoppa la musica
      suoniAndFX.meteoriteCollision();
      if (!vite.isInGioco()) {

        gameState = 1;
        suoniAndFX.stopSongGame();
        isInvincibile = false;
      }
    }


    if (millis() - startInvincibile > 3000 && startInvincibile != 0) {
      isInvincibile = false;
      startInvincibile = 0;
    }
  }
}

void keyPressed() {
  if (gameState == -1) {
    if (titolo.getSelected().equals("GIOCA") && key == ' ') {
      gameState = 0;
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
  } else if (key == 'm' && suoniAndFX.muted == true) {
    suoniAndFX.unmuteSounds(gameState);
  }
  // GESTIONE SUONI
}

// Da togliere
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
  elapsedSeconds = 0;
  countFrame = 0;
  navicella.isColpita = 0;
  startInvincibile = 0;
  suoniAndFX.playSongGame();
  vite.inGioco = true;
  maxVelocitaMeteorite = 5;
  velocitaAsteroide = 4;

  if (powerUp != null) {
    powerUp.setVisibile(false);
    powerUp = null;
  }
  proiettile.resetCaricatore();
  navicella.counterPowerUpVelocita = 0;

  for (int i = 0; i <maxMeteoriti && i < meteoriti.length; i++) {
    meteoriti[i].setVisibile(false);
  }
  if (asteroide != null && asteroide.isVisibile())
    asteroide.setVisibile(false);

  navicella.x = width/2 - navicella.sprite.width/2;
  navicella.y = height - navicella.sprite.height - 50;
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
  maxMeteoriti++;
  if (maxVelocitaMeteorite < 8)
    maxVelocitaMeteorite += 0.3;
}

void verificaCollisioneAsteroide() {

  if (!isInvincibile) {
    if (asteroide.getDirezione() == SINISTRA) {

      if (dist(navicella.getX() + navicella.getSprite().width/2, navicella.getY() + navicella.getSprite().height/2, asteroide.getX() + asteroide.getSprite().width/4, asteroide.getY() + 3*asteroide.getSprite().height/4)
        < navicella.getSprite().width/3 + asteroide.getSprite().width/4) {
        vite.dec(2);
        isInvincibile = true;
        startInvincibile = millis();
        suoniAndFX.asteroidCollision();
        navicella.isColpita = 1;
        if (!vite.isInGioco()) {
          //realizzare classe Astronave per far sì che si possa rendere invincibile per pochi secondi
          gameState = 1;
          suoniAndFX.stopSongGame();
          isInvincibile = false;
        }
      }
    } else {
      if (dist(navicella.getX() + navicella.getSprite().width/2, navicella.getY() + navicella.getSprite().height/2, asteroide.getX() + 3*asteroide.getSprite().width/4, asteroide.getY() + 3*asteroide.getSprite().height/4)
        < navicella.getSprite().width/3 + asteroide.getSprite().width/4) {
        vite.dec(2);
        isInvincibile = true;
        startInvincibile = millis();
        suoniAndFX.asteroidCollision();
        navicella.isColpita = 1;
        if (!vite.isInGioco()) {
          //realizzare classe Astronave per far sì che si possa rendere invincibile per pochi secondi
          gameState = 1;
          suoniAndFX.stopSongGame();
          isInvincibile = false;
        }
      }
    }
  }
}
