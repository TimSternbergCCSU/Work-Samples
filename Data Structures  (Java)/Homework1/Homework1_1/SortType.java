/**
 * Tim Sternberg
 */

interface SortType
{
    // Each sort method must have (at least) two methods. 
    // One called "Sort" which will do the sort method, and can be called from the Main Program. 
    // The other getNameOfSort will return the name of the sort method to the main program
    // Notice that the sort method takes in an ARRAY not an ARRAYLIST
    public void Sort(AnyType[] array);
    public String getNameOfSort();
}

class BubbleSort implements SortType
{
    public String getNameOfSort()
    {
        return "Bubble Sort"; // Returns the name of the sort method
    }
    
    public void Sort(AnyType[] array) {
        AnyType temp;
        int numberOfItems = array.length;
        boolean cont = true;
        
        int numOfComparisons=0, numOfExchanges=0;

        for (int i=1; i != numberOfItems; i++) 
        { 
            if (cont) 
            {    
                cont = false;  
                for (int j=0; j != numberOfItems-i; j++) 
                {
                    numOfComparisons++;
                    if (array[j].isBetterThan(array[j+1])) 
                    {
                        temp = array[j];
                        array[j] = array[j+1];
                        array[j+1] = temp;
                        cont = true;
                        
                        numOfExchanges++;
                    }           
                }        
            }
            else
                break; 
        }   
        
        // Will print out the exchanges and comparisons when we run the Main Program
        System.out.printf("%-25s%s", "\tExchanges: " + numOfExchanges, "Comparisons: " + numOfComparisons);
    }      
}

class SelectionSort implements SortType
{
    public String getNameOfSort()
    {
       return "Selection Sort"; 
    }
    
    public void Sort(AnyType[] array)
    {
        AnyType temp;
        int min;
        
        int numOfComparisons=0, numOfExchanges=0;
        
        for (int i=0; i < array.length; i++)
        {
            min = i;
            for (int j = i+1; j < array.length; j++)
            {
                if (array[min].isBetterThan(array[j]))
                {
                    min = j;
                }
                
                numOfComparisons++;
            }
            temp = array[min];
            array[min] = array[i];
            array[i] = temp;
            
            numOfExchanges++;
        }
        
        System.out.printf("%-25s%s", "\tExchanges: " + numOfExchanges, "Comparisons: " + numOfComparisons);
    }
}

class InsertionSort implements SortType
{
    public String getNameOfSort()
    {
       return "Insertion Sort"; 
    }
    
    public void Sort(AnyType[] array)
    {
        AnyType current;
        int i,j;
        
        int numOfComparisons=0, numOfExchanges=0;
        
        for (i=1; i < array.length; i++)
        {
            current = array[i];
            j = i;
            
            if (! (j>0 && array[j-1].isBetterThan(current)) ) // If we didn't go through the while loop, we sill made a comparison, so we have to account for that. But ONLY if it didn't go through the loop!!!!
                numOfComparisons++;
            
            while (j>0 && array[j-1].isBetterThan(current))
            {
                array[j] = array[j-1];
                j = j-1;
                numOfExchanges++;
                numOfComparisons++;
            }
            array[j] = current;
            
        }
        
        System.out.printf("%-25s%s", "\tExchanges: " + numOfExchanges, "Comparisons: " + numOfComparisons);
    }
}