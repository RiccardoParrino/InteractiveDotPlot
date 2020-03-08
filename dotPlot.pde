import java.util.*;
import controlP5.*;
import processing.sound.*;

SinOsc s;
Display d;
Processor p;
String s1,s2;
int W = 3;

ControlP5 cp5;
int sliderTicks2 = 30;
Slider abc;

void setup (){
  size( 500,500 );
  background( 0 );

  String[] lines = loadStrings( sketchPath("Input.txt") );
  s1 = lines[0];
  s2 = lines[1];
  System.out.println(s1.length()+" "+ s2.length());
  System.out.println(s2);
  
  cp5 = new ControlP5(this);
  cp5.addSlider( "W" )
    .setPosition( 10,460 )
    .setWidth( 270 )
    .setSize(475,30)
    .setRange( 1, min( s1.length(), min(s2.length(),100) ) )
    .setValue( 3 )
    .setNumberOfTickMarks( min( s1.length(), min(s2.length(),100) ) );

  s = new SinOsc (this);

  p = new Processor( s1,s2 );
  p.processMers( W );
  
  d = new Display();
  d.setSizeMapping ( new SimpleSizeMapping ( d.getSizeList().size() ) );
  d.setColorMapping ( new SimpleColorMapping ( d.getColorPalette().size() ) );
  
  d.displayGlyphs( p.getMers(),50 );
  
}

void draw (){
  background(0);
  p.processMers( W );
  d.displayGlyphs( p.getMers(),10000 );
  fill( 215,215,215 );
  rect( 0,450,500,500 ); 
}

void slider (float theCoolor){
  System.out.println( "CIAO" );
}

class SimpleSizeMapping implements Function {
  
  public int sizeList;
  
  public SimpleSizeMapping ( int sizeList ){
    this.sizeList = sizeList;
  }
  
  @Override
  public int apply ( int x ){
    if ( x < 0  )
      return 0;
    return ( round(min( x, sizeList-1 )) );
  }
  
  @Override
  public void setMaxScore ( int score ){}
  
}

class SimpleColorMapping implements Function {
  
  public int sizePalette;
  
  public SimpleColorMapping ( int sizePalette ){
    this.sizePalette = sizePalette;
  }
  
  @Override
  public int apply ( int x ){
    if ( x < 0 )
      return 0;
    return ( round(min(x, sizePalette-1 )) );
  }
  
  @Override
  public void setMaxScore ( int score ){}
  
}

class Display {
  
  public ArrayList<Color> colorPalette;
  public ArrayList<Size> sizeList;
  public Function colorMapping;
  public Function sizeMapping;
  public float rotationAngle;
  
  public Display (){
    this.colorPalette = this.initPalette();
    this.sizeList = this.initSizeList();
  }
  
  public void displayGlyphs ( int [][] mers, int numberOfGlyphs ){
    this.rotationAngle = -atan( mers.length/mers[0].length );
    ArrayList<ArrayList<Glyph>> glyphs = this.sortGlyphs( mers );
    ArrayList<Glyph> bestGlyphs = this.getBestGlyph( glyphs, numberOfGlyphs ); // VISUALIZZIAMO 200 ELEMENTI
    this.displayBestGlyphs( bestGlyphs );
  }
  
  private void displayBestGlyphs( ArrayList<Glyph> bestGlyphs ){
    for ( Glyph g : bestGlyphs ){
      pushMatrix();
      //System.out.println( (((float)400)/s1.length()) + ", " + (400/s2.length()) );
      translate( ((g.x)*(((float)400)/(s1.length()-W))+50), ((g.y)*(((float)400)/(s2.length()-W))+25) );
      rotate( this.rotationAngle ); 
      Size s = this.getSize(g.score);
      int h = s.getHeight();
      int w = s.getWidth();
      fill( this.getColor(g.score) );
      //fill( 255,255,255 );
      rect( -w/2, -h/2, w, h );
      popMatrix();
    }
    s.play( bestGlyphs.get( bestGlyphs.size()-1 ).score, 0.5 );
  }
  
