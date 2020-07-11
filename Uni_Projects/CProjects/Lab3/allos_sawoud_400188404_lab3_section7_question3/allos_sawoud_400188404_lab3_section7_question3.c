#include <stdio.h>
#include <stdlib.h>

char **read_words(const char *input_filename, int *nPtr,int *size); //these lines define the methods to be used in this program
void sort_words(int* sizePtr,char **list);
void sort_words_2(int* sizePtr,char **list);
void output_words (int* sizePtr,char **list);

int main()
{
    char filename[128];
    int *ptr = 0;
    int *sizePtr = 0;
    printf("Please Input the name of the file containing the Strings: ");
    scanf("%123s",filename);
    char **array = read_words(filename, ptr, sizePtr);
    sort_words(sizePtr,array);
    output_words (sizePtr,array);
    printf("Thank you for using my program !!!");
    return 0;
}

char **read_words(const char *input_filename, int *nPtr,int *size)
{

    FILE * fp = fopen(input_filename,"r");
    fscanf(fp,"%d",size);//this line saves the size of the file in "size"
    char **list = calloc(*size,sizeof(char)); // this line allocates memory for the outer array
    for (int i = 0; i < *size; i++)
        {
            list[i] = calloc(1,sizeof(char)); // this line allocates memory for each part in the inner array
            fscanf(fp,"%s/n",list[i]); // this line inputs the words in the list
        }
        //nPtr = list;
        return list;
}
void sort_words(int* sizePtr,char **list)
{
    char temp = 0; //this temp variable is used to store the data for the swap
    for(int i = 1; i < *sizePtr; i++)
        {
            if((list[i][0]) < list[i-1][0]) // this if statment checks to see if the ascii value of the word preceding the word of intrest is less than it
                {
                    int j = i+1; // j will be used to go back in the list until a postion where the value of intrest is in the right postion
                    while ((list[i][0]) < list[j][0])//ie list[i][0]>=list[j][0] until a j location is found
                    {
                        j--;
                    }

                            temp = list[j]; // these lines just swap the values
                            list[j] = list[i];
                            list[i] = temp;
                }
                else
                    {
                        continue;//this else is present just incase the if is not satisfied so the code keeps going
                    }
        }
}

void sort_words_2(int* sizePtr,char **list)//this method uses the classic buuble sort
{
int boolean = 0; //this value behaves as a boolean true or false

while(!boolean)// this condtion keeps going until the list is sorted
    {
  boolean = 1;
  for(int i=1; i < *sizePtr; i++)
   {
    if(list[i-1][0] > list[i][0])
    {// this if statment checks between the two adjacent values, if the value of interst is less than the former value, then they getswapped
      char temp = list[i][0];
      list[i][0] = list[i-1][0];
      list[i-1][0] = temp;
      boolean = 0;
    }
  }
}

}

void output_words (int* sizePtr,char **list)
{
    for(int i = 0; i < *sizePtr; i++)
        {
            printf("%s\n", list[i]);//this line just takes the strings and prints them
        }
}
