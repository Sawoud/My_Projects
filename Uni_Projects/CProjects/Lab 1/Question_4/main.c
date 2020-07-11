#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    float avg = 0;

    printf("Please input an avarage between 0 - 100: \n");
    scanf(" %f", &avg);
     while(avg > 100 || avg < 0) // this while loop is created to ensure the input is between 0 - 100
        {
            printf("Invalid Input, Please input an avarage between 0 - 100: \n");
            scanf(" %f", &avg);
        }


    if (avg >= 90 && avg <= 100) // these if statments display the correct digit depending on the input
        {
            printf("\n4");
        }
    if (avg >= 80 && avg <= 89)
        {
            printf("\n3");
        }
    if (avg >= 70 && avg <= 79)
        {
            printf("\n2");
        }
    if (avg >= 60 && avg <= 69)
        {
            printf("\n1");
        }
    if (avg <= 59)
        {
            printf("\n0");
        }
        printf("\nThank you for using my program !!!");
return 0;
}
