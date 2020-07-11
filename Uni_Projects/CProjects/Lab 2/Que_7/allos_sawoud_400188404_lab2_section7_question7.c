#include <stdio.h>
#include <stdlib.h>

void efficient( const int source[], int val[], int pos[], int size);
int  reconstruct( int source[], int m, const int val[], const int pos[], int n);
void addEff( int val1[], int val2[], int val3[],int pos1[], int pos2[],int pos3[],int k1, int k2);

int main()
{
    int val1[] = {2,5,7};
    int val2[] = {4,6,9};
    int val3[3];
    int pos1[] = {2,3,6};
    int pos2[] = {1,4,8};
    int pos3[3];
    int k1 = 3;
    int k2 = 3;




    addEff(val1,val2, val3, pos1,pos2,pos3,k1,k2);

    printf("\nThank you for using my program");
    return 0;
}

void addEff(int val1[], int val2[], int val3[],int pos1[], int pos2[],int pos3[],int k1, int k2)
{
    int recons1[] = {};
    int recons2[] = {};
    int total[10] = {};
    reconstruct( recons1, 10, val1, pos1,k1); // this will be used to get the first sparse array
    reconstruct( recons2, 10, val2, pos2,k2);// this will be used to get the second sparse array

    for (int i = 0; i < 10; i++) // this loop will be used to add up the values of both sparce arrays
    {
        total[i] = recons1[i] + recons2[i];
    }
    for (int i = 0; i < 10; i++)
    {
        printf("%d ", total[i]);
    }
    efficient(total,val3, pos3,k1+k2); //this fnction converts the sum sparse array into a more effecient array


}




void efficient( const int source[], int val[], int pos[], int size)
{
    int counter = 0; // this variable will be used to increment the position and value array
    for(int i = 0; i < size; i++)
        {
            if (source[i] != 0) // if the value of the element is not zero, then the value of the position and value arrays get updated
                {
                    pos [counter] = i;
                    val[counter] = source[i];
                    counter++;
                    printf("\n");
                }
        }
}

int reconstruct( int source[], int m, const int val[], const int pos[], int n)
{
    int counter = 0; // this variable will be used to increment the position and value array
    printf("The reconstructed array is\n");
    for(int i = 0; i < m; i++)
        {
            if(i == pos[counter]) // this if statment inputs the non-zero values into the source array
            {
                source[i] = val[counter];
                counter++;
            }
            else // if the position is not special, then the source array just gets the zero input
            {
                source[i] = 0;
            }
        printf("%d ",source[i]);
        }
                printf("\n");
        return source;
}


