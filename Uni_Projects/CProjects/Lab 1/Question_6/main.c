#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main()
{
    int side1 = 0;
    int side2 = 0;
    int hyp = 0;
    int amount = 0;

    for (side1 = 0; side1 < 400 ; side1++) // this loop increases side1 by 1
    {
        for (side2 = 0;  side2 < 400 ; side2++) // this loop increases side2 by 1
        {
            for (hyp = 0; hyp < 400 ; hyp++) // this loop increases hyp by 1
            {
                if((pow(side1,2) + pow(side2,2)) == pow(hyp,2)&& (side1 <= side2) && (side2 < hyp))
                { // this if statment ensures that only pythagran triples are printed and while (side 1 <= side2) < hyp
                    printf("(%d %d %d) is a pythagran triple \n", side1, side2, hyp);
                    amount++;
                }
            }
        }
    }
    printf("The number triples found is %d\n", amount);
    printf("Thank you for using my program!!!");
    return 0;
}
