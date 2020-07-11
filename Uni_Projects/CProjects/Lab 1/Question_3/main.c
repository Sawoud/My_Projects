#include <stdio.h>
#include <stdlib.h>

int main()
{
    int length = 5;
    int num = 0;
    int i = 0;
    int num_2 = 0;

    printf("Please input your number (Imput 0 to exit): ");
    scanf("%d", &num);
    num = abs(num); //this function makes sure the number is postive

    while (num != 0){ // this loop ensures the number is five digits long
        num_2 = num;
    while (num_2 > 0)
        {
        num_2 = num_2/10;
        i = i + 1;
        }
    if (i == length)
        {
            printf("You inputted a five digit number: %d\n", num);
        }
        while (length != i) //this loop prompts the user to enter a five digit number
            {
                i = 0;
                printf("Please try a diffrent input (Imput 0 to exit): \n");
                scanf("%d", &num);
                num = abs(num);
                num_2 = num;
                if (num == 0) //this if statment allows the program to exit the loop
            {
                break;
            }
            while (num_2 > 0)// this loop ensures the number is five digits long
                {
                num_2 = num_2/10;
                i = i + 1;
                }
            if (i == length) //this loop informs the user that the number is five digits long
            {
                printf("You inputted a five digit number: %d\n", num);
                break;
            }
    }
}
        printf("Thank you for using my program !!!");
    return 0;

}
