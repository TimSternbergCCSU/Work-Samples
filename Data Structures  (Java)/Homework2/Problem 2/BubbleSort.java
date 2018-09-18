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
