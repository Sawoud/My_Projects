#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *my_strcat( const char * const str1, const char * const str2);

int main()
{
char str_1[20];
char str_2[20];


printf("\nPlease input your first word: ");
scanf("%s",&str_1);
printf("\nPlease input your second word: ");
scanf("%s",&str_2);
my_strcat( str_1, str_2 );

printf("\nThank you for using my program !!!");

return 0;
}

char * my_strcat( const char * const str1, const char * const str2)//this function concatnates the string
{
int len1 = 0;
int len2 = 0;
int lent = 0;

len1 = (strlen(str1)); // these 3 lines get the length of each string
len2 = (strlen(str2)) ;
lent = len1 + len2 + 1 ;
char * string_cat = calloc(lent, sizeof(char)); // allocates and sets to zero the memory for the length of the string

for (int i = 0; i< lent; i++) // this for loop is used to concatnate the string
    {
        if(i < len1)// the if-else block adds each charchter from each string to the new string
        {//this line puts the charchter value of string 1 at desired postion into the desired position in the new string
            *(string_cat + i) = *(str1 + i);
        }
        else
        {//this line puts the charchter value of string 2 at desired postion into the desired position in the new string
            *(string_cat + i) = *(str2 + i - len1);
        }

           }
        printf("The concatnated string is: %s",string_cat);

return string_cat;
}
