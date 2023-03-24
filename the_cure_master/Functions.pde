
void mousePressed() {

  if (gameState == PHASE_1 || gameState == PHASE_2) {
    if (bubbles.size() < 750) {

      numBubs++;
      bubbles.add(new Bubble());
    }
  }

  if (gameState == INTERIM) {

    development = false;
    gameState = PHASE_2;
    timeNow = millis();
  }
  if (gameState == INTERIM_2) {
    gameState = END;
  }
}

void mouseDragged() {

  if (gameState == PHASE_1 || gameState == PHASE_2) {
    if (bubbles.size() < 750) {
      numBubs++;
      bubbles.add(new Bubble());
    }
  }
}

//Bubble Interactions
void bubInteractions() {

  //bubble interactions
  for (Bubble tempBub : bubbles) {

    PVector acceleration = new PVector(0, 0);
    for (Bubble otherBub : bubbles) {
      if (tempBub != otherBub) {
        PVector xY = new PVector();
        xY.x = otherBub.position.x - tempBub.position.x;
        xY.y = otherBub.position.y - tempBub.position.y;
        float distance = sqrt(xY.x* xY.x + xY.y * xY.y);

        if (distance < 1) {
          distance = 1;
        }
        float force = (distance - 300)* (otherBub.mass/distance);
        acceleration.x += force * xY.x;
        acceleration.y += force * xY.y;
      }

      //Mouse Interactions
      PVector xY2 = new PVector();

      xY2.x = mouseX - tempBub.position.x;
      xY2.y = mouseY - tempBub.position.y;

      float distance = sqrt(xY2.x*xY2.x + xY2.y * xY2.y);

      if (distance < 20) {
        distance = 20;
      }
      
      if (distance > 30) {
        distance = 30;
      }

      float force = (distance-30)/(3*distance);
      acceleration.x += force * xY2.x;
      acceleration.x += force * xY2.y;
    }

    tempBub.velocity.x = tempBub.velocity.x * visc + acceleration.x * tempBub.mass;
    tempBub.velocity.y = tempBub.velocity.y * visc + acceleration.y * tempBub.mass;
  }
}

void drawTitle() {

  fill(255, 255, 255, 67);
  textSize(20);
  text("t h e", width/2 + 200, height/2 - 135);

  fill(255, 255, 255, 67);
  textSize(50);
  text("c u r e", width/2 + 160, height/2 - 105);

  fill(255, 255, 255, 127);
  textSize(50);
  text("c u r e", width/2 + 155, height/2 - 100);

  fill(255, 255, 255, 225);
  textSize(50);
  text("c u r e", width/2 + 150, height/2 - 95);
}

void spawn(FFT thisFFT) {
  testing = false;
  oCounter = 1;
  fft = thisFFT;
  int time = (65 - millis()/1000);
  for (int i = 0; i < fft.specSize(); i++) {
    //convert the magnitude to a DB value
    float bandDB = 20 * log(2 * fft.getBand(i) / fft.timeSize() ); //DB value is 0 for loudest band to some negative value

    if (gameState == PHASE_2) {
      if ( bandDB > -250 && bandDB < -150) {
        if (limit < 7 && time < 55) {
          limit++;
          crosshairs.add(new Crosshair());
        }
      }
    }
  }
}

void drawHub() {

  if (gameState == PHASE_1) {

    fill(255);
    textSize(25);
    text("CURE DEVELOPMENT: " + getDurability() + "%", RIGHT, 50 );

    fill(255, 255, 255, 127);
    textSize(25);

    text("Click and drag to create the anti-virus' molecular structure", RIGHT, 80);
  }

  if (gameState == INTERIM) {

    fill(255);
    textSize(25);
    text("CURE DEVELOPMENT: " + getDurability() + "%", RIGHT, 50 );

    fill(255, 255, 255, 127);
    textSize(25);

    text("Proceeding to the DURABILITY TEST...", RIGHT, 80);

    fill(255, 255, 255, 127);
    text("Click anywhere to begin", RIGHT, 110);
  }

  if (gameState == PHASE_2) {
    if (testing == true) {
      spawn(fft);
    }
    fill(255);
    if (numBubs < 525) { 
      fill(255, 0, 0);
    }

    textSize(25);
    text("DURABILITY: " + getDurability() + "%", RIGHT, 50 );
    fill(255);
    
    if (time > 0){
      time = duration - ((millis() - timeNow)/1000);
    }
    text("TIME REMAINING: " + time + " s", RIGHT, height - 50);

    if (time == 0) {
      timeNow = 6000;
      gameState = INTERIM_2;
      oCounter = -1;
    }

    fill(255, 255, 255, 127);
    textSize(25);
    text("Cross hairs will destroy the anti-virus and reduce its durability.", RIGHT, 80);

    fill(255);
    text("Durability MUST be above 70% by the end of the test.", RIGHT, 110);

    textSize(22);
    fill(255, 255, 255, 127);
    text("...Our survival depends on it, Dr. " + userName+ ".", RIGHT + 250, height - 50);
  }
  if(gameState == INTERIM_2){
    crosshairs.clear();
    testing = false;
    fill(255);
    textSize(25);
    text("FINAL DURABILITY: " + getDurability() + "%", RIGHT, 50 );

    fill(255, 255, 255, 127);
    textSize(25);

    text("Final results have been generated.", RIGHT, 80);

    fill(255, 255, 255, 127);
    text("Click anywhere to proceed", RIGHT, 110);
  }
}

void drawReport() {

  background(0);
  testing = false;
  drawTitle();
  textSize(25);

  if (getDurability() > 70) {

    fill(255);
    text("You've done it, Dr. " + userName, RIGHT, 110);

    text("We may come out of this alive yet.", RIGHT, 130); 
  } else if (getDurability() < 70) {

    fill(255);

    text("You've  failed Dr. " + userName, RIGHT, 110);

    text("There are no resources available to recreate the cure.", RIGHT, 130);

    text("...we are lost.", RIGHT, 175);
    text("We will die like dogs...", RIGHT, 200);
  }
}

int getDurability(){
  return round((numBubs/efficiency) * 100); 
}
