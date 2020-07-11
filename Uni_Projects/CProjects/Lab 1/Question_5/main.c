#include <stdio.h>
#include <stdlib.h>

int main()
{
    float pi = 0;
    int n = 0;
    int i = 0;
    int base = -1;
    printf("Please Input how many intgers you would like to use: ");
    scanf("%d", &n);
    while (i < n) // this loops calculates the value of pi using the amount of terms the user wants
        {
            base += 2; // this statment keeps incrementing the value of the base by 2
            pi = pi + (4.0/base)*pow(-1,i); // pow keeps changing the sign of the terms
            i++;
        }
        printf("pi is approximately = %f", pi);
        printf("\nThank you for using my program !!!");


}
