#include <stdio.h>
#include <stdlib.h>

int is_diag_dom();

int main()
{
    int N = 0;
    int result = 0;
    printf("Please input the size of your matrix ");
    scanf("%d",&N);
    while (N <= 0) // this while ensures the input is greater than zero
        {
        printf("Invalid Input, Please input the size of your matrix ");
        scanf("%d",&N);
        }
    int matrix[N][N];

    for (int i = 0; i < N; i++)
        {
            for(int j = 0; j < N; j++)
                {
                    printf("Please input the value of element (%d , %d): ",i+1,j+1);
                    scanf("%d",&matrix[i][j]);
                }
        }
    result = is_diag_dom(N,matrix);
    printf ("%d\n", result);
    printf("\nThank you for using my program");
    return 0;
}

int is_diag_dom(int N,int mat[][N])
{
    int result = 1; // this value is used to determine if the matrix is diagonally dominant
    int total = 0; // this is to sum up the values of the elements
    int i = 0;
    int j = 0;
    for (i = 0;i < N;i++)
        {
            for ( j = 0; j < N ; j++)
                {
                    total = 0;
                    if (i != j) // this if statment ensures that the addition does not occur when i and j are equal
                    {
                    total += abs(mat[i][j]); // the abs ensures the absolute value of the elemnent is used

                    }
                }
            if (abs(mat[i][i])> total) // if the absolute value of (i,i) is greater than the sum of the other elements on the row then the result is 1 (TRUE)
                {
                    result = 1;
                }
            else // if the above condition is not met at somepoint then the program breaks from the inner loop ad result is equal to 0 (FALSE)
                {
                    result = 0;
                    break;
                }
            if (result == 0) // this if is present to break out of the outer loop
                {
                    break;
                }
        }
        return result;
}
