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