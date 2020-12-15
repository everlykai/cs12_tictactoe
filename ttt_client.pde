//Server (sends O's (1))
import processing.net.*;
boolean myTurn = false;

Client myClient;
int[][] grid;


void setup() {
  size(300, 400);
  grid = new int[3][3];
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
  myClient = new Client(this,"127.0.0.1", 1234);
}

void draw() {
  
  if (myTurn)
    background(255);
  else background(100);

  //draw dividing lines
  stroke(0);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);

  //draw the x's and o's
  for (int i=0; i<3; i++) {
    for (int j=0; j<3; j++) {
      drawXO(i,j);
    }
  }

  //draw mouse coords
  fill(0);
  text(mouseX + "," + mouseY, 150, 350);
  
  //rec msg
  if (myClient.available() > 0) {
    String incoming = myClient.readString();
    int r = int(incoming.substring(0,1));
    int c = int(incoming.substring(2,3));
    grid[r][c] = 2;
    myTurn = true;
  }
}


void drawXO(int row, int col) {
  pushMatrix();
  translate(row*100, col*100);
  if (grid[row][col] == 1) {
    noFill();
    ellipse(50, 50, 90, 90);
  } else if (grid[row][col] == 2) {
    line (10, 10, 90, 90);
    line (90, 10, 10, 90);
  }
  popMatrix();
}


void mouseReleased() {
  //assign the clicked-on box with the current player's mark
  int row = (int)mouseX/100;
  int col = (int)mouseY/100;
  if (myTurn && grid[row][col] == 0)
    grid[row][col] = 1;
    myClient.write(row + "," + col);
    myTurn = false;
}
