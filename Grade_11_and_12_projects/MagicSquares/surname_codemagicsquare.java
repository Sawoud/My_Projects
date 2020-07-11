// Sawoud Al-los
// 5/10/2017
// The purpose of this program is to make a square and test to see if it is a magic square

import java.awt.*;
import java.io.*;
import java.util.*;

public class surname_codemagicsquare
{

    public static void main (String[] args)
    {

        //Variable declaration
        Scanner kbReader = new Scanner(System.in);
        int n; // this variable is for the input by thr user
        int z;
        int x; // z , x ,y are for the loops
        int y = 0;
        boolean test_result; // this boolean is the result of the test

        //Welcome
        System.out.println ("***********************************************");
        System.out.println (" Welcome to The Super Amazing Square Generater ");
        System.out.println ("***********************************************");

        // Input
         System.out.println ("Please type in a number for the size of the square");
        n = kbReader.nextInt (); // this line stores the input by the user

        int [] [] square = new int [n][n];
        //int square[][] = {{8, 1, 6},{3, 5, 7},{4, 9, 2}};

        for (z = 1 ; z <= (n * n); z = z + 1) // this for loop generates all the numbers fron 1 -n^2
        {
            x  = (int)(Math.random () * (n))  ;
            y  = (int)(Math.random () * (n))  ; // these two lines fin random locations to store the numbers
            if (square [x][y] != 0) // this section is present in case a location is taken so that it does not get overwrriten and makes sure each number appers once 
            {
                while (square [x][y] != 0)
                {
                    x  = (int)(Math.random () * (n))  ;
                    y  = (int)(Math.random () * (n))  ;
                    if (square [x][y] == 0)
                    {
                        square [x][y] = z;
                        break;
                    }
                    else
                    {
                    }
                }
            }
            square [x][y] = z;
        }

        for (x = 0 ; x < square.length ; x = x+ 1) // this section prints out the array 
        {
            for (y = 0 ; y < square.length ; y = y + 1)
            {

                if ((y % (square [0].length - 1) == 0) && (y != 0))
                //edge of an array's row

                {
                    System.out.print ("\t" + square [x] [y]);
                    System.out.print (" ");
                    System.out.println ();
                }
                else
                {
                    System.out.print ("\t" +square [x] [y]);
                    System.out.print (" ");
                } 
            }
        } 

        test_result = isMagic (square);// this line makes the program go to the array
        if (test_result == true)
        {
            System.out.println ("This is a magic square");
        }
        else 
        {
            System.out.println ("This is not a magic square");
        }
        //Processing

        //Goodbye
        System.out.println ("********************************************************************");
        System.out.println (" Thank you for using Welcome to The Super Amazing Square Generater!");
        System.out.println ("********************************************************************");

    } 

    public static boolean isMagic (int [][]square1)
    {
        int x; // x ,y are for the loops
        int y = 0;
        int v_ref = 0; // this is the refrence value
        int v_temp = 0; // this is the temporary value
        boolean magic = false; // this the boolean that is going to be used in determining weither it is a magic square or not

        for (y = 0; y < square1.length ; y = y + 1)// this section calculates the sum as the first column to be used as a reference
        {
            v_ref = v_ref + square1 [0][y] ;
        }
        for (x=1; x <square1.length ; x = x + 1) // this section calculates each column after the first column
        {
            for (y = 0; y < square1.length ; y = y + 1)
            {
                v_temp = v_temp + square1 [x][y] ;
            }
            if (v_ref == v_temp) // this if statement checks for equality and if equality exists a Boolean value of true is assigned
            {
                magic = true;
            }
            v_temp = 0;
        }

        if (magic = true)
        {
            for (x=0; x <square1.length ; x = x + 1)  // this for loop calculates each row 
            {
                for (y = 0; y < square1.length ; y = y + 1)
                {
                    v_temp = v_temp +(square1 [y][x])  ;
                }
                if (v_ref == v_temp) // this if statement checks for equality and if equality exists a Boolean value of true is assigned
                {
                    magic = true;
                }
                else
                {
                    magic = false;
                }
                v_temp = 0;

            }
        }

        if (magic = true)
        {
            for (x=0, y = 0; x <square1.length && y < square1.length ; x = x + 1, y = y + 1 ) // this if statement checks for equality and if equality exists a Boolean value of true is assigned
            {
                v_temp = v_temp + (square1 [x][y]) ;
                if (v_ref == v_temp)
                {
                    magic = true;
                }
                else
                {
                    magic = false;
                }
            }
        }
        return magic; // this return statement returns the value of magic

    }
}
