#include <stdio.h>
#include <stdlib.h>

#define N 10

int temp = 0;
void transpose (double mat[][N])
{
int temp = 0;
for(int i = 0; i< N; i++)
    {
        for(int j = 0; j< N; j++)
            {
                temp = mat[i][j];
                mat[j][i] = temp;
            }
    }
}


