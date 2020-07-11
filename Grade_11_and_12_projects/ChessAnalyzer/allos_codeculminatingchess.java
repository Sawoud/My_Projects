// Sawoud Al-los
// 5/15/2017
// The purpose of this program is to read a chees board and determine the score of each side

import java.awt.*;
import java.io.*;
import java.util.*;

public class allos_codeculminatingchess
{
    public static void main (String[] args) throws IOException //this expection allows the program to read from the file
    {
        int loop = 1; // this variable is used to loop the program
        while (loop == 1) // this while loop is to loop the program
        {
            //Variable declaration
            Scanner chess = new Scanner(new File("E:\\Computer Sience\\Culminating\\Input Data\\Input2.txt")); // this scanner specifes where the file location is that is being scanned
            Scanner kbReader = new Scanner(System.in);
            Scanner kbReader2 = new Scanner(System.in);
            String [] spare = new String [8]; // this array is just to store each line of the chessboard and has 8 elements (0 - 7) 1-D
            char [][] chessboard = new char [8][8]; // this array is for each piece of the chessboard and has 64 elements (0 - 7) by (0 - 7) and its 2-D
            int score_white; // this variable is for the score of white
            int score_black; // this variable is for the score of black
            String choice = ""; 
            int firstrow = -1; // this variable is to be used in the first array
            loop = 0;
            int row; // this variable goes through each row in the array
            int column; // this variable goes through each column in the array

            //Welcome
            System.out.println ("************************************");
            System.out.println ("Welcome to The Super Chess Analyzer!");
            System.out.println ("************************************");
            System.out.println ("");

            // Input
            // Assistance was recived from Declean C. and Andrew G. for the input section
            while (chess.hasNext ()) // this while loop goes through each line of the array
            {
                firstrow = firstrow + 1;
                spare [firstrow] = chess.nextLine (); // this line stores each line in the file
            }
            for ( row = 0; row < chessboard.length; row = row + 1) // this section breaks apart each row in columns too
            {
                for ( column = 0; column < chessboard.length; column = column + 1)
                {
                    chessboard [row] [column] = spare [row].charAt (column); // this line breaks down each line into indviduals charchters and stores in in the 2-D array
                }
            } 
            chess.close(); // this line tells the compiler that the reading has finished

            // Display

            for (row = 0 ; row < chessboard.length ; row = row + 1) // this section prints the array in a table
            {
                for (column = 0 ; column < chessboard [0].length ; column = column + 1)
                {
                    if ((column % (chessboard [0].length - 1) == 0) && (column != 0)) // this if checks to see if the postion is at the end of the row, element (7)

                    {
                        System.out.print (chessboard [row] [column]);
                        System.out.print (" ");
                        System.out.println ();
                    }
                    else // this section prints the charchters while they are in elemnts (0 - 6)
                    {
                        System.out.print (chessboard [row] [column]);
                        System.out.print (" ");
                    }
                } 
            } 

            //Processing & Output
            score_white = white (chessboard); // this line calls the method which calculates the white score and passes the chessboared array to it
            score_black = black (chessboard);  // this line calls the method which calculates the black score and passes the chessboared array to it
            System.out.println ("White has a score of " + score_white );
            System.out.println (" ");
            System.out.println ("Black has a score of " + score_black );
            System.out.println (" ");
            if (score_white > score_black)
            {
                System.out.println ("White won the game");
                System.out.println ("  * *   * * ");
                System.out.println ("  * * * * * ");
                System.out.println ("   *     * ");
                System.out.println ("   *     *");
                System.out.println ("   *     * ");
                System.out.println ("  *       * ");
                System.out.println ("*           * ");
                System.out.println ("*           * ");
                System.out.println ("* * * * * * * ");
            }
            if (score_white < score_black)
            {
                System.out.println ("Black won the game");
                System.out.println ("      *");
                System.out.println ("    *   *");
                System.out.println ("   *     *");
                System.out.println ("     *  *");
                System.out.println ("  *       *");
                System.out.println ("     *  *");
                System.out.println ("     *  *");
                System.out.println ("     *  *");
                System.out.println ("   *      * ");
                System.out.println ("   *      * ");
                System.out.println (" * * * * * * ");
            }
            if (score_white == score_black)
            {
                System.out.println ("The game is a tie");
                System.out.println ("     * ");
                System.out.println ("   * * * ");
                System.out.println ("     * ");
                System.out.println (" *       * ");
                System.out.println ("  *     * ");
                System.out.println ("   *   * ");
                System.out.println ("  *     *");
                System.out.println ("*         * ");
                System.out.println ("   *   * ");
                System.out.println ("   *   * ");
                System.out.println ("   *   * ");
                System.out.println ("   *   * ");
                System.out.println ("   *   * ");
                System.out.println ("  *     *");
                System.out.println ("*         * ");
                System.out.println ("*         *");
                System.out.println ("* * * * * *");
            }
            System.out.println (" ");

            // Goodbye
            System.out.println ("If you want to repeat the program type \"yes\" or \"no\"");
            choice = kbReader2.nextLine ();
            while (!choice .equals ("yes") && !choice .equals ("no")) // this makes sure the answer is yes or no
            {
                System.out.println ("Please choose one of the following options \"yes\" or \"no\"");
                choice = kbReader2.nextLine ();
            }
            if (choice .equals("yes")) // this checks if the user wants to repeat the program
            {
                loop = loop + 1;
            }
            else
            {
                System.out.println (" ");
                System.out.println ("Merci Beaucoup for using The Super Chess Analyzer!");
            }
        }
    } 

