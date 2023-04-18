int pinkNum = 10;
int redNum = 7; //easy: 2, normal: 5
PImage [] bg = new PImage[4];
PImage [] pink = new PImage[pinkNum];
PImage [] red = new PImage[redNum]; 
float[] pdY = new float[pinkNum]; //speed
float[] rdY = new float[redNum]; //speed
float[] pdX = new float[pinkNum]; //speed
float[] rdX = new float[redNum]; //speed
float[] pX = new float[pinkNum]; //random x-co
float[] rX = new float[redNum];
float[] pY = new float[pinkNum]; //adding speed
float[] rY = new float[redNum];

PImage wisp;

int easyBtnX, easyBtnY;
int normalBtnX, normalBtnY;
int hardBtnX, hardBtnY;
int btnW, btnH;

int pW, pH; //pink sakura (x, y), width and height
int rW, rH; //red sakura (x, y), width, and height
float wX, wY, wW, wH; //wisp
int score, startTime, endTime;
Boolean timeIsUp;
Boolean countTime;
int stage; 
int i;
int easyrandL, easyrandH, normalrandL, normalrandH; //low and high random speed
int easyRed, normalRed;

void setup()
{   
  stage = 0;
  size(800, 800);
  for (int i=0; i < bg.length; i = i + 1)
  {
    bg[i] = loadImage("bg" + i + ".JPG");
  }

  easyrandL = 4;
  easyrandH = 6;
  easyRed = 2;
  normalRed = 5;
  normalrandL = 6;
  normalrandH = 8;

  for (i=0; i < pink.length; i++) {
    pink[i] = loadImage("Pink.PNG");
    pX[i] = random(20, width - pW); 
    pY[i] = -50;   //initialize from the top window
    pdY[i] = random(easyrandL, easyrandH);
    pdX[i] = random(-2, 2);
  }
  for (i=0; i < red.length; i++) {
    red[i] = loadImage("Red.png");
    rX[i] = random(20, width - rW);
    rY[i] = -45;
    rdY[i] = random(easyrandL, easyrandH);
    rdX[i] = random(-2, 2);
  }

  wisp = loadImage("Wisp.PNG");

  pW = 50;
  pH = 50;
  rW = 45;
  rH = 45;     
  wW = 150;
  wH = 150;

  easyBtnX = 50; 
  easyBtnY = 400; 
  normalBtnX = 50;
  normalBtnY = 500;
  hardBtnX = 50;
  hardBtnY = 600;
  btnW = 100;
  btnH = 50;

  score = 0;
  startTime = millis(); 
  endTime = 0;
  timeIsUp = false;
  countTime = true;
}

void draw() {
  if (stage == 0) {
    WelcomePage();
  } else  if (stage == 1) {
    RulePage();
  } else if (stage == 2) {
    GamePageEasy();
  } else if (stage == 3) { 
    GamePageNormal();
  } else if (stage == 4) {
    GamePageHard();
  } else if (stage == 5) {
    WinPage();
  } else if (stage == 6) {
    startTime = millis(); 
    LosePage();
  }
}

void keyPressed() {
  stage = stage + 1;
  if (key == 'R' || key == 'r') {
    reset();
  }
}

void WelcomePage()
{
  image(bg[0], 0, 0, width, height);  //welcome page
  fill(150, 75, 0);
  textSize(70);
  text("Sakura", 280, 400); 
  textSize(30);
  text("Press any key to start", 250, 477);
}

void RulePage() //rule page
{
  image(bg[1], 0, 0, width, height); 
  fill(0);
  textSize(30);
  text("1. Time required: 20s", 15, 120);
  text("2. Dropping Pink Sakura(+1 score)", 15, 160);
  text("    Dropping Red Sakura(-1 score)", 15, 200);
  text("3. Move mouse (Wisp)", 15, 240);
  text("    to cathch Sakura", 15, 280);
  text("4. Win condition: score=20", 15, 320);
  text("5. Enjoy the game!", 15, 360);

  image(wisp, 480, 240, 150, 150);
  textSize(60);
  text("Wisp", 640, 340);
  image(pink[1], 480, 390, 150, 150);
  text("+1", 645, 495);
  image(red[1], 480, 545, 145, 145);
  text("-1", 650, 645);

  drawButton("Easy", easyBtnX, easyBtnY);
  text("10pink, 2red each loop", easyBtnX +btnW +10, easyBtnY +btnH/2);
  drawButton("Normal", normalBtnX, normalBtnY);
  text("10pink, 5red each loop", normalBtnX +btnW +10, normalBtnY +btnH/2);
  drawButton("Hard", hardBtnX, hardBtnY);
  text("Sakura will fall freely,", hardBtnX +btnW +10, hardBtnY +btnH/2);
  text("7red each loop", hardBtnX +btnW +10, hardBtnY +btnH/2+30);
}

