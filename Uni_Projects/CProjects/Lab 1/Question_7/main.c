#include <stdio.h>
#include <stdlib.h>

int main()
{
    int m = 0;
    int num = 2;
    int factor = 1;
    int sum = 0;

    printf("Please Input an intger: ");
    scanf("%d", &m);

    while (m <= 1) // this while loop ensures the number is greater than 1
    {
        printf("Please Input an intger: ");
        scanf("%d", &m);
    }
        while (m >= num) //this while loop keeps going if the number is less than the total amount of numbers requested
        {

        while (num > factor) // this loop is used to find the factors of the number
        {

            if (num%factor == 0) // if the remainder is 0 then indeed the variable factor is a factor
                {
                    sum += factor;
                }
            if (sum == num) // this message is displayed if the number is a perfect number
                {
                printf("%d is a perfect number \n", num);
                break;
                }
                factor++;
        }
        num++;
        sum = 0;
        factor = 1;
        }
        return 0;
    }

