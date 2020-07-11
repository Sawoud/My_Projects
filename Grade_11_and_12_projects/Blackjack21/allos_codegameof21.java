// Sawoud Al-los
// 7/12/2017
// The purpose of this program is to play a game of blackjack

import java.awt.*;
import java.io.*;
import java.util.*;

public class allos_codegameof21
{
    public static void main (String[] args)
    {
        int loop = 1; // this variable is to make the program loop

        //Variable declaration
        Scanner kbReader = new Scanner(System.in);
        Scanner kbReader2 = new Scanner(System.in);
        Scanner kbReader3 = new Scanner(System.in);
        boolean check = true; // this variable will be used for the input restriction
        String choice;
        Game Player = new Game (); // these two objects are for the players of the game
        Game Computer = new Game ();
        Extra New = new Extra ();
        String name; // this is for the name of the player
        String third; // this variable is if the player wants anthor card

        //Welcome
        System.out.println ("Welcome To Sawoud's Regal Palace ");
        System.out.println ("");
        New.Image1 ();
        System.out.println ("");
        // Input
        System.out.println ("Please Input you name");
        name = kbReader3.nextLine();
        Player.Name (name);
        Computer.Name("Computer");
        while (loop == 1) // this while loop is for looping the program
        {
            loop = 0;
            System.out.println ("");
            Player.Card1(); // these two lines are for the players cards
            Player.Card2();
            System.out.println ("");
            System.out.println ("Would you like to get hit again ?, Please type \"yes\" or \"no\" ");
            third = kbReader3.nextLine();

            while (!third .equals ("yes") && !third .equals ("no"))
            {
                System.out.println ("Please choose one of the following options \"yes\" or \"no\"");
                third = kbReader3.nextLine ();
            }
            if (third .equals("yes")) 
            {
                Player.Card3(); // this is if the player wants anthor card
            }
            System.out.println ("");
            Computer.Card1();
            Computer.Card2();
            if (Computer.Tally () <= 14) // this gives another card to the computer if its propbly not going to go over 21
            {
                Computer.Card3 (); 
            }

            //Processing 
            System.out.println ("");
            System.out.println (name + "'s Total is " + Player.Tally ());
            System.out.println ("Computer's Total is " + Computer.Tally ());
            System.out.println ("");

            Check First = new Check (Player, Computer, New, name);
            //Goodbye
            System.out.println ("If you want to repeat the program type \"yes\" or \"no\"");
            choice = kbReader2.nextLine ();
            while (!choice .equals ("yes") && !choice .equals ("no"))
            {
                System.out.println ("Please choose one of the following options \"yes\" or \"no\"");
                choice = kbReader2.nextLine ();
            }
            if (choice .equals("yes")) 
            {
                loop = loop + 1;
                Player.Repeat ();
                Computer.Repeat ();
            }
            else
            {
                System.out.println ("Thank you for Visiting Sawoud's Regal Palace!");
                New.Image3();
            }
        }
    }
}