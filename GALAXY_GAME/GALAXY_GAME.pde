/////////////////////////////////
//Ethan Zohar                  //
//May 24                       //
//Galaxy Game                  //
/////////////////////////////////

//this is the total amount of asteroids that I have.
int totalBalls = 100;

// ship variables
int shipW = 50;
int shipH = 70;
int shipX = 400;                             
int shipY = 600-shipH;
int shipSpeed = 5;

// ball variables                            
int ballSpeed = 5;

// add the three arrays for balls here
int[] ballD = new int [totalBalls];
int[] ballX = new int [totalBalls];
int[] ballY = new int [totalBalls];
boolean[] ballVisible = new boolean [totalBalls];

// bullet variables
int bulletW = 48;                             
int bulletH = 64;                             
int bulletSpeed = 15;
int currentBullet = 0; 
boolean triggerReleased = true;

//add the three arrays for bullets here
int[] bulletX = new int [totalBalls];
int[] bulletY = new int [totalBalls];
boolean[] bulletVisible = new boolean [totalBalls];                   

// distance between the current bullet and ball
int dist;  
int dist2;

// an array that holds the key input (LEFT and RIGHT arrow + SPACE)
boolean[] keys; 

//pictures
PImage ship;
PImage[] asteroid = new PImage [totalBalls];
PImage laser;
PImage galaxy1;
PImage galaxy2;
PImage heart;
PImage heart2;
PImage hazard;

//the vartiables for the moving background
int bgdSpeed = 2;
int img1Y = 0;
int img2Y = -600;

//the variables for the lives
int heartSize = 40;
int lives = 3;

//the score
int score = 0;

//font
PFont font;

//variables for the timer on the start screen
int timer = 5;
int timerDelay = 100;

//Booleans
boolean speedBoost = false;
boolean gameStart = false;

//the variables for the explosing gif.
int numFrames = 16;
PImage[] images = new PImage[numFrames];
int currentFrame = 1;
int posX;
int posY;
boolean explosionOn = false;

//The variables for the overheating function
float heat = 0;
boolean overHeated = false;


//////////////////////////////////////////////////
// FUNCTIONS                                   //
////////////////////////////////////////////////

void generateBalls() {
  for (int i = 0; i < ballX.length; i++) {
    ballD[i] = int(random(50, 101));
    ballX[i] = int(random(width));
    ballY[i] = int(random(width*(-7)));
    ballVisible[i] = true;
    asteroid[i] = loadImage("RONFACE.png");
    asteroid[i].resize(ballD[i], ballD[i]);
  }
}

//-------------------------------------------//
void generateBullets() {
  for (int i = 0; i < bulletX.length; i++) {
    bulletX[i] = -50;
    bulletY[i] = -50;
    bulletVisible[i] = false;
  }
}

//-------------------------------------------//
void redrawGameField() {
  image(galaxy1, 0, img1Y);
  image(galaxy2, 0, img2Y);
  for (int i = 0; i < bulletVisible.length; i++) {
    if (bulletVisible[i] == true) {
      image(laser, bulletX[i]-(bulletW/2), bulletY[i]);
    }
  }
  for (int i = 0; i < ballVisible.length; i++) {
    if (ballVisible[i] == true) {
      image(asteroid[i], ballX[i]-(ballD[i]/2), ballY[i]);
    }
  }

  fill(255);
  image(ship, shipX-(shipW/2), shipY);
}

//-------------------------------------------//
void moveBalls() {
  for (int i = 0; i < ballY.length; i++) {
    if (gameStart == true) {
      ballY[i] += ballSpeed;
      if (ballY[i] >= height) {
        ballX[i] = int(random(width));
        ballY[i] = int(random(width*(-7)));
      }
    }
  }
}
//-------------------------------------------//
void moveBullets() {
  for (int i = 0; i < bulletVisible.length; i++) {
    if (bulletVisible[i] == true) {
      bulletY[i] -= bulletSpeed;
    }
    if (bulletY[i]+bulletH <= 0) {
      bulletVisible[i] = false;
    }
  }
}
//-------------------------------------------//
// a functions that calculates and returns the distance between two points as a decimal number
int distance (int x1, int y1, int x2, int y2) {
  return round(sqrt(pow((x1 - x2), 2) + pow((y1 - y2), 2)));
}
//-------------------------------------------//

