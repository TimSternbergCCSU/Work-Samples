class InsertionSort2 
{
    public String getNameOfSort()
    {
       return "Insertion Sort"; 
    }
    
    public void Sort(AnyType[] array)
    {
        AnyType temp;
        
        int numOfComparisons=0, numOfExchanges=0;
        
        //System.out.println();
        //for (int i=0; i<array.length; i++)
        //{
        //    array[i].PrintVal();
        //}
        
        for (int i=1; i < array.length; i++)
        {
            for (int j=i; j > 0; j--)
            {
                if (array[j-1].isBetterThan(array[j]))
                {
                    temp = array[j];
                    array[j] = array[j-1];
                    array[j-1] = temp;
                    
                    numOfExchanges++;
                }
                
                numOfComparisons++;
            }
        }
        
        System.out.printf("%-25s%s", "\tExchanges: " + numOfExchanges, "Comparisons: " + numOfComparisons);
    }
}