#include <stdio.h>
#include <stdlib.h>

int main()
{
    int len = 0;
    int num = 0;
    int num_2 = 0;

    printf("Please Input your number: ");
    scanf("%d",&num);

    while (num != 0) //this loop is present to display the number backwards
        {
            num_2 = num%10; // this line strips of the last digit

            printf("%d",num_2);
            num = num/10; // this line makes the number smaller


        }
        printf("\nThank you for using my program !!!");



    return 0;
}
