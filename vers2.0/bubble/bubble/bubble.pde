import java.util.*;
import controlP5.*;

int numBalls = 100;
float spring = 0.05;
float gravity = -0.03;
float friction = -0.05;
ArrayList<Ball> balls;
Processor p;
Display d;
String s1,s2;
color [] palette;
int W = 3;
int W1 = 3;

ControlP5 cp5;
int sliderTicks2 = 30;
Slider abc;
ColorPalette sa = new ColorPalette();
String[] args = {""};

void settings(){
  size(1280, 720);
  String[] lines = loadStrings( sketchPath("Input1.txt") );
  s1 = lines[0];
  s2 = lines[1];
  PApplet.runSketch( args,sa );
}

void setup() {
  
  frameRate(30);
  p = new Processor( s1,s2 );
  d = new Display();
  
  cp5 = new ControlP5(this);
  cp5.addSlider( "W" )
    .setPosition( 50,650 )
    .setWidth( 270 )
    .setSize(1180,30)
    .setRange( 1, min( s1.length(), min(s2.length(),100) ) )
    .setValue( 3 )
    .setNumberOfTickMarks( min( s1.length(), min(s2.length(),100) ) );
  
  p.processMers( W1 );
  d.initColorPalette( s1.length(), s2.length() );
  sa.displayMatrixColorSpace();
  balls = d.displayBalls( p.getMers(), 1000 );
  
  noStroke();
}

class ColorPalette extends PApplet {

  void settings (){
    size(s1.length(),s2.length());
  }
  
  void setup(){
  }
  
  void draw (){
  }
  
  public void displayMatrixColorSpace (){
    
    for ( int i = 0; i < s1.length(); i++ )
      for ( int j = 0; j < s2.length(); j++ )
        set( i,j,palette[ j-i+s1.length()-1 ] );
   
  }

}

void draw() {
  background(50);

  if ( W1 != W ){
    W1 = W;
    p.processMers( W1 );
    balls = d.displayBalls( p.getMers(), 1000 );
  }
  
  for (Ball ball : balls) {
    ball.move();
    ball.display();  
  }
  
}

class Display {
  
  public ArrayList<Ball> displayBalls ( int [][] mers, int numberOfBalls ){
    this.initColorPalette( mers.length,mers[0].length );
    ArrayList<ArrayList<Ball>> balls = this.sortBalls( mers );
    ArrayList<Ball> bestBalls = this.getBestBalls( balls, numberOfBalls ); 
    return bestBalls;
  }
  
  public void initColorPalette ( int s1Length, int s2Length ){
  
    colorMode( HSB, 360,(float)100,100 );
    
    palette = new color [ s1Length + s2Length - 1 ];
    float j = 100;
    
    for ( int i = -s1Length; i < 0; i++ ){
      palette[ i + s1Length ] = color ( 239, round(j), 100 );
      j -= (float)100/(s1Length);
    }

    j = 0;
    for ( int i = 0; i < s2Length; i++ ){
      palette[ i + s1Length-1 ] = color ( 130, round(j), 100 );
      j += (float)100/(s2Length);
    }
  
  }
  
  public int getColor ( int i, int j, int s1Length ){
    return palette[ j-i+s1Length-1 ];
  }
  
  private ArrayList<ArrayList<Ball>> sortBalls ( int [][] mers ){
    ArrayList<ArrayList<Ball>> balls = new ArrayList<ArrayList<Ball>>( this.processMaxScore()+1 );
    int minMatrix = this.minMatrix( mers );
    
    for ( int i = 0; i <= this.processMaxScore(); i++ ){
      balls.add( new ArrayList<Ball>() );
    }
    
    if ( minMatrix > 0 ) {
      for ( int i = 0; i < mers.length; i++ ){
        for ( int j = 0; j < mers[0].length; j++ ){
          balls.get( mers[i][j] ).add( new Ball( random(width-100)+50, 600, 10, 0, 720-min( pow(mers[i][j]- minMatrix,0.97),720 ), this.getColor(i,j,mers.length) ) );
        }
      }
    }
    else{
      for ( int i = 0; i < mers.length; i++ ){
        for ( int j = 0; j < mers[0].length; j++ ){
          balls.get( mers[i][j] - minMatrix ).add( new Ball( random(width-100)+50, 600, 10, 0, 720-min( pow(mers[i][j]- minMatrix,0.97),720 ), this.getColor(i,j,mers.length) ) );
        }
      }
    }
    
    return balls;
  }
  
  private int minMatrix ( int [][] mers ){
    int min = mers[0][0];
    
    for ( int i = 0; i < mers.length; i++ ){
      for ( int j = 0; j < mers[0].length; j++ ){
        if ( mers[i][j] < min )
          min = mers[i][j];
      }
    }
    
    return min;
  }
  
  private ArrayList<Ball> getBestBalls ( ArrayList<ArrayList<Ball>> balls, int k ){
    int counter = 0; 
    ArrayList<Ball> bestBalls = new ArrayList<Ball>();
    
    for ( int i = balls.size()-1; i >= 0; i-- ){
      ArrayList<Ball> element = balls.get(i);
      for ( Ball g : element ){
        bestBalls.add( 0, g );
        counter++;
        if ( counter >= k )
          return bestBalls;
      }
    }
    return bestBalls;
  }
  
  private int processMaxScore (){
    return W * ScoreMatrix.getMaxMatrix();
  }
  
}

class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  float score;
  color c;
 
  Ball(float xin, float yin, float din, int idin, float score, color c ) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    this.score = score;
    this.c = c;
  } 
  
  void move() {
    if ( this.y > this.score ){
      vy += gravity;
      y += vy;
      if (y + diameter/2 > height) {
        y = height - diameter/2;
        vy *= friction; 
      } 
      else if (y - diameter/2 < 20) {
        y = diameter/2+20;
        vy *= friction;
      }
    }
  }
  
  void display() {
    fill( this.c );
    ellipse(x, y, diameter, diameter);
  }
}
