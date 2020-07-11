/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Sawoud
 */
public class SLLSet { // this is the linked list class
    int size;
    SLLNode ref;
    int last;// this stores the last value in the list
    public SLLSet() // this class constructs the empty list class
    {
        size = 0;
        ref = null;
    }
    public SLLSet(int s, SLLNode v) // this class constructs the list when given a size and a node only
    {
        size = s;
        ref = new SLLNode(v.value,v.next);
    }
    
    

    public SLLSet(int [] sortedArray) // this line constructs the list when given an array
    {
        size = sortedArray.length; // these 3 lines set the size of the list equal to the length of the array
        if(size == 0) // this is present just incase the array is empty
        {
            new SLLSet();
        }
        else{
        SLLNode temp;//this temparory list will be used later
        ref = new SLLNode(sortedArray[0],null);// this line creates a head node
        SLLNode temp_ref = ref;
        for (int i = 1; i < size; i++) // this loop goes through each elment of the array to put it into the list
        {
             temp = new SLLNode(sortedArray[i],null); // this temp variable stores the next node
             temp_ref.next = temp; // this line sets the next element in the node equal to the next value
             temp_ref = temp_ref.next;
             if (i == size - 1) // this if statment is just present to keep a record of what the last value is becasue it will be needed later
             {
                 this.last = temp.value;
             }
        }
        }
    }
    
    
    public int getSize() // this functions returns this size
    {
        return this.size;
    }
    public SLLSet copy() // this function uses one of the constructors to create a deep copy of the node
    {
        SLLSet cop_y;
        int [] copy = new int[size]; // this array is used to store the values of the this set
        SLLNode temp = this.ref; // this temp is used to keep the orginal head un -mutated
        int i = 0;
        while(temp != null)
        {// this loop goes through the list and puts each value into the array
            copy[i] = temp.value;
            temp = temp.next;
            i++;
        }
        cop_y = new SLLSet(copy); // this line creats the copy array
        
        return cop_y;
    }
    public boolean isIn(int v)
    {
        boolean exist = false; // it is assumed that the value is not in the list
        SLLNode temp = ref; // this line is present to ensure the orignal pointer is not lost
        if (size == 0)
        {
            exist = false;
        }
        else{
        if(v == last)
        {
            exist = true;
        }
        else if(v == ref.value)
        {
            exist = true;
        }
        else{
        while(temp.next != null) // this loop keeps going until the tail is reached
        {
            if (temp.value == v) // when the value is found exist becomes true and the loop in exited
            {
                exist = true;
                break;
            }
            temp = temp.next;
        }
        }
        }
        return exist;
    }
    