// check for collison between the vidible bullets and visible balls using the distance function
void checkCollision() {
  for (int i = 0; i<totalBalls; i++) {
    for (int j = 0; j<totalBalls; j++) {
      dist = distance(ballX[i], ballY[i], bulletX[j], bulletY[j]);
      if (ballVisible[i]==true && bulletVisible[j]==true && dist < ballD[i]/2) {
        // add sound effect to indicate a collision (optional)
        bulletVisible[j] = false;
        score += 50;
        explosionOn = true;
        posX = ballX[i];
        posY = ballY[i];
        currentFrame = 1;
        ballX[i] = int(random(width));
        ballY[i] = int(random(width*(-3)));
      }
    }
  }
}
//Function for the start screen with the instructions.
void startScreen() {
  if (gameStart == false) {
    if (timer >= 0) {
      fill(0);
      rect(0, 0, width, height);
      fill(255, 0, 0);
      textSize(30);
      textAlign(CENTER);
      text("Welcome to Ron's Galaxy game", width/2, 100);
      text("1. Use left and right arrows to controle your ship", width/2, 250);
      text("2. Press SPACE to shoot lasers", width/2, 300);
      text("3. You have three lives", width/2, 350);
      text("4. You lose a life everytime you hit and asteroid", width/2, 400);
      text("The game will start in    ", width/2-20, 450);
      fill(0, 250, 250);
      text(timer, 560, 450);
      if (frameCount % (int)frameRate == 0) {
        timer--;
      }
      if (timer == 0) {
        timerDelay = 0;
        gameStart = true;
      }
    }
  }
}
//Function for the overheating of the ship.
void overHeat() {
  fill(0);
  rect(10, height-40, 160, 30);
  fill(255, 0, 0);
  rect(15, height-35, 150, 20);
  fill(0, 255, 0);
  rect(15, height-35, heat, 20);
  if (heat >= 150) {
    overHeated = true;
  }
  if (overHeated == true) {
    tint(255, 125);
    image(hazard, 15, height-35);
    noTint();
    heat -= 1;
  }
  if (heat <= 0) {
    overHeated = false;
  }
}
//function for the endscreen when you lose all of your lives.
void endScreen() {
  if (lives == 0) {
    fill(#D20DFF);
    rect(0, 0, width, height);
    fill(0);
    textAlign(CENTER);
    textSize(30);
    text("Your final score is: " + score, width/2, 100);
    text("You Have successfully destroyed " + score/50 + " Rons", width/2, 300);
    gameStart = false;
  }
}
//function to draw the lives on the screen.
void lifeCounter() {
  if (timer == 0) {
    if (lives == 3) {
      image(heart, 105, 10);
      image(heart, 55, 10);
      image(heart, 5, 10);
    }
    if (lives == 2) {
      image(heart2, 105, 10);
      image(heart, 55, 10);
      image(heart, 5, 10);
    }
    if (lives == 1) {
      image(heart2, 105, 10);
      image(heart2, 55, 10);
      image(heart, 5, 10);
    }
    if (lives <= 0) {
      image(heart2, 105, 10);
      image(heart2, 55, 10);
      image(heart2, 5, 10);
    }
  }
}
//checks collision between the ship and the asteroids
void checkShipCollision() {
  for (int i = 0; i<totalBalls; i++) {
    dist2 = distance(ballX[i], ballY[i], shipX, shipY);
    if (ballVisible[i] == true && dist2 < ballD[i]/2) {
      lives = lives - 1;
      heat = 0;
      ballX[i] = int(random(width));
      for (int j = 0; j < totalBalls; j++) {
        ballY[j] = int(random(width*(-3)));
      }
    }
  }
}


///////////////////////////////////////////////
// Main Program                             //
/////////////////////////////////////////////

void setup() {
  size(800, 600);
  background(0);
  smooth();
  noStroke();

  font = loadFont("AlBayan-Bold-48.vlw");
  textAlign(RIGHT);

  laser = loadImage("laser.png");
  laser.resize(bulletW, bulletH);
  ship = loadImage("ship.png");
  ship.resize(shipW, shipH);
  galaxy1 = loadImage("space2.png");
  galaxy2 = loadImage("space2.png");
  heart = loadImage("heart.png");
  heart.resize(heartSize, heartSize);
  heart2 = loadImage("heart2.png");
  heart2.resize(heartSize, heartSize);
  hazard = loadImage("hazard.png");
  hazard.resize(150, 20);


  keys=new boolean[5];                     
  keys[0]=false;                           
  keys[1]=false;
  keys[2]=false;                       
  keys[3]=false;
  keys[4]=false;

  generateBalls();
  generateBullets();
  for (int i = 1; i < images.length; i++) {
    String imageName = "frame" + i + ".png";
    images[i] = loadImage(imageName);
    images[i].resize(ballD[i]*2, ballD[i]*2);
  }
}

void draw() {
  background (0);
  if (gameStart == true) {
    redrawGameField();
    moveBalls();
    moveBullets();
    checkCollision();
    if (keys[0] && shipX+shipW/2 != width) {
      redrawGameField();
      shipX = shipX + shipSpeed;
      textFont(font, 50);
      text(score, width-10, 50);
    }

    imageMode(CENTER);
    if (currentFrame < 15 && explosionOn == true) {
      image(images[currentFrame], posX, posY);
      currentFrame++;
    } else {
      explosionOn = false;
    }
    imageMode(CORNER);
    if (keys[1] && shipX-shipW/2 != 0) {
      redrawGameField();
      textFont(font, 50);
      text(score, width-10, 50);
      shipX = shipX - shipSpeed;
    }
    if (keys[3] && shipY >= -10) {
      shipY-=5;
    } else if (keys[4] && shipY <= height-shipH) {
      shipY+=5;
    }
  }

  overHeat();
  lifeCounter();
  checkShipCollision();

  img1Y += bgdSpeed;
  img2Y += bgdSpeed;

  textFont(font, 50);

  textAlign(RIGHT);
  text(score, width-10, 50);

  imageMode(CENTER);
  if (currentFrame < 15 && explosionOn == true) {
    image(images[currentFrame], posX, posY);
    currentFrame++;
  } else {
    explosionOn = false;
  }
  imageMode(CORNER);

  // move the ship with LEFT & RIGHT ARROWS KEYS

  // shut bullets with SPACE BAR
  if (keys[2] && triggerReleased && overHeated == false) {         // triggerReleased is true when the SPACE bar is pressed
    triggerReleased = false;                // then it turns into false to prevent creating more then one bullet 
    bulletX[currentBullet] = shipX;        
    bulletY[currentBullet] = shipY;           
    bulletVisible[currentBullet] = true;   
    currentBullet++;
    if (currentBullet == 100) {
      currentBullet = 0;
    }
  } else if (keys[2]==false) {
    triggerReleased = true;
  }

  startScreen();
  endScreen();

  if (img1Y >= height) {
    img1Y = -600;
  }
  if (img2Y >= height) {
    img2Y = -600;
  }

  if (score % 1500 == 0 && score > 0 && speedBoost == false) {
    ballSpeed += 1;
    speedBoost = true;
  }
  if (speedBoost == true && score % 1500 != 0) {
    speedBoost = false;
  }
  if (heat >= 0) {
    heat -= 0.1;
  }
  delay(timerDelay);
}

void keyPressed() {
  // move the ship left / right with the arrow keys
  if (key==CODED && keyCode==RIGHT) keys[0]=true;
  if (key==CODED && keyCode==LEFT)  keys[1]=true;
  if (key==CODED && keyCode==UP) keys[3]=true;
  if (key==CODED && keyCode==DOWN)  keys[4]=true;
  // shoot bullets when SPACE BAR is pressed
  if (key==' ') keys[2]=true;
}

void keyReleased() {
  if (key==CODED && keyCode==RIGHT) keys[0]=false;
  if (key==CODED && keyCode==LEFT) keys[1]=false;
  if (key==CODED && keyCode==UP) keys[3]=false;
  if (key==CODED && keyCode==DOWN) keys[4]=false;
  if (key==' ') {
    keys[2]=false;
    if (overHeated == false && gameStart == true) {
      heat += 3;
    }
  }
}

