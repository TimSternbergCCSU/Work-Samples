class QuickSort implements SortType
{
    int numOfComparisons=0, numOfExchanges=0;
    
    public String getNameOfSort()
    {
        return "Quick Sort"; // Returns the name of the sort method
    }
    
    private int Partition(AnyType[] array, int low, int high) {
        AnyType pivot = array[low];
        
        while (low < high) {
            while ( array[high].isBetterThan( pivot ) && low<high ) {
                numOfComparisons++;
                high--;
            }
            numOfComparisons++;
            
            numOfComparisons++;
            if (low != high) {
                numOfExchanges++;
                array[low] = array[high];
                low++;
            }
            
            numOfComparisons++;
            while ( pivot.isBetterThan( array[low] ) && low<high ) {
                low++;
                numOfComparisons++;
            }
            
            numOfComparisons++;
            if (low != high) {
                numOfExchanges++;
                array[high] = array[low];
                high--;
            }
        }
        numOfExchanges++;
        array[high] = pivot;
        
        return high;
    }
    
    private void QuickSort(AnyType[] array, int low, int high) {
        int pivotPoint = Partition(array, low, high);
        
        if (low < pivotPoint)
            QuickSort(array, low, pivotPoint-1);
            
        if (high > pivotPoint)
            QuickSort(array, pivotPoint+1, high);
    }
    
    public void Sort(AnyType[] array) {
        QuickSort(array, 0, array.length-1);
        
        // Will print out the exchanges and comparisons when we run the Main Program
        System.out.printf("%-25s%s", "\tExchanges: " + numOfExchanges, "Comparisons: " + numOfComparisons);
        numOfExchanges = 0;
        numOfComparisons = 0;
        
//         System.out.println();
//         for (int i=0; i<array.length; i++)
//         {
//             array[i].PrintVal();
//         }
//         System.out.println();
    }      
}
