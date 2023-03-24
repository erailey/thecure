
abstract class Entity {

  abstract void update();
  abstract void render();
}

class Bubble extends Entity {

  PVector position;
  PVector velocity;
  float mass;
  color bubColor;
  color bubAtkColor;
  color lineColor;
  float radius;

  Bubble() {

    position = new PVector(mouseX, mouseY);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    bubColor = color(255, 255, 255, 67);
    mass = random(0.002, 0.02);
    radius = mass*1500;
  }

  void update() {
    render();
    move();
    collisionCheck();
    destroy(bubbles);
    //spawn(fft); //REMOVE
  }

  void render() {
    fill(bubColor);
    noStroke();
    ellipse(position.x, position.y, radius, radius);
  }

  void move() {
    position.x += velocity.x;
    position.y += velocity.y;
  }

  void collisionCheck() {
    if (position.x > width - radius || position.x < radius) {
      velocity.x *= -1;
    }
    if (position.y > height - radius || position.y < radius) {
      velocity.y *= -1;
    }
  }
  //empty method for child  inheritence
  void destroy(ArrayList<Bubble> targets) {
  }
}

  class Crosshair extends Bubble {
    int opacity;
    boolean dying;

    Crosshair() {

      dying = false;
      bubColor = color(0, 180, 255); //cyan
      bubAtkColor = color(255, 0, 0); //red
      lineColor = color(0, 180, 255);
      radius = 60;
      position = new PVector(random(radius, width - radius), random(radius, height - radius));
      opacity = 0;
    }

    void render() {
      if (opacity < 200) {
        fill(bubColor, opacity);
      } else if (opacity >= 200) {
        fill(bubAtkColor, opacity);
      }
      noStroke();
      ellipse(position.x, position.y, radius, radius);
      stroke(lineColor, opacity);
      line(0, position.y, width, position.y);
      line(position.x, 0, position.x, height);
      opacity += oCounter;
    }

    void destroy(ArrayList<Bubble> targets) {
      if (opacity > 350) {  //gameplay wasn't as challenging when I removed the crosshairs at max opacity
        oCounter = -1;
        dying = true;
      }
      if (opacity > 200) {
        for (int i = targets.size()-1; i > 0; i--) {
          Bubble tempBub = targets.get(i);

          PVector tempPos = tempBub.position;
          if (dist(position.x, position.y, tempPos.x, tempPos.y) < radius) {
            targets.remove(tempBub);
            numBubs--;
          }
        }
      }
      if (dying == true && opacity <= 0) {
        crosshairs.remove(this);
        limit--;
        oCounter = 1; 
      }
    }
  }