  private ArrayList<ArrayList<Glyph>> sortGlyphs ( int [][] mers ){
    ArrayList<ArrayList<Glyph>> glyphs = new ArrayList<ArrayList<Glyph>>( this.processMaxScore()+1 );
    int minMatrix = this.minMatrix( mers );
    
    for ( int i = 0; i <= this.processMaxScore(); i++ ){
      glyphs.add( new ArrayList<Glyph>() );
    }
    
    if ( minMatrix > 0 ) {
      for ( int i = 0; i < mers.length; i++ ){
        for ( int j = 0; j < mers[0].length; j++ ){
          glyphs.get( mers[i][j] ).add( new Glyph( mers[i][j], i, j ) );
        }
      }
    }
    else{
      for ( int i = 0; i < mers.length; i++ ){
        for ( int j = 0; j < mers[0].length; j++ ){
          glyphs.get( mers[i][j] - minMatrix ).add( new Glyph( mers[i][j], i, j ) );
        }
      }
    }
    
    return glyphs;
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
  
  private ArrayList<Glyph> getBestGlyph ( ArrayList<ArrayList<Glyph>> glyphs, int k ){
    int counter = 0; 
    ArrayList<Glyph> bestGlyphs = new ArrayList<Glyph>();
    
    for ( int i = glyphs.size()-1; i >= 0; i-- ){
      ArrayList<Glyph> element = glyphs.get(i);
      for ( Glyph g : element ){
        bestGlyphs.add( 0, g );
        counter++;
        if ( counter >= k )
          return bestGlyphs;
      }
    }
    return bestGlyphs;
  }
  
  public color getColor ( int score ){
    return this.colorPalette.get( this.colorMapping.apply( score ) ).get();
  }
  
  public Size getSize ( int score ){
    return this.sizeList.get( this.sizeMapping.apply( score ) );
  }
  
  private ArrayList<Color> initPalette (){
    try {
      ArrayList<Color> palette = new ArrayList<Color> ();
      String[] lines = loadStrings( sketchPath("palette.txt") );
      for ( String s : lines ){
        String [] component = s.split( "," );
        color c = color ( 255*Float.parseFloat(component[0]), 255*Float.parseFloat(component[1]), 255*Float.parseFloat(component[2]) );
        palette.add( new Color ( c ) );
      }
      return palette;
    }
    catch( Exception e ){
      System.out.println( "File palette inesistente" );
    }
    return null;
  }
  
  private ArrayList<Size> initSizeList (){
    try {
      ArrayList<Size> sizeList = new ArrayList<Size>();
      String [] lines = loadStrings ( sketchPath("dimension.txt") );
      for ( String s : lines ){
        int value = Integer.parseInt ( s );
        sizeList.add( new Size ( value, 2*value - 1 ) );
      }
      return sizeList;
    }
    catch ( Exception e ){
      System.out.println( "File size not found" );
    }
    return null;
  }
  
  public void setColorMapping ( Function colorMapping ){
    this.colorMapping = colorMapping;
  }
  
  public void setSizeMapping ( Function sizeMapping ){
    this.sizeMapping = sizeMapping;
  }
  
  public ArrayList<Color> getColorPalette (){
    return this.colorPalette;
  }
  
  public ArrayList<Size> getSizeList (){
    return this.sizeList;
  }
  
  private int processMaxScore (){
    return W * ScoreMatrix.getMaxMatrix();
  }
  
}

interface Function {
  public int apply ( int x );
  public void setMaxScore ( int score );
}

class QuadraticThresholdSizeMapping implements Function {
  
  public int S = 25;
  public float a1, b1;
  public float a2, b2;
  public int v1 = 5, v2 = 8;
  public int maxScore;
  