    public void add(int v)
    {
        if (isIn(v) == true)
        {
            int temp = 0;
        }
        else
        {
            this.size++;
            if (v < this.ref.value)// this if statment is used when the supplied data is less than the head value
            {
                SLLNode NEW; 
                NEW = new SLLNode(v,this.ref); 
                NEW.value = v;//the new node is getting the value of v
                NEW.next = this.ref;//the old head is being moved to the second node
                this.ref = NEW;//the new node is becoming the head
            }
            else if (v > this.last) { // this block is activated if the value supplied is greater than the last value
            SLLNode temp2;
            SLLNode temp = ref; // this variable is used to ensure the link to the head is always known
            last = v; // the last value is updated to v
            while (temp != null) // when the end of the list is reached
            {
                temp = temp.next;//again this is used to cycle through the list
                if(temp.next == null) // once the tail is near this if block gets activated
                {
                    temp.next = new SLLNode(v,null); // this node replaceses null
                    break;
                }
            }
        }
            else // if the element is between this block gets activated
            {
            SLLNode temp = ref;// this variable is used to ensure the link to the head is always known
            SLLNode temp2;
            while (ref != null)
            {
                if(temp.next.value > v)//again this is used to cycle through the list
                {
                    temp.next = new SLLNode(v,temp.next);// this line inserts the node in the desired position
                    break;
                }
                temp = temp.next;

            }

            }
    }
    }
    public void remove(int v)
    {
        if(isIn(v) == false) // if the node is not present the program doesnot even bother
        {
            int temp = 0;
        }
        else
        {
            size--;
            if(ref.value == v) // if the node is the first value...
            {
                ref = ref.next;//...then the head just gets moved to the second node
            }
            else if(last == v)// if the node is the last node
            {
                SLLNode temp = ref;
                while (temp != null) // then it just gets replaced by null
                {
                    if(temp.next.value == v)
                    {
                        temp.next = null;
                    }
                    temp = temp.next;
                }
            }
            else
            { //when the node is in between
                SLLNode temp = ref;
                while(temp != null){
                if(temp.next.value == v)
                {
                    temp.next = temp.next.next; // this line cuts the connection between the two nodes
                    break;
                }
                temp = temp.next;
                }
            }
        }

        }
        public SLLSet union(SLLSet s)
        {

            int size = 0; // this variable will be used for the union array
            SLLSet united = null; // this array will be used to get the union
                if(s.size == 0) // if the passed value is the empty list...
                {//... then the united array is bassically the this set
                    united = new SLLSet(this.size,this.ref);
                }
                if(this.size == 0)// if this is the empty list...
                {//... then the united array is bassically the passed value
                    united = new SLLSet(s.size,s.ref);
                }
                else{
            size = this.size + s.size; // it is assuemd that the united array will be the sum of both lists
            SLLNode temp_s = s.ref;
                while (temp_s != null)
                { // if there is an element present between the lists, then the size is decreased 
                    if(isIn(temp_s.value) == true)
                    {
                        size--;
                    }
                    temp_s = temp_s.next;
                }
                 temp_s = s.ref;
                 
                while (temp_s != null)
                { // this section adds the values to create the union list, add already checks presence and order
                    add(temp_s.value);
                    temp_s = temp_s.next;   
                }
                united = new SLLSet(size,this.ref);

                }
            return united;   
            
         }
        public SLLSet intersection(SLLSet s)
        {

            int size = 0; // this variable will store the size of the intersection array
            SLLSet inter;
            if(s.size == 0 || this.size == 0) 
            {// if either of the lists are empty then the null list is returned since no inersections exist
                inter = new SLLSet();
            }
            else{ 
            SLLNode temp_s = s.ref;
            while (temp_s != null)// this loop cycles through the Set to get its size(ie how many elements intersect)
            {
                if(isIn(temp_s.value) == true)
                {
                    size++;
                }
                temp_s = temp_s.next;
            }

            temp_s = s.ref;
            int[] here = new int[size];
            int counter = 0;
            while (temp_s != null) // this loop is present to fill the array with the values that actually intersect
            {
                if(isIn(temp_s.value) == true) // if the elements intersect they get added to the array
                {
                    here[counter] = temp_s.value;
                    counter++;
                }
                temp_s = temp_s.next;
            }

            inter = new SLLSet(here);//the inersection set in created

            }
            return inter;
        }
        public SLLSet difference(SLLSet s)
        {
            int size = 0; // this variable will store the size of the intersection array
            SLLSet diff;
            if(s.size == 0 || this.size == 0) 
            {// if either of the lists are empty then the null list is returned since no operation can be done to get the diffrence
                diff = new SLLSet();
            }
            else{ 
            SLLNode temp_s = s.ref;
            while (temp_s != null)// this loop cycles through the Set to get its size(ie how many elements do not intersect)
            {
                if(isIn(temp_s.value) != true)
                {
                    size++;
                }
                temp_s = temp_s.next;
            }

            temp_s = s.ref;
            int[] not_here = new int[size];
            int counter = 0;
            while (temp_s != null) // this loop is present to fill the array with the values that do not intersect
            {
                if(isIn(temp_s.value) != true) // if the elements do not intersect they get added to the array
                {
                    not_here[counter] = temp_s.value; 
                    counter++;
                }
                temp_s = temp_s.next;
            }

            diff = new SLLSet(not_here);//the diffrence set in created

        }
            return diff;
        }
        
        public static SLLSet union(SLLSet[] sArray)
        {
            int sizeA= sArray.length;
            SLLSet united = sArray[0]; // this set is equal to the first set in the sArray
            for(int i = 0; i < sizeA; i++)//this for loop goes through all the values of the set array and sends them to union
            {
                united.union(sArray[i]);
            }
            return united;  
}


        public String toString()
        {
            String s = "";
            SLLNode temp = ref;
            while(temp != null) // this while loop is designed to go through all the values of the set
            {
                s = s + temp.value + " "; // this line adds the values of each node to the string 
                temp = temp.next;
            }
            return s;
        }
}

  













  
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Sawoud
 */
class SLLNode { // this class is for the nodes of a linked list
    
    int value;
    SLLNode next;
    public SLLNode(int i, SLLNode n)// this class constucts the linked list
    {
        value = i;
        next = n;
    }
}









*****************************************Output***************************************************

