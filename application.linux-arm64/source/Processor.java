import java.util.*;
import java.io.*;

class ScoreMatrix {

  private static final int [][] blosum62 = {
    { 4, -1, -2, -2,  0, -1, -1,  0, -2, -1, -1, -1, -1, -2, -1,  1,  0, -3, -2,  0},
    {-1,  5,  0, -2, -3,  1,  0, -2,  0, -3, -2,  2, -1, -3, -2, -1, -1, -3, -2, -3},
    {-2,  0,  6,  1, -3,  0,  0,  0,  1, -3, -3,  0, -2, -3, -2,  1,  0, -4, -2, -3},
    {-2, -2,  1,  6, -3,  0,  2, -1, -1, -3, -4, -1, -3, -3, -1,  0, -1, -4, -3, -3},
    { 0, -3, -3, -3,  9, -3, -4, -3, -3, -1, -1, -3, -1, -2, -3, -1, -1, -2, -2, -1},
    {-1,  1,  0,  0, -3,  5,  2, -2,  0, -3, -2,  1,  0, -3, -1,  0, -1, -2, -1, -2},
    {-1,  0,  0,  2, -4,  2,  5, -2,  0, -3, -3,  1, -2, -3, -1,  0, -1, -3, -2, -2},
    { 0, -2,  0, -1, -3, -2, -2,  6, -2, -4, -4, -2, -3, -3, -2,  0, -2, -2, -3, -3},
    {-2,  0,  1, -1, -3,  0,  0, -2,  8, -3, -3, -1, -2, -1, -2, -1, -2, -2,  2, -3},
    {-1, -3, -3, -3, -1, -3, -3, -4, -3,  4,  2, -3,  1,  0, -3, -2, -1, -3, -1,  3},
    {-1, -2, -3, -4, -1, -2, -3, -4, -3,  2,  4, -2,  2,  0, -3, -2, -1, -2, -1,  1},
    {-1,  2,  0, -1, -3,  1,  1, -2, -1, -3, -2,  5, -1, -3, -1,  0, -1, -3, -2, -2},
    {-1, -1, -2, -3, -1,  0, -2, -3, -2,  1,  2, -1,  5,  0, -2, -1, -1, -1, -1,  1},
    {-2, -3, -3, -3, -2, -3, -3, -3, -1,  0,  0, -3,  0,  6, -4, -2, -2,  1,  3, -1},
    {-1, -2, -2, -1, -3, -1, -1, -2, -2, -3, -3, -1, -2, -4,  7, -1, -1, -4, -3, -2},
    { 1, -1,  1,  0, -1,  0,  0,  0, -1, -2, -2,  0, -1, -2, -1,  4,  1, -3, -2, -2},
    { 0, -1,  0, -1, -1, -1, -1, -2, -2, -1, -1, -1, -1, -2, -1,  1,  5, -2, -2,  0},
    {-3, -3, -4, -4, -2, -2, -3, -2, -2, -3, -2, -3, -1,  1, -4, -3, -2, 11,  2, -3},
    {-2, -2, -2, -3, -2, -1, -2, -3,  2, -1, -1, -2, -1,  3, -3, -2, -2,  2,  7, -1},
    { 0, -3, -3, -3, -1, -2, -2, -3, -3,  3,  1, -2,  1, -1, -2, -2,  0, -3, -1,  4}};
  
    public static int getValue ( char a, char b ){
      return ScoreMatrix.blosum62 [ ScoreMatrix.getIndex(a) ] [ ScoreMatrix.getIndex(b) ];
    }
    
    public static int stringSimilarity ( String s1, String s2 ){
      int score = 0;
      for ( int i = 0; i < s1.length(); i++ ){
        score += ScoreMatrix.getValue( s1.charAt(i), s2.charAt(i) );
      }
      return score;
    }
    
    private static int getIndex(char a) {
      switch ((String.valueOf(a)).toUpperCase().charAt(0)) {
          case 'A': return 0;
          case 'R': return 1;
          case 'N': return 2;
          case 'D': return 3;
          case 'C': return 4;
          case 'Q': return 5;
          case 'E': return 6;
          case 'G': return 7;
          case 'H': return 8;
          case 'I': return 9;
          case 'L': return 10;
          case 'K': return 11;
          case 'M': return 12;
          case 'F': return 13;
          case 'P': return 14;
          case 'S': return 15;
          case 'T': return 16;
          case 'W': return 17;
          case 'Y': return 18;
          case 'V': return 19;
          default: return -1;
      }
    }
    
    /*public static int getMinMatrix (){
      int min = blosum62[0][0]; 
      for ( int i = 0; i < 20; i++ ){
        for ( int j = 0; j < 20; j++ ){
          if ( blosum62[i][j] < min )
            min = blosum62[i][j];
        }
      } 
      return min;
    }

    public static void getStandardizedMatrix () throws Exception {
      int min = ScoreMatrix.getMinMatrix();
      for ( int i = 0; i < 20; i++ ){
        for ( int j = 0; j < 20; j++ ){
          blosum62[i][j] -= min;
        }
      }
      PrintWriter writer = new PrintWriter("prova.txt");
      writer.println( "{" );
      for ( int i = 0; i < 20; i++ ){
        writer.print("{ ");
        for ( int j = 0; j < 20; j++ ){
          writer.print("" + blosum62[i][j] + ", ");
        }
        writer.println("}");
      }
      writer.print( "};" );
      writer.close();
    }

    public static void writeOnFile () throws Exception {
      PrintWriter writer = new PrintWriter("prova.txt");
      writer.println( "Ciao" );
      writer.close();
    }*/

    public static int getMaxMatrix (){
      return 15; //se cambia la mtrice, diventa sbagliato!!! 
    } 

}

class DotPlot {
 
  int [][] dotplot;
  
  public DotPlot ( int s1, int s2 ){
    this.dotplot = new int [s1][s2];
  }

  public int[][] get(){
    return this.dotplot;
  }

}

class Processor {
  
  public String s1, s2;
  public DotPlot dotplot;
  public int [][] mers;

  public Processor ( String s1, String s2 ){
    this.s1 = s1;
    this.s2 = s2;
  }

  public void processDotPlot (){
    /*System.out.println( "processing dotplot" );
    for ( int i = 0; i < s1.length(); i++ )
      for ( int j = 0; j < s2.length(); j++ );
        //this.dotplot.get()[i][j] = ScoreMatrix.getValue( s1.charAt(i), s2.charAt(j) );*/
  }

  public void processMers ( int w ){
    try{
      this.mers = new int[ s1.length()-w+1 ][ s2.length()-w+1 ];
      for ( int i = 0; i < s1.length()-w+1; i++ ){
        for ( int j = 0; j < s2.length()-w+1; j++ ){
          //System.out.println( s1.substring( i, i+w ) + " " + s2.substring( j, j+w ) );
          //System.out.println( i + " " + j );
          this.mers[i][j] = ScoreMatrix.stringSimilarity( s1.substring( i, i+w ), s2.substring( j, j+w ) );
        }
      }
    }
    catch( Exception e ){
      System.out.println( e );
    }
  }

  public void setDotPlot ( DotPlot dotplot ){
    this.dotplot = dotplot;
  }

  public DotPlot getDotPlot (){
    return this.dotplot;
  }

  public int[][] getMers (){
    return this.mers;
  }

}