  public QuadraticThresholdSizeMapping ( int sizeList, int maxScore ) {
    this.maxScore = maxScore;
    this.b1 = 0;
    this.a1 = ( v1 - b1*S )/( S*S );
    this.b2 = ( (sizeList-1) - v2 )/( S*S*maxScore - S );
    this.a2 = ( v2 - b2*S )/( S*S );
  }
  
  public int apply ( int x ){
    if ( x < S ){
      System.out.println( (x) );
      return (this.f1( x ));
    }
    else{
      System.out.println( (x) );
      return (this.f2( x ));
    }
  }
  
  private int f1 ( int x ){
    System.out.println( a1*x*x + b1*x );
    return round( a1*x*x + b1*x ); 
  }
  
  private int f2 ( int x ){
    System.out.println( a2*x*x + b2*x );
    return round( a2*x*x + b2*x );
  }
  
  @Override
  public void setMaxScore ( int maxScore ){
    this.maxScore = maxScore;
  }
  
}

class QuadraticThresholdColorMapping implements Function {
  
  public int S = 100;
  public float a1, b1;
  public float a2, b2;
  public int v1 = 50, v2 = 50;
  public int maxScore;
  
  public QuadraticThresholdColorMapping ( int sizePalette, int maxScore ) {
    this.maxScore = maxScore;
    this.b1 = 0.5;
    this.a1 = ( v1 - b1*S )/( S*S );
    this.b2 = ( (sizePalette-1) - v2 )/( S*S*maxScore - S );
    this.a2 = ( v2 - b2*S )/( S*S );
  }
  
  public int apply ( int x ){
    if ( x < S ){
      return (this.f1( x ));
    }
    else{
      return (this.f2( x ));
    }
  }
  
  private int f1 ( int x ){
    return round( a1*x*x + b1*x ); 
  }
  
  private int f2 ( int x ){
    return round( a2*x*x + b2*x );
  }
  
  @Override
  public void setMaxScore ( int maxScore ){
    this.maxScore = maxScore;
  }
  
}

class QuadraticSizeMapping implements Function {
  
  public float a, b;
  public int maxScore;
  
  public QuadraticSizeMapping ( int sizeList, float b, int maxScore ){
    this.b = b;
    this.maxScore = maxScore;
    this.a = ((sizeList-1) - b*(maxScore))/( maxScore*maxScore );
  }
  
  @Override
  public int apply ( int x ){
    return round(a*x*x + b*x);
  }
  
  @Override
  public void setMaxScore ( int maxScore ){
    this.maxScore = maxScore;
  }
  
}

class QuadraticColorMapping implements Function {
  
  public float a, b;
  public int maxScore;
  
  public QuadraticColorMapping ( int sizePalette, float b, int maxScore ){
    this.b = b;
    this.maxScore = maxScore;
    this.a = ((sizePalette-1) - b*(maxScore))/( maxScore*maxScore );
  } 
  
  @Override
  public int apply ( int x ){
    return round(a*x*x + b*x);
  }
  
  @Override
  public void setMaxScore ( int maxScore ){
    this.maxScore = maxScore;
  }
  
}

class Size {

    public int w, h;
    
    public Size ( int  w, int h ){
      this.w = w;
      this.h = h;
    }
    
    @Override
    public String toString (){
      return ""+w;
    }
    
    public int getHeight (){
      return this.h;
    }
    
    public int getWidth (){
      return this.w;
    }

}

class Color { // wrapper class
  
  public color c;
  
  public Color ( color c ){
     this.c = c;
  }
  
  public color get (){
    return this.c;
  }  
  
  @Override
  public String toString (){
    return "" + c;
  }
  
}

class Glyph {
  
  int score, x, y;
  int h, w;
  color c;
  
  public Glyph ( int score, int x, int y ){
    this.score = score;
    this.x = x;
    this.y = y;
  }
  
  public void setHeight ( int h ){
    this.h = h;
  }
  
  public void setWidth ( int h ){
    this.w = w;
  }
  
  public String toString (){
    return "" + this.score;
  }

}
