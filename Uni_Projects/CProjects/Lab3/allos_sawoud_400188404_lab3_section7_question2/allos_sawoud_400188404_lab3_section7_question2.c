#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
typedef struct // this section defines the student "type"
{
    int stdnum;
    char fname[15];
    char lname[15];
    int proj1;
    int proj2;
    float mark;
}student;

student **create_class_list( char *filename, int *sizePtr); // these lines define the methods that will be used in this program
int find(int idNo, student **list, int size);
void input_grades(char *filename, student **list, int size);
void compute_final_course_grades(student **list,int size);
void output_final_course_grades (char * filename,student **list,int *size);
void print_list( student **list, int *size);
void withdraw(int idNo, student **list, int *sizePtr);
void destroy_list(student **list, int *sizePtr);


int main()
{
    int size = 0;
    int *ptr = &size;
    char filename[128];
    char filename2[128];
    char filename3[128];
    int stdno = 0;
    int location = 0;

    printf("Please Input the name of the file containing the class list: ");
    scanf("%123s",filename);
    strcat(filename,".txt");
        if( access( filename, F_OK ) != -1 ) // this if checks whether the file exists or not
{
    student ** array = create_class_list(filename, ptr);
    printf("Please Input the student number of the student you would like to find: ");
    scanf("%d",&stdno);
    location = find(stdno,array , size);
    printf("The student is present at location: %d",location);

    printf("\nPlease Input the name of the file containing the projects grades: ");
    scanf("%123s",filename2);
    strcat(filename2,".txt");

    if( access( filename2, F_OK ) != -1 )// this if checks whether the file exists or not
        {
    input_grades(filename2, array, *ptr);


    printf("Please Input the name of the file which you would like to print the marks to: ");
    scanf("%123s",filename3);
    strcat(filename3,".txt");
    compute_final_course_grades(array, *ptr);
    output_final_course_grades(filename3,array, ptr);
    print_list(array, ptr);
    printf("Please input the number of the student who would like to widthraw: ");
    scanf("%d",&stdno);

    withdraw(stdno, array, &size);
    print_list(array, &size);

     destroy_list(array, &size);
     print_list(array, &size);
    }

    else
        {
            printf("File Does Not Exist");
        }
    }

    else
        {
            printf("File Does Not Exist");
        }
            printf("\nThank you for using my program !!!");

    return 0;

}






student **create_class_list( char *filename, int *sizePtr)
{

    int num = 0;
    FILE * fp = fopen(filename, "r"); //this line opens filename in read mode, and stores the value of its contents in pointer fp
    fscanf(fp,"%d",sizePtr);

    student ** student_matrix = calloc(*sizePtr,sizeof(student));//this line is used to declare the student structure

    for (int i = 0; i < *sizePtr; i++)//this loop inputs all of the required values if the student_matrix
    {
        student_matrix [i] = calloc(1,sizeof(student));// this second calloc is used to reserve and set to 0 the values of the inner arrays
        fscanf(fp,"%d %s %s \n", &(student_matrix[i] -> stdnum), &(student_matrix[i] -> fname), &(student_matrix[i] -> lname));
    }

    fclose(fp);// this line closes the file so that it can not be altered any furthur


    return student_matrix;
}





int find( int idNo, student **list, int size )
{
   int location = 0;
   for (int i = 0; i < size; i++)// this loop is used to cycle through every student id on the list
    {
        if ( (list[i] ->stdnum) == idNo) //this if else block is used to check at which postion the student id is located and breaks out of the loop
        {
            location = i;
            break;
        }
        else
        {
            location = -1; //if nothing is found the -1 is returned to symbolize it
        }
        }
        return location;
    }





void input_grades(char *filename, student **list, int size)
{
    int location = 0;
    int num = 0;
    FILE * fp = fopen(filename, "r"); //this line is used to open the file
    student ** marks = calloc(size,sizeof(student)); //calloc is used to allocate and clear a marks array

    for (int i = 0; i < size; i++) // this for loop is to cycle through the file
    {

        marks [i] = calloc(1,sizeof(student)); //this allocates the inner pointers array
        fscanf(fp,"%d %d %d\n", &(marks[i] -> stdnum),&(marks[i] -> proj1),&(marks[i] -> proj2)); // this line reads the value of the student number and marks
    }
    fclose(fp); //this line closes file to prevent further changes


    for (int i =0; i < size; i++) // this section is used to attach the student numbers to the correct postion on the main list
        {
           location = find((marks[i] -> stdnum),list,size); // this line is used to find the location of the student

                if (location != -1) // this is block gets excecuted if the location ecists
                {
                (list[location] ->  proj1) = (marks[i] -> proj1);
                (list[location] ->  proj2) = (marks[i] -> proj2);
                }
                else
                {
                continue;
                }
           }
        }


            void compute_final_course_grades(student **list,int size)
            {

                for (int i = 0; i < size; i++) //this for loop calculates the final mark and attaches it to the main list
                    {
                        (list[i]-> mark) = ((list[i]-> proj1) + (list[i]-> proj2))/2.0;
                    }
            }


void output_final_course_grades (char * filename,student **list,int *size)
            {
            FILE * fp=fopen(filename,"w");//this line opens the file
            fprintf(fp,"%d\n",*size);//this line prints the size of the list to the file
            for (int i = 0; i < *size; i++) //this loop prints the student numbers with the rounded marks to the file
                    {
                        fprintf(fp,"%d %.01f\n", (list[i] -> stdnum), (list[i] -> mark));
                    }
            fclose(fp); // this line closes the file to avoid furthur alteration

            }

void print_list( student **list, int *size)
{
    for (int i = 0; i < *size; i++)//this for loop goes through each student in the list and prints their information
        {
            printf("ID: %d name: %s %s project 1 grade: %d project 2 grade: %d  final grade: %.01f\n", (list[i] -> stdnum), (list[i] -> fname),(list[i] -> lname),(list[i] -> proj1),(list[i] -> proj2),(list[i] -> mark));
        }
        return ;
}

void withdraw(int idNo, student **list, int *sizePtr)
{
    int location  = 0;
    int i  = 0;
    location = find(idNo,list,*sizePtr); // this line finds the location of the student that wishes to widthraw
    if (location != -1)
    {


    free((list[location])); // this line frees that location
    i = location; // i starts at location becasue we do now want to change any information before it
    while (i < *sizePtr - 1) // this while loop switches the information lists
      {
          list[i] = list[i+1];
          i++;

      }

                free(&(list[*sizePtr]));
               *sizePtr = *sizePtr - 1 ; // this line decreases the size



    }
    else
        {
            printf("That Student does not exist\n");
        }

}

void destroy_list(student **list, int *sizePtr)
{
    for(int i = 0;i < *sizePtr; i++)
    {
        free((list[i])); // this line frees the position that is no longer needed
    }
    *sizePtr = 0;
}

