/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



public class Matrix{
        int[][]  matrixData;	// integer array to store integer data
        int   rowsNum;	// number of rows
	int   colsNum;	// number of columns

	public Matrix( int row, int col ) //constructor1
	{


		if (row <= 0) // these if statments are used if any number is less than 0
                {
                    row = 3;
                }
		if (col <= 0) 
                {
                    col = 3;
                }
                rowsNum = row; // these two lines sets the dimenstion numbers equal to the passed numbers
                colsNum = col;
                this.matrixData = new int[rowsNum][colsNum];
                for(int i = 0; i < row; i++) // these loops set each element of this = 0
                {
                    for(int j = 0; j < col; j++)
                        {
                            this.matrixData[i][j] = 0;
                        }
                }//end first constructor
        }

	public Matrix( int[][] table) // constructor2
	{
		/* constructs a matrix out of the two dimensional array table,
		   with the same number of rows, columns, and the same element in each
		 position as array table. */

		rowsNum = table.length; // these two lines set up the matrix dimentions
		colsNum = table[0].length;
		matrixData = new int[rowsNum][colsNum]; // allocates memory for the 2D array
		//loop to fill the array with values:
		for (int i=0; i<rowsNum; i++) // these loops set each element of this = 0
                {
			for(int j=0; j<colsNum; j++)
                        {
				matrixData[i][j] = table[i][j];
                        }
                }

	}//end second constructor

        public int[][] getMat() // getter for matrix
	{
            return this.matrixData;
	}
        public int getrow() // getter for row
	{
            return this.rowsNum;

	}
        public int getcol() // getter for row
	{
            return this.colsNum;
	}
        
        
        

	public int getElement(int i, int j) throws IndexOutOfBoundsException
	{
		/* if i and j are valid indices of this matrix,
		   then the element on row i and column j of this matrix
		   is returned; otherwise it throws an exception with message "Invalid indexes".*/

		if  (i <= getrow()  && j <= getcol() ) { // this statment checks if i and j are actually in the rquired range
                    int v = matrixData[i][j];
                    return matrixData[i][j];
		}
		else {
			throw new IndexOutOfBoundsException("Invalid indexes."); // this line throws an exception if they are not within range
		}

	}//end getElement

	public boolean setElement(int  x, int i, int j)
	{
	      	  /* if i and j are valid indexes of this matrix, then the element on  row i and
                       column j of this matrix is assigned the value  x and true is returned;
                       otherwise false is returned and no change in the matrix is performed */
                boolean check = true; // it is intially assumed that the element is in the matrix
                if (i <= rowsNum && j <= colsNum  ) // the if statment sets the element to whatever value if it is in the range
                    {
                        matrixData[i][j] = x;
                    }
                else
                    {
                        check = false;
                    }
                return check;
        }//end setElement

	public Matrix copy()
	{ /* returns a deep copy of this Matrix */
            Matrix m_copy = new Matrix(getrow(),getcol()); // a new matrix is created to ensure that there is no correlation between the two matrices
                for (int i=0; i<getrow(); i++) // these for loops are used to copy each elemrnt
                {
			for(int j=0; j<getcol(); j++)
                        {
                            m_copy.setElement(getElement(i,j),i,j);
                        }
                }
            return  m_copy;
	}//end copy

	public void addTo( Matrix m ) throws ArithmeticException
	{
		/*adds Matrix m to this Matrix; it throws an exception message "Invalid operation"
		  if the matrix addition is not defined*/
		if (m.getrow() == getrow() && m.getcol() == getcol() ) { // if the matrices posses the same dimentions then the additon occurs
		for (int i=0; i<rowsNum; i++)// these for loops are used to add each elemrnt
                {
			for(int j=0; j<colsNum; j++)
                        {
                            
                            matrixData[i][j] += m.matrixData[i][j];
                        }
                }	

		}
		else {
			throw new ArithmeticException("Invalid operation");
		}

	}

public Matrix subMatrix(int i, int j) throws ArithmeticException
{
      Matrix sub = new Matrix(i,j);
      if( i <= getrow() && j <= getcol()) //these if statments ensure the parmeters are either less than or equal to the size of the matrix
      {
            for (int r = 0; r < i; r++) // these for loops go until the rquired parameters to create the sub matrix
            {
                for (int w = 0; w < i; w++)
                {
                    sub.setElement(getElement(r,w),r,w);
                }
            }
      }
      else 
      {
          throw new ArithmeticException("Sub Matrix not defined");
      }
      
      return sub;

}
            public boolean isUpperTr()
            {
                boolean isUp = true;
                int i,j;
                for(j = 1; j < getrow(); j++)// the two loops are orginised in a way where they only go along the left of the main diagonal
                {
                        if(isUp == false) // this is present to break out of the for loop
                        {
                            break;
                        }
                    for(i = 0; i < j; i++)
                    {
                        if(getElement(j,i) != 0) // if any element in that region is found to be not 0 then isUp is false and the loop is exited
                        {
                            isUp = false;
                            break;
                        }
                        else
                    {
                        isUp = true;
                    }
                    }

                }  
                return isUp;
            }



	public String toString()
	{
		/* returns a string representing the matrix,
		   with each row on a line, and the elements in each row being separated by 2 blank spaces. */

		String output = new String(); //creates a new string
        	output = "";// creates an empty string
                for(int i = 0; i < rowsNum; i++){ // the two loops go through each element and copy it to the string
        		for(int j = 0; j < colsNum; j++){
        			output = output + getElement(i,j) + "  ";
        		}
        	output += "\n";
        	}
       		 return output;

	}//end toString

	// write the remaining methods


        public static Matrix sum(Matrix[] matArray) throws ArithmeticException
        {
            int row = matArray[0].rowsNum;// these two lines get the diminestion of the array
            int col = matArray[0].colsNum;
            
            Matrix add = new Matrix(row, col);
            for(int i = 0;i < matArray.length; i++)//this loop goes through the array of matrices and lets addTo do the rest
            {
                add.addTo(matArray[i]);
            }
            return add;

        }
        
        
        
        
}