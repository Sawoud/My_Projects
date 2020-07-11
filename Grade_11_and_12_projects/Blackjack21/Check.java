
public class Check
{

    /**
     * This Constructer method is used to determine who won the round of blackjack
     */
    public Check(Game Player, Game Computer,Extra New, String name)
    {
        if (Player.Check() == true && Computer.Check () == true) //these if and else if statments display the winer
        {
            System.out.println ("The Round Is A Draw" );
        }
        else if (Player.Check() == true) 
        {
            System.out.println ("Computer Won The Round" );
        }
        else if (Computer.Check () == true) 
        {
            System.out.println (name + " Won The Round" );
        }
        else
        {
            if (Player.Tally () > Computer.Tally ())
            {
                System.out.println (name + " Won The Round" );
            }

            else if (Player.Tally () < Computer.Tally ())
            {
                System.out.println ("Computer Won The Round" );
            }

            else if (Player.Tally () == Computer.Tally ())
            {
                System.out.println ("The Round Is A Draw" );
            }
        }

        if (Player.Tally() == 21 || Computer.Tally () == 21) 
        {
            New.Image2();
        }
    }

}
