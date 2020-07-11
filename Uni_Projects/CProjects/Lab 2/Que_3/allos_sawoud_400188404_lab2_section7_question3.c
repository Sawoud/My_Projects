#include <stdio.h>
#include <stdlib.h>
void print_diag (int N, int mat[][N]);
int main(void)
{
    int n = 0;
    printf("Please Input the size of your array ");
    scanf("%d",&n);

    while (n <= 0) // this loop ensure that the array size is greater than 0
        {
            printf("Invalid Input,Please Input the size of your array ");
            scanf("%d",&n);
        }
    int array [n][n];
    for(int i = 0; i<n; i++) // this loop is used to enter the elements of the array
        {
            for(int j = 0; j<n; j++)
            {
                printf("Please input the value of elment (%d,%d): ", i+1,j+1);
                scanf("%d",&array[i][j]);
            }
        }

        for(int i = 0; i<n; i++) // this loop is used to print the 2D array
        {
            for(int j = 0; j<n; j++)
            {
                printf("\t%d",array[i][j]);
            }
            printf("\n");
        }


    print_diag(n, array);
    printf("\nThank You for using my program");
    return 0;
}

void print_diag (int N, int mat[][N])
{
    int i = 0;
    int j = 0;
    for(int point = 0; point < N; point++) // this loop is to start print from the elements that are present on the left column
    { // point is used as a linear counter to stop the loop since i and j are gonna be used to allow for diagonal movment
      i = point;
      j = 0;
      while (i >= 0)
      {// this loop creates the effect of moving up right by loweing i and increasing j
          printf("%d ", mat[i][j]);
          i = i-1;
          j = j+1;
      }
    }

    for(int point = 1; point < N; point++) // this loop is to start print from the elements that are present on the bottom row
    {// point is used as a linear counter to stop the loop since i and j are gonna be used to allow for diagonal movment
      i = N-1;
      j = point;
      while (j <= N-1)
      {// this loop creates the effect of moving up right by loweing i and increasing j
          printf("%d ",mat[i][j]);
          i = i-1;
          j = j+1;

      }
    }
}