void mousePressed() {
  if (mouseX > easyBtnX && mouseX < easyBtnX + btnW && 
    mouseY > easyBtnY && mouseY < easyBtnY + btnH) { 
    startTime = millis(); 
    stage = 2;
  } else if (mouseX > normalBtnX && mouseX < normalBtnX + btnW && 
    mouseY > normalBtnY && mouseY < normalBtnY + btnH) { 
    startTime = millis(); 
    stage = 3;
  } else if (mouseX > hardBtnX && mouseX < hardBtnX + btnW && 
    mouseY > hardBtnY && mouseY < hardBtnY + btnH) {
    startTime = millis(); 
    stage = 4;
  }
}

void GamePageEasy() //red 2
{ 
  image(bg[2], 0, 0, width, height);
  image(wisp, wX, wY, wW, wH);
  wX = mouseX-wW/2;
  wY = height-wH; //at the Bottom only

  textSize(40);
  fill(0, 100, 200);
  text("Stage: Easy", 15, 50);
  text("Time left: " + (20-(millis() - startTime)/1000) + "s", 490, 290);
  text("Score: " + score, 490, 340);

  if (score == 12) { 
    endTime = (20-(millis() - startTime)/1000);
    countTime = false;
    stage = 5;
  } else if ((20-(millis() - startTime)/1000 < 0)) { 
    stage = 6;
  } else {

    for (i=0; i < pink.length; i++) {
      image(pink[i], pX[i], pY[i], pW, pH);
      pY[i] = pY[i] + pdY[i]; 

      if (pY[i] > height) { 
        pY[i] = -pY[i];  //reenter from top outside
        pdY[i] = random(easyrandL, easyrandH);
        pY[i] = pY[i] + pdY[i];
      }

      if (pX[i] + pW >= wX && pX[i] <= wX + wisp.width/2 && pY[i] + pH >= wY && pY[i] <= wY + wisp.height) {
        score = score + 1; 
        textSize(60);
        text("Yay!", 480, 460);
        pX[i] = random(50, width - pW);   
        pdY[i] = random(easyrandL, easyrandH);
        pY[i] = -pY[i];
      }
    }
    for (i=0; i < easyRed; i++) {
      image(red[i], rX[i], rY[i], rW, rH);
      rY[i] = rY[i] + rdY[i]; 
      if (rY[i] > height) { 
        rY[i] = -rY[i];  //reenter from top outside
        rdY[i] = random(easyrandL, easyrandH);
        rY[i] = rY[i] + rdY[i];
      }
      if (rX[i] + rW >= wX && rX[i] <= wY + wisp.width/2 && rY[i] + rH >= wY && rY[i] <= wY + wisp.height) { 
        textSize(60);
        text("Opps!", 480, 460);
        score = score - 1; 
        rX[i] = random(50, width - rW); 
        rdY[i] = random(easyrandL, easyrandH);  
        rY[i] = -rY[i];
      }
    }
  }
}


void GamePageNormal() //red 5, speed adding
{ 
  image(bg[2], 0, 0, width, height);
  image(wisp, wX, wY, wW, wH);
  wX = mouseX-wW/2;
  wY = height-wH; //at the Bottom only

  textSize(40);
  fill(0, 100, 200); 
  text("Stage: Normal", 15, 50); 
  text("Time left: " + (20-(millis() - startTime)/1000) + "s", 490, 290);
  text("Score: " + score, 490, 340);

  if (score == 12) { 
    endTime = (20-(millis() - startTime)/1000);
    countTime = false;
    stage = 5;
  } else if ((20-(millis() - startTime)/1000 < 0)) { 
    stage = 6;
  } else {

    for (i=0; i < pink.length; i++) {
      image(pink[i], pX[i], pY[i], pW, pH);
      pY[i] = pY[i] + pdY[i]; 

      if (pY[i] > height) { 
        pY[i] = -pY[i];  //reenter from top outside
        pdY[i] = random(normalrandL, normalrandH);
        pY[i] = pY[i] + pdY[i];
      }

      if (pX[i] + pW >= wX && pX[i] <= wX + wisp.width/2 && pY[i] + pH >= wY && pY[i] <= wY + wisp.height) {
        score = score + 1; 
        textSize(60);
        text("Yay!", 480, 460);
        pX[i] = random(50, width - pW);   
        pdY[i] = random(normalrandL, normalrandH);
        pY[i] = -pY[i];
      }
    }
    for (i=0; i < normalRed; i++) {
      image(red[i], rX[i], rY[i], rW, rH);
      rY[i] = rY[i] + rdY[i]; 
      if (rY[i] > height) { 
        rY[i] = -rY[i];  //reenter from top outside
        rdY[i] = random(normalrandL, normalrandH);
        rY[i] = rY[i] + rdY[i];
      }
      if (rX[i] + rW >= wX && rX[i] <= wY + wisp.width/2 && rY[i] + rH >= wY && rY[i] <= wY + wisp.height) { 
        textSize(60);
        text("Opps!", 480, 460);
        score = score - 1; 
        rX[i] = random(50, width - rW); 
        rdY[i] = random(normalrandL, normalrandH);  
        rY[i] = -rY[i];
      }
    }
  }
}

