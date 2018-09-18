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