    public static int white (char [][] chessboard1)
    {
        int score = 0; // this variable is for the score being calculated
        int row = 0; // this variable goes through each row in the array
        int column = 0; // this variable goes through each column in the array

        for ( row = 0; row < chessboard1.length; row = row + 1) // this section goes through every element of the array and adds up the score for white
        {
            for ( column = 0; column < chessboard1 [0].length; column = column + 1) 
            {
                
            
            
                if (chessboard1 [row][column] == 'p') 
                {
                    score= score + 1;
                }
                else if (chessboard1 [row][column] =='k') 
                {
                    score= score + 3;
                }
                else if (chessboard1 [row][column] == 'b') 
                {
                    score= score + 3;
                }
                else if (chessboard1 [row][column] =='r') 
                {
                    score= score + 5;
                }
                else if (chessboard1 [row][column] == 'q') 
                {
                    score= score + 9;
                }
                else if (chessboard1 [row][column] == 'z') 
                {
                    score= score + 0;
                }
                else if (chessboard1 [row][column] == 'P') 
                {
                    score= score + 0;
                }
                else if (chessboard1 [row][column] ==  'K') 
                {
                    score= score + 0;
                }
                else if (chessboard1 [row][column] ==  'B' ) 
                {
                    score= score + 0;
                }
                else if (chessboard1 [row][column] ==  'R' ) 
                {
                    score= score + 0;
                }
                else if (chessboard1 [row][column] ==  'Q' ) 
                {
                    score= score + 0;
                }
                else if (chessboard1 [row][column] == 'Z') 
                {
                    score= score + 0;
                }
                else // this else is present incase an invalid charchter is present
                {
                    score= score + 0;
                }
            } 
        } 

        return score; // this return statment returns the score for white
    }

    public static int black (char [][] chessboard2)
    {
        int score = 0; // this variable is for the score being calculated
        int row = 0; // this variable goes through each row in the array
        int column = 0; // this variable goes through each column in the array

        for ( row = 0; row < chessboard2.length; row = row + 1) // this section goes through every element of the array and adds up the score for black
        {
            for ( column = 0; column < chessboard2 [0].length; column = column + 1) 
            {
                if (chessboard2 [row][column] == 'P') 
                {
                    score= score + 1;
                }
                else if (chessboard2 [row][column] == 'K') 
                {
                    score= score + 3;
                }
                else if (chessboard2 [row][column] == 'B') 
                {
                    score= score + 3;
                }
                else if (chessboard2 [row][column] == 'R') 
                {
                    score= score + 5;
                }
                else if (chessboard2 [row][column] == 'Q') 
                {
                    score= score + 9;
                }
                else if (chessboard2 [row][column] == 'Z') 
                {
                    score= score + 0;
                }
                else if (chessboard2 [row][column] == 'p' ) 
                {
                    score= score + 0;
                }
                else if (chessboard2 [row][column] == 'k' ) 
                {
                    score= score + 0;
                }
                else if (chessboard2 [row][column] ==  'b' ) 
                {
                    score= score + 0;
                }
                else if (chessboard2 [row][column] ==  'r' ) 
                {
                    score= score + 0;
                }
                else if (chessboard2 [row][column] ==  'q') 
                {
                    score= score + 0;
                }
                else if (chessboard2 [row][column] == 'z') 
                {
                    score= score + 0;
                }
                else // this else is present incase an invalid charchter is present
                {
                    score= score + 0;
                }
            } 
        } 
        return score; // this return statment returns the score for black
    }
}
