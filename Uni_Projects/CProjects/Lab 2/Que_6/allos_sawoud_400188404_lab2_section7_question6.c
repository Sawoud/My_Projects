#include <stdio.h>
#include <stdlib.h>

void efficient( const int source[], int val[], int pos[], int size);
void reconstruct( int source[], int m, const int val[], const int pos[], int n);
int main()
{
    int source[] = {0,0,0,4,0,0,6,0,0,0,0,0,3};
    int val[3];
    int pos [3];
    int size = 13;
    int size_v_p = 3;

    efficient(source,val,pos,size);
    reconstruct(source,size,val,pos,size_v_p);

    printf("\nThank you for using my program");
    return 0;
}
void efficient( const int source[], int val[], int pos[], int size) //this function creates the efficient arrays
{
    int counter = 0; // this variable will be used to increment the position and value array
    printf("    Position   Value\n");
    for(int i = 0; i < size; i++)
        {
            if (source[i] != 0) // if the value of the element is not zero, then the value of the position and value arrays get updated
                {
                    pos [counter] = i;
                    printf("\t%d",pos[counter]);
                    val[counter] = source[i];
                    printf("\t%d ",val[counter]);
                    counter++;
                    printf("\n");
                }
        }
}

void reconstruct( int source[], int m, const int val[], const int pos[], int n) // this function reconstruct the orignal array from the efficient arrays
{
    int counter = 0; // this variable will be used to increment the position and value array
    printf("The reconstructed array is\n");
    printf("(");
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
        printf("% d ",source[i]);

        }
            printf(")");
}

