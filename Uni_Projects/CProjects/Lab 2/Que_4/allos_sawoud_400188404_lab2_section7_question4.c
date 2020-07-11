#include <stdio.h>
#include <stdlib.h>
void letter_freq(const char word[], int freq []);
int main()
{
    const char word[] = {};
    int freq [26] = {};

    printf("Please Input your string ");
    gets(word);
    letter_freq(word,freq);
        printf("\n");
        for (int j = 0; j < 26; j++)
        {
            printf("'%c' or '%c': %d \n",65+j, 97+j ,freq[j]);// this line prints the letter (uppercase, lowercase), and the number of occurances of the letter
        }
        printf("\nThank you for using my program");

return 0;
    }


void letter_freq(const char word[], int freq [])
{
    int i = 0;
    int val = 0; // this variable is used to store the intger value of the charchter
    int abs_val = 0;// this variable is used to store the absolute value of the diffrence between the charchter and 'a'

    while(word[i] != '\0') //this loop keeps running until the null operator is reached
    {
     val = 0;
     val = word[i];
        if (val <= 95 && val>=65) // this is for an uppercase letter
        {
            abs_val = abs(val - 'A'); // this line gets the number of the letter
            freq[abs_val] += 1; // this line adds 1 when ever the charchter is found
        }
        if (val <= 122 && val>=97) // this is for an lowercase letter
        {
            abs_val = abs(val - 'a'); // this line gets the number of the letter
            freq[abs_val] += 1; // this line adds 1 when ever the charchter is found
        }
        i++;
    }
    }

