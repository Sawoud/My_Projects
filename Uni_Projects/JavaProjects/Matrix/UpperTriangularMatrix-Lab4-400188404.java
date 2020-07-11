/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Sawoud
 */
import java.lang.Math; 

public class UpperTriangularMatrix {
    int size;
    int[] eff;
    Matrix upTriMat;
    int n;
    
    public UpperTriangularMatrix(int n) // constructor 1
    {
        if (n <= 0) // if the size is smaller than or equal to 0 then it is set to 1
        {
            n = 1;
        }
        this.n = n;
        size = (n*(n+1)/2);
        eff = new int[size];
        for(int i = 0;i < size; i++) // effecent is filled with zeros too
        {
            eff[i] = 0;
        }
        upTriMat = new Matrix(n,n); // and an Matrix object is created to be used later
       for(int i = 0;i < n; i++)
        {
            for(int j = 0;j < n; j++)
             {
                 upTriMat.setElement(0,i,j);
             }
        }
    }
    public UpperTriangularMatrix(Matrix upTriM) throws IllegalArgumentException
    {
        eff = new int[upTriM.getrow()];// effecient is created and given the size of the matrix rows
        upTriMat = upTriM;
        size = (upTriMat.getrow() * (upTriMat.getrow()+1)/2);
        eff = new int[size];
        int counter = 0;
        this.n = upTriMat.getrow();
        int j = 0;
        if(upTriMat.isUpperTr() == false) // this is else block is present to ensure the matrix is upper triangular
        {
            throw new IllegalArgumentException ("Matrix is not upper triangular");
        }
        else
        {
            for (int i = 0; i< upTriMat.getrow(); i++) //the nested for's and if ensure only the non zero values get put in effcient in the correct order
            {
                for (j = 0; j< upTriMat.getcol(); j++)
            {
                if (upTriMat.getElement(i,j) != 0)
                {
                eff[counter++]  = upTriMat.getElement(i, j);
                }
                else {continue;}
            }
                
            }
            j++;
        }
    }
    public int getDim() // this getter just returns the dimenstion
    {
        return this.n;
    }
    public int getElement(int i, int j) throws IndexOutOfBoundsException
	{// just like in Matrix this ensure the element is inside the matrix and returns it

		if  (i <= upTriMat.getrow() && j <= upTriMat.getcol()) {
			return upTriMat.getElement(i,j);
		}
		else {
			throw new IndexOutOfBoundsException("Invalid indexes.");
		}

	}//end getElement

	public void setElement(int  x, int i, int j) throws IndexOutOfBoundsException, IllegalArgumentException
	{// agin just like in Matrix this ensure the element is inside the matrix and sets it

                if (i <= upTriMat.getrow() && j <= upTriMat.getrow() && upTriMat.getElement(i,j) == 0 && x != 0)
                {
                    throw new  IllegalArgumentException ("Incorrect argument");
                }
                else if (i <= upTriMat.getrow() && j <= upTriMat.getrow()  )
                    {
                        upTriMat.setElement(x,i,j);
                    }
                else
                    {
                        throw new IndexOutOfBoundsException ("Invalid Indexes");
                    }
}
        public Matrix fullMatrix()
        { // this function creates a new matrix called full and returns it, it gets set with the matrix values before it is returned though
            int counter = 0;
            Matrix full = new Matrix(n,n);
            for(int i = 0; i < n; i++ )
            {
                for(int j = 0; j < n; j++)
                {
                    full.setElement(upTriMat.matrixData[i][j],i,j);
                }
            }
            return full;
        }
        
        public void print1DArray() 
        {//this function just prints the 1 D effecient array
            for (int i = 0; i < size; i++)
            {
                System.out.println(eff[i]);
            }
        }
        
        public String toString()
        { // just like in matrix this function prints the full 2D array

		String output = new String(); // creates an empty string
        	for(int i = 0; i < this.n; i++){
        		for(int j = 0; j < this.n; j++){
        			output += upTriMat.getElement(i,j) + "  ";
        		}
        	output += "\n";
        	}
       		 return output;
        }
        
        public int getDet()
        {// to get the determinate this function uses a specific algorithm I created where it goes along the "Main diagonal" of effiecent
            int row = upTriMat.getrow();
            int i = 0;
            int det = 1;
        while( i < size)
        {
            det *= eff[i]; //the previous determinate value gets multiplied by the new result
            i = i + row; // the value of the row is added to i
            row--; // then the row is decreased
        }
            return det;
        }
        
        public double[] effSolve(double[] b) throws IllegalArgumentException
        {
            if(b.length != this.n) // if the size of b is not equal to the matrix dimentions then an error is thrown
            {
                 throw new IllegalArgumentException ("sizes do not match");

            }
            else if (getDet() == 0) // if the determinate is non zero then the matrix is not invertable thus it can not be solved
            {
                throw new IllegalArgumentException ("determinate is 0 ");
            }

            else
            { // this code use the back subsatiution equation to find the x array value
            double [] x = new double[b.length]; // this line creates an soloution array
            int sizex = x.length;
            int sizeb = b.length;
                x[sizex - 1] = (b[sizeb - 1]/upTriMat.matrixData[n-1][n-1]); // this line gets the value of the last x value
                double calc = 0;
                int n = 0;
                for (int i = x.length - 1; i>=0;i--) // this for loop starts performing back subsitution
                        {
                        calc = 0;
                        n = i;
                        n--;
                                for(int j = i+1; j < n; j++)
                        {
                        calc = calc + upTriMat.matrixData[i][j]*x[j];
                        }
                        x[i] = ((b[i] - calc)/upTriMat.matrixData[i][i]);
                        }
                            return x;

            }

        }

}