class BubbleSort2 
{
    public String getNameOfSort()
    {
        return "Bubble Sort"; // Returns the name of the sort method
    }
    
    public void Sort(AnyType[] array) {
        AnyType temp;
        
        int numOfComparisons=0, numOfExchanges=0;

        for (int i=1; i < array.length; i++)
        {
            for (int j=0; j < array.length-i; j++)
            {
                if (array[j].isBetterThan(array[j+1]))
                {
                    temp = array[j];
                    array[j] = array[j+1];
                    array[j+1] = temp;
                    
                    numOfExchanges++;
                }
                
                numOfComparisons++;
            }
        }
        
        // Will print out the exchanges and comparisons when we run the Main Program
        System.out.printf("%-25s%s", "\tExchanges: " + numOfExchanges, "Comparisons: " + numOfComparisons);
    }      
}