void GamePageHard() //red 7, y-co moving
{
  image(bg[2], 0, 0, width, height);
  image(wisp, wX, wY, wW, wH);
  wX = mouseX-wW/2;
  wY = height-wH; //at the Bottom only

  textSize(40);
  fill(0, 100, 200); 
  text("Stage: Hard", 15, 50); 
  text("Time left: " + (20-(millis() - startTime)/1000) + "s", 490, 290);
  text("Score: " + score, 490, 340);

  if (score == 12) { 
    endTime = (20-(millis() - startTime)/1000);
    countTime = false;
    stage = 5;
  } else if ((20-(millis() - startTime)/1000 < 0)) { 
    stage = 6;
  } else {

    for (i=0; i < pink.length; i++) {
      image(pink[i], pX[i], pY[i], pW, pH);
      pY[i] = pY[i] + pdY[i]; 
      pX[i] = pX[i] + pdX[i];

      if (pY[i] > height) { 
        pY[i] = -pY[i];  //reenter from top outside
        pdY[i] = random(normalrandL, normalrandH);
        pdX[i] = random(-2, 2);
        pX[i] = pX[i] + pdX[i];
      } else if (pX[i] + pW > width) {
        pX[i] = width - pX[i];
      } 

      if (pX[i] + pW >= wX && pX[i] <= wX + wisp.width/2 && pY[i] + pH >= wY && pY[i] <= wY + wisp.height) {
        score = score + 1; 
        textSize(60);
        text("Yay!", 480, 460);
        pX[i] = random(50, width - pW);   
        pdY[i] = random(normalrandL, normalrandH);
        pY[i] = -pY[i];
      }
    }

    for (i=0; i < red.length; i++) {
      image(red[i], rX[i], rY[i], rW, rH);
      rY[i] = rY[i] + rdY[i]; 
      rX[i] = rX[i] + rdX[i];

      if (rY[i] > height) { 
        rY[i] = -rY[i];  //reenter from top outside
        rdY[i] = random(normalrandL, normalrandH);
        rY[i] = rY[i] + rdY[i];
        rdX[i] = random(-2, 2);
        rX[i] = rX[i] + rdX[i];
      } else if (rX[i] + rW > width) {
        rX[i] = width - rX[i];
      }       

      if (rX[i] + rW >= wX && rX[i] <= wY + wisp.width/2 && rY[i] + rH >= wY && rY[i] <= wY + wisp.height) { 
        textSize(60);
        text("Opps!", 480, 460);
        score = score - 1; 
        rX[i] = random(50, width - rW); 
        rdY[i] = random(normalrandL, normalrandH);  
        rY[i] = -rY[i];
      }
    }
  }
}

void WinPage() 
{
  if (countTime == false) {
    image(bg[3], 0, 0, width, height); 
    fill(255, 255, 0);
    textSize(70);
    text("You Win!", width/2-100, height/2);
    textSize(30);
    text("Time left: " + endTime + "s", 310, 430);
    image(wisp, width/2-wW/2, 470, 200, 200);
    text("Press 'R' or 'r' to restart the game", 245, 480);
    image(wisp, width/2-wW/2, 470, 200, 200);
  }
}

void LosePage()  
{

  image(bg[3], 0, 0, width, height); 
  fill(255, 255, 0);
  textSize(70);
  text("Game Over!", width/2-140, height/2-20);
  textSize(28);
  text("Your score: " + score, 310, 430);
  image(wisp, width/2-wW/2, 470, 200, 200);
  text("Press 'R' or 'r' to restart the game", 245, 480);
  textSize(35);
}

void drawButton(String name, int btnX, int btnY) {
  fill(255, 255, 0);
  rect(btnX, btnY, btnW, btnH);
  fill(0);
  textSize(25);    
  text(name, btnX + 10, btnY + 30);
}

void reset()
{
  stage = 0;
  size(800, 800);

  easyrandL = 4;
  easyrandH = 6;
  easyRed = 2;
  normalrandL = 6;
  normalrandH = 8;

  for (i=0; i < pink.length; i++) {
    pX[i] = random(20, width - pW); 
    pY[i] = -50;   //initialize from the top window
    pdY[i] = random(easyrandL, easyrandH);
    pdX[i] = random(-1, 1);
  }
  for (i=0; i < red.length; i++) {
    rX[i] = random(20, width - rW);
    rY[i] = -45;
    rdY[i] = random(easyrandL, easyrandH);
    rdX[i] = random(-1, 1);
  }

  pW = 50;
  pH = 50;

  rW = 45;
  rH = 45;     

  wW = 150;
  wH = 150;

  easyBtnX = 50; 
  easyBtnY = 400; 
  normalBtnX = 50;
  normalBtnY = 500;
  hardBtnX = 50;
  hardBtnY = 600;
  btnW = 100;
  btnH = 50;

  score = 0;
  startTime = millis(); 
  endTime = 0;
  timeIsUp = false;
  countTime = true;
}

