#include <stdio.h>
#include <stdlib.h>

void print_vector(double array[], int size);
void add_vectors( double vector1[],double vector2[],double vector3[], int n);
float scalar_prod();
float norm_2( double vector1[], double vector3[],int n);

int main()
{
    int n = 0;

    printf("Please input how many components you would like to have in your arrays: ");
    scanf("%d",&n);
    while(n <= 0) // this while is present to ensure the input is not smaller than zero
        {
        printf("\nInvalid Input, has to be greater than 0 ");
        scanf("%d",&n);
        }
    double vector[n];

            printf("First Array:");
    for (int i = 0; i < n; i++) // this loop is for the inputs of the first array
        {
            printf("\nPlease input the value of component: %d:", (i+1) );
            scanf("%lf",&vector[i]);
        }


    double vector_2[n];

    printf("\nSecond Array:");
    for (int i = 0; i < n; i++) // this loop is for the inputs of the second array
        {
            printf("\nPlease input the value of component: %d:", (i+1) );
            scanf("%lf",&vector_2[i]);
        }

         printf("Vector 1:\n");
         print_vector(vector,n);
         printf("\nVector 2:\n");
         print_vector(vector_2,n);

         double vector_3[n];

         printf("\nAdd Vectors::\n");
        add_vectors(vector,vector_2,vector_3,n);
         printf("\nScalar Product:\n");
         scalar_prod(vector,vector_2,vector_3,n);
         norm_2(vector,vector_3,n);
         printf("\n");
         printf("Thank you for using my program");
    return 0;
}

void print_vector(double array[], int size) //this function prints out the array via for loop
{
    for (int i = 0; i<size; i++)
    {
        printf("%f ", array[i]);
    }
    }

void add_vectors( double vector1[],double vector2[], double vector3[],int n) //this function adds up the vectors by adding their componets via for loop
{
    for (int i = 0; i<n; i++)
    {
        vector3[i] = vector1[i] + vector2[i];
        printf("%f ", vector3[i]);
    }
}

float scalar_prod( double vector1[],double vector2[], double vector3[],int n)
{ // this function uses a for loop and multiplies each element with the corrosponding element from the other array
    float scalar = 0;
    for (int i = 0; i<n; i++)
    {
        vector3[i] = vector1[i] * vector2[i];
        scalar += vector3[i];
    }
            printf("%f", scalar);

    return scalar;
}

float norm_2( double vector1[], double vector2[],int n)
{ //this function uses the scalar_prod function to get the result so that it can be square rooted
    float scalar = 0;
    float L2 = 0;
    printf("\nScalar Product for Norm:\n");
    scalar = scalar_prod(vector1,vector1, vector2, n);
    L2 = sqrt(scalar);
    printf("\nNorm:\n");
    printf("%f",L2 );
    return L2;
}

