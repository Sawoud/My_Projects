#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int i = 0; // this variable is reserved to be used as a counter in the loops
    int sum = 0; // this variable is to be used in the summation

    //Question 1
    printf("This program is going to sum up multiples of 4 from 30 to 1000 \n");
    for(i = 30; i < 1000; i++) // this is a for loop that is increment by 1 and has a max condition of 999
    {
        if (i%4 == 0); // this if statement ensures that the number is divisible by 4
        {
            sum += i; // if the condition is true the multiple is added to the sum
        }

    }
    printf("This is the summation done using a for loop : %d \n", sum); //this statment prints the results


    i = 30; // these two lines ensure that the values for sum and i get reset to their intial values
    sum = 0;
    while (i < 1000) // this is a while which has a max condition of 999
    {
        if (i%4 == 0);  // this if statement ensures that the number is divisible by 4
        {
        sum += i; // if the condition is true the multiple is added to the sum
        }
        i++;
    }
    printf("This is the summation done using a while loop : %d \n", sum); //this statment prints the results

    i = 30; // these two lines ensure that the values for sum and i get reset to their intial values
    sum = 0;
    do // this is a do-while which has a max condition of 999
    {
        if (i%4 == 0);  // this if statement ensures that the number is divisible by 4
        {
        sum += i; // if the condition is true the multiple is added to the sum
        }
        i++;
    } while (i < 1000);

    printf("This is the summation done using a do-while loop : %d \n", sum); //this statment prints the results
    printf("Thank you for using my program !!!");

    return 0;
}
