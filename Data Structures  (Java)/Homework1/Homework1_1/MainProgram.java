/**
 * Tim Sternberg
 */

import java.io.*;
import java.util.Scanner;
import java.util.*;

class MainProgram
{ 
    public static String NAME_OF_FILE = "prototype.txt"; // Name of text file used for sorting
    
    public static String Ordering;
    private static ArrayList<AnyType> RawArr;
    
    private static void mainSort(SortType sort, Object dataType)
    {
        int numOfElements = 0; // Number of elements to be included in the array that will be used in the sort
        int index = 0; // Used for the indexing of the actual array that will be used in the sort
        
        for (int i=0; i<RawArr.size(); i++) // Figuring out how long the array to be sorted should be
        {
            if (RawArr.get(i).getClass() == dataType.getClass()) // If the CLASS TYPE of the current object in the arraylist is the same as the desired data type, then we +1 to the amount of elements in the array
            {
                numOfElements++; // We add one to the amount of elements in the array that will be sorted
            }
        }
        
        AnyType[] arr = new AnyType[ numOfElements ];
        for (int i=0; i<RawArr.size(); i++) // Populating the array we'll use for sorting
        {
            if (RawArr.get(i).getClass() == dataType.getClass())
            {
                arr[index] = RawArr.get(i);
                index++;
            }
        }
        
        System.out.println("------------------------\n" + sort.getNameOfSort() + "\n------------------------"); // Printing the name of the sort method, with some formatting
        System.out.print("Average: ");
        Ordering = "Ascending"; // Set the ordering to ascending
        sort.Sort(arr); // Sort the array with our desired method
        
        System.out.print("\nBest case: "); // This will be our best case because it's already sorted!
        sort.Sort(arr);
        
        System.out.print("\nWorst case: "); // This will be our worst case, since it's sorted in the exact OPPOSITE way we want it to be!
        Ordering = "Descending"; // Set the ordering to descending
        sort.Sort(arr);
        
        System.out.println(); // Simply formatting for the next sort
    }
    
    public static void main(String[] args) throws IOException
    {
        Scanner input = new Scanner( new File(NAME_OF_FILE) ); // Our data file
        RawArr = new ArrayList<AnyType>(); // Declaring the array list which will be the raw data
        String in; // Used to compare the input line if it's a string
        
        // While there's a next line available, we check to see what kind of data type it is, and add it to the AnyType arraylist
        while ( input.hasNextLine() )
        { 
            if ( input.hasNextInt() )
            {
                RawArr.add(new IntegerType( input.nextInt() ));
            }

            else if ( input.hasNextDouble() )
            {
                RawArr.add(new DoubleType( input.nextDouble() ));
            }
            else // Perhaps I need to figure out why sometimes going through there's a blank line?
            {
                if ( ! (in = input.nextLine()).equals("") ) // Making sure the input is blank or not
                RawArr.add(new StringType( in ));
            }
        }
        
        // Takes two variables, the method for sorting, and what values you want to sort
        mainSort( new BubbleSort(), new IntegerType() );
        mainSort( new SelectionSort(), new IntegerType() );
        mainSort( new InsertionSort(), new IntegerType() );
        
    }
}