void userInput1() {

  if (gameState == INTRO) {
    PFont font = createFont("VT323-Regular.ttf", 32);
    PFont btnFont = createFont("VT323-Regular.ttf", 18);
    
    cp5.addTextfield("PLEASE ENTER YOUR NAME")
      .setPosition(LEFT, 300)
      .setSize(200, 40)
      .setFont(font)
      .setFocus(true)
      .setColor(color(255, 0, 0))
      ;
    
    cp5.addBang("START")
      .setPosition(LEFT, height/2 + 25)
      .setSize(80, 40)
      .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setFont(btnFont)
      ;
    cp5.hide("START");

    cp5.addBang("SUBMIT")
      .setPosition(LEFT, height/2 + 25)
      .setSize(80, 40)
      .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setFont(btnFont)
      ;

    textSize(32);
    textFont(font);
  }
}

void SUBMIT() {

  if (submission != null && submission != "") {

    userName = submission;
    submitted = true;

    gameState = INTRO_2;
  }
}

void userInput2() {

  fill(255);
  textSize(32);

  if (gameState == INTRO) {

    submission = cp5.get(Textfield.class, "PLEASE ENTER YOUR NAME").getText();
  }

  if (gameState == INTRO_2 && submitted == true) {

    text("Hello, Dr. "+ userName+".", LEFT, height/2 - 150);
    text("...Click the START button to begin.", LEFT, height/2 - 100);

    cp5.remove("SUBMIT");
    cp5.remove("PLEASE ENTER YOUR NAME");
  }
}

void input(String theText) {
  // automatically receives results from controller input
  println("a textfield event for controller 'input' : "+theText);
}

void START() {

  if (gameState == INTRO_2) {

    cp5.show("START");
    gameState = PHASE_1;
  }
}
