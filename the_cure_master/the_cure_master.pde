//Ernes Railey
//GAME 235 Final  Project "the cure" 
//a game during which the player develops and tests the durability of an unknown anti-virus
//during PHASE_2, the crosshairs spawn at a specific frequency provided by the FFT analyzer

//Updated 3/23/23 for bug fix

import controlP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
FFT fft;
String filename;

ControlP5 cp5;
String userName, submission;
int gameState;
int timeNow;
boolean submitted;
boolean testing;

static final int TITLE = 0;
static final int INTRO = 1;
static final int INTRO_2 = 2;
static final int PHASE_1 = 3;
static final int INTERIM = 4;
static final int PHASE_2 = 5;
static final int INTERIM_2 = 6;
static final int END = 7;

ArrayList<Bubble> bubbles;
ArrayList<Crosshair> crosshairs;
float visc;
float efficiency = 750;
float numBubs;
int limit; 
boolean development;
int oCounter;
int durability;
int duration;
int time = duration = 60;

void setup(){
  size(800, 800);
  background(25);
  
  cp5 = new ControlP5(this);
  minim = new Minim(this);
  bubbles = new ArrayList<Bubble>();
  crosshairs = new ArrayList<Crosshair>();
  filename = "Purple Planet Music - Creepy - Creepy Hollow.mp3";
  player = minim.loadFile(filename, 1024);
  durability = round(numBubs/efficiency) * 100;
  
  if(player == null){
    
    println("audio not  found; exiting"); 
    exit(); 
   }
 
  player.loop();
  
  fft = new FFT(player.bufferSize(), player.sampleRate());
  
  development = true;
  userName = "";
  numBubs = 0;
  submitted = false;
  testing = true;
  
  gameState = INTRO;
  
  visc = 0.8;
  limit = 0;
  oCounter = 1;
  
  drawTitle();
  userInput1();
}

void draw(){
  
  background(25);
  fft.forward(player.mix);
  
  if (gameState == INTRO){
    
    drawTitle();
}
   userInput2();
  
  if (gameState == PHASE_1 || gameState == INTERIM || gameState == PHASE_2){
  
    cp5.remove("START");
    bubInteractions();
    
    for (int i = bubbles.size()-1; i > 0; i--){
    
    bubbles.get(i).update();
  }
    drawHub(); 
  } else if(gameState == INTERIM_2){
    drawHub();
  }
  
  for(int i = crosshairs.size()-1; i > 0; i--){
    
    crosshairs.get(i).update();
  }
  
  if(bubbles.size() == 750 && development == true){
   
    gameState = INTERIM;
  }
  
  if (gameState == END){
   
    drawReport();  
  }
}
