#include <stdio.h>
#include <stdlib.h>

int main()
{
    int length = 0;
    int num = 0;
    int tiny = 0;
    int i = 0;
    int temp = 0;

    printf("Please input how many numbers you would like: "); // this line asks the user how many numbers they would like to use
    scanf("%d", &length);

    while (i<length) // this loop keeps going until the number of inputs have been reached
        {
        printf("Please input a postive n: ");
        scanf("%d", &num);
        while (num <= 0) // this loop ensures the numbers are postive
            {
                printf("Invalid Input, Please try a diffrent input: ");
                scanf("%d", &num);
            }
            if (i == 0) // this statement is present to assign intial values to temp and tiny
            {
                temp = num;
                tiny = num+1;

            }
            if ((i >= 1) && (temp > num)) // this statement changes the value of temp if smaller values have been inputted
            {
                temp = num;

            }
            if (tiny > temp) // this statement changes the value of tiny if temp is smaller
                {
                    tiny = temp;
                }
        i++;
        }


	printf("The smallest number is %d", tiny);
    printf("\nThank you for using my program !!!");

    return 0;
}
