
public class Game
{
    // instance variables - replace the example below with your own
    private int chance = 0;
    private int chance2 = 0;
    private int chance3 = 0;
    private int total = 0;
    private int value = 0;
    private int value2 = 0;
    private int value3 = 0;
    private String name;
    private boolean verf;
    //private String total;
    /**
     * This method gives the first card to the players
     */
    public int Card1()
    {
        chance = (int)((Math.random () * 13) + 1);
        switch (chance)
        {
            case 1:
            System.out.println (name + "'s first card is an Ace ");
            value = 11;
            break;
            case 2:
            System.out.println (name +"'s first card is a Two");
            value = 2;
            break;
            case 3:
            System.out.println (name +"'s first card is a Three");
            value = 3;
            break;
            case 4:
            System.out.println (name +"'s first card is a Four");
            value = 4;
            break;
            case 5:
            System.out.println (name +"'s first card is a Five");
            value = 5;
            break;
            case 6:
            System.out.println (name +"'s first card is a Six");
            value = 6;
            break;
            case 7:
            System.out.println (name +"'s first card is a Seven");
            value = 7;
            break;
            case 8:
            System.out.println (name +"'s first card is a Eight");
            value = 8;
            break;
            case 9:         
            System.out.println (name +"'s first card is a Nine");
            value = 9;
            break;
            case 10:
            System.out.println (name +"'s first card is a Ten");
            value = 10;
            break;
            case 11:
            System.out.println (name +"'s first card is a Jack");
            value = 10;
            break;
            case 12:
            System.out.println (name +"'s first card is a King");
            value = 10;
            break;
            case 13:
            System.out.println (name +"'s first card is a Queen");
            value = 10;
            break;
        }
        return value;
    }

    /**
     * This method gives the second card to the players
     */
    public int Card2()
    {
        chance2 = (int)((Math.random () * 13) + 1);
        switch (chance2)
        {
            case 1:
            System.out.println (name +"'s second card is an Ace ");
            value2 = 11;
            break;
            case 2:
            System.out.println (name +"'s second card is a Two");
            value2 = 2;
            break;
            case 3:
            System.out.println (name +"'s second card is a Three");
            value2 = 3;
            break;
            case 4:
            System.out.println (name +"'s second card is a Four");
            value2 = 4;
            break;
            case 5:
            System.out.println (name +"'s second card is a Five");
            value2 = 5;
            break;
            case 6:
            System.out.println (name +"'s second card is a Six");
            value2 = 6;
            break;
            case 7:
            System.out.println (name +"'s second card is a Seven");
            value2 = 7;
            break;
            case 8:
            System.out.println (name +"'s second card is a Eight");
            value2 = 8;
            break;
            case 9:         
            System.out.println (name +"'s second card is a Nine");
            value2 = 9;
            break;
            case 10:
            System.out.println (name +"'s second card is a Ten");
            value2 = 10;
            break;
            case 11:
            System.out.println (name +"'s second card is a Jack");
            value2 = 10;
            break;
            case 12:
            System.out.println (name +"'s second card is a King");
            value2 = 10;
            break;
            case 13:
            System.out.println (name +"'s second card is a Queen");
            value2 = 10;
            break;
        }
        return value2;
    }

    /**
     * This method gives the third card to the players if they request it
     */
    public int Card3()
    {
        chance3 = (int)((Math.random () * 13) + 1);
        switch (chance3)
        {
            case 1:
            System.out.println (name +"'s third card is an Ace ");
            value3 = 11;
            break;
            case 2:
            System.out.println (name +"'s third card is a Two");
            value3 = 2;
            break;
            case 3:
            System.out.println (name +"'s third card is a Three");
            value2 = 3;
            break;
            case 4:
            System.out.println (name +"'s third card is a Four");
            value3 = 4;
            break;
            case 5:
            System.out.println (name +"'s third card is a Five");
            value3 = 5;
            break;
            case 6:
            System.out.println (name +"'s third card is a Six");
            value3 = 6;
            break;
            case 7:
            System.out.println (name +"'s third card is a Seven");
            value3 = 7;
            break;
            case 8:
            System.out.println (name +"'s third card is a Eight");
            value3 = 8;
            break;
            case 9:         
            System.out.println (name +"'s third card is a Nine");
            value3 = 9;
            break;
            case 10:
            System.out.println (name +"'s third card is a Ten");
            value3 = 10;
            break;
            case 11:
            System.out.println (name +"'s third card is a Jack");
            value3 = 10;
            break;
            case 12:
            System.out.println (name +"'s third card is a King");
            value3 = 10;
            break;
            case 13:
            System.out.println (name +"'s third card is a Queen");
            value3 = 10;
            break;
        }
        return value3;
    }

    /**
     * This method counts up the score, and if the players have an Ace the program determines if it should have a value of 1 or 11
     */
    public int Tally ()
    {
        total = value + value2 + value3;

        if (chance == 1)
        {
            if (total > 21)
            {
                total = total - 10;
            }
        }

        if (chance2 == 1)
        {
            if (total > 21)
            {
                total = total - 10;
            }
        }

        if (chance3 == 1)
        {
            if (total > 21)
            {
                total = total - 10;
            }
        }

        return total;
    }

    /**
     * This method checks if any of the players have over 21
     */
    public boolean Check ()
    {
        if (total > 21)
        {
            verf = true;
        }

        if (total <= 21)
        {
            verf = false;
        }

        return verf; 
    }

    /**
     * This method is for the names of the players
     */
    public void Name(String z)
    {
         name = z;
    }

    /**
     * This method is to rest all the variables when the user repeats the program
     */
    public void Repeat ()
    {
        chance = 0;
        chance2 = 0;
        chance3 = 0;
        total = 0;
        value = 0;
        value2 = 0;
        value3 = 0;
    }

}
