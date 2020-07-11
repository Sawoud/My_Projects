#include <stdio.h>
#include <stdlib.h>
void string_copy(const char source[], char destination[], int n);
int length_string(const char source[]);

int main()
{
const char source[] = {"hello my name sam"};
char destination[15];
int n = 0;

n = length_string(source);
    string_copy(source,destination,n);
    printf("\nThank you for using my program");
    return 0;
}

void string_copy(const char source[], char destination[], int n)
{
    int N = 15; // this is the size of the destination array
    int i = 0;

    if (n<N) // this if is ecexuted if the size of the source array is smaller than the destination array
        {
            while (i < n) // this loop inputs all the charchters of source into destination
                {
                    destination[i] = source[i];
                    printf("%c",destination[i]);
                    i++;
                }
        }
        i = 0;
        if (n>N)// this if is ecexuted if the size of the source array is larger than the destination array
            {
                destination[N-1] = '\0'; // this statment inputs the NULL operator into the last space
                while (i < N-1) // this loop inputs all the charchters of source into destination
                    {
                        destination[i] = source[i];
                        printf("%c",destination[i]);
                        i++;
                    }
            }
            }




int length_string(const char source[])
{// this function is for calculating the size of a string array
    int counter = 0;
    while (source[counter] != '\0')// this while keeps going and after every itration it adds 1 to the counter until the nul operator is reached
        {
            counter++;
        }
    return (counter);
}