cd C:\Users\Sawoud\Documents\NetBeansProjects\Lab5; "JAVA_HOME=C:\\Program Files\\Java\\jdk-13" cmd /c "\"\"C:\\Program Files\\NetBeans-11.1\\netbeans\\java\\maven\\bin\\mvn.cmd\" -Dexec.args=\"-classpath %classpath TsetClass\" -Dexec.executable=\"C:\\Program Files\\Java\\jdk-13\\bin\\java.exe\" -Dmaven.ext.class.path=\"C:\\Program Files\\NetBeans-11.1\\netbeans\\java\\maven-nblib\\netbeans-eventspy.jar\" -Dfile.encoding=UTF-8 process-classes org.codehaus.mojo:exec-maven-plugin:1.5.0:exec\""
Scanning for projects...
                                                                        
------------------------------------------------------------------------
Building Lab5 1.0-SNAPSHOT
------------------------------------------------------------------------

--- maven-resources-plugin:2.6:resources (default-resources) @ Lab5 ---
Using 'UTF-8' encoding to copy filtered resources.
skip non existing resourceDirectory C:\Users\Sawoud\Documents\NetBeansProjects\Lab5\src\main\resources

--- maven-compiler-plugin:3.1:compile (default-compile) @ Lab5 ---
Nothing to compile - all classes are up to date

--- exec-maven-plugin:1.5.0:exec (default-cli) @ Lab5 ---
Test 1 - Constructor 1:
List:

size = 0
*************************************************************
Test 2 - Constructor 2 (sorted input):
List:
1 2 3 7 8 
size=5
*************************************************************
Test 3 - Copy(Change in copy should not affect the initial set):
Copy List:
1 2 3 7 8 100 
size=6
Initial List:
1 2 3 7 8 
size=5
*************************************************************
Test 4 - isIn(in):
2 is in the list?
true
*************************************************************
Test 5 - isIn(not in):
0 is in the list?
false
*************************************************************
Test 6 - add(the value is in the list, then do nothing):  3
List:
1 2 3 7 8 
size=5
*************************************************************
Test 7 - add(middle):  4
List:
1 2 3 4 7 8 
size=6
*************************************************************
Test 8 - add(last):  9
List:
1 2 3 4 7 8 9 
size=7
*************************************************************
Test 9 - add(first): 0
List:
0 1 2 3 4 7 8 9 
size=8
*************************************************************
Test 10 - remove(the value is not in the list, then do nothing):  10
List:
1 2 3 7 8 
size=5
*************************************************************
Test 11 - remove(middle):  3
List:
1 2 7 8 
size=4
*************************************************************
Test 12 - remove(last):  8
List:
1 2 7 
size=3
*************************************************************
Test 13 - remove(first):  1
List:
2 7 
size=2
*************************************************************
Test 14 - remove(from empty list):  1
List:

size=0
*************************************************************
Test 15 - union(s list is empty):
List:
1 2 3 7 8 
size=5
*************************************************************
Test 16 - union():
List:
0 1 2 3 7 8 10 20 
size=8
This list is: 0 1 2 3 7 8 10 20 
s list is: 0 2 3 8 10 20 
*************************************************************
Test 17 - union():
List:
0 1 2 3 7 8 10 20 
size=8
This list is: 0 1 2 3 7 8 10 20 
s list is: 0 2 3 
*************************************************************
Test 18 - union(this list is empty):
List:
0 1 2 3 7 8 10 20 
size=8
*************************************************************
Test 19 - intersection(s list is empty):
List:

size=0
*************************************************************
Test 20 - intersection():
List:
2 7 
size=2
This list is: 1 2 3 7 8 
s list is: 0 2 7 
*************************************************************
Test 21 - intersection():
List:
1 3 8 
size=3
This list is: 1 2 3 7 8 
s list is: 1 3 5 6 8 10 
*************************************************************
Test 22 - intersection(no elements in common):
List:

size=0
This list is: 1 2 3 7 8 
s list is: 0 10 100 
*************************************************************
Test 23 - intersection(this list is empty):
List:

size=0
*************************************************************
Test 24 - difference(s list is empty):
List:

size=0
*************************************************************
Test 25 - difference(this list is in s list):
List:
5 9 
size=2
This list is: 1 2 3 7 8 
s list is: 1 2 3 5 7 8 9 
*************************************************************
Test 26 - difference():
List:

size=0
This list is: 1 2 3 7 8 
s list is: 1 2 3 
*************************************************************
Test 27 - difference(this list is empty):
List:

size=0
*************************************************************
Test 28 - union(sArray):
List:
0 1 2 3 4 6 7 
size=7
*************************************************************
------------------------------------------------------------------------
BUILD SUCCESS
------------------------------------------------------------------------

