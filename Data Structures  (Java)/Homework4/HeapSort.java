class HeapSort implements SortType
{
    int numOfComparisons=0, numOfExchanges=0;
    
    public String getNameOfSort()
    {
        return "Heap Sort"; // Returns the name of the sort method
    }
    
    public void downheap(AnyType[] array, int j, int n) {
        boolean foundSpot = false;
        AnyType key = array[j];
        int k = 2*j; // get the left child first
        
        while (k <= n && !foundSpot) {
            numOfComparisons++;
            if(k < n && array[k+1].isBetterThan(array[k]))
                k++;
            if (array[k].isBetterThan(key)) {
                array[j] = array[k];
                j = k;
                k = 2*k;
                numOfExchanges++;
            }
            else
                foundSpot = true;
        }
        
        array[j] = key;
    }    
    
    public void Sort(AnyType[] array) {
        int n = array.length-1;
        int y = n/2;
        while (y >= 0) {
            downheap(array,y,n);
            y--;
        }
        
        y = n;
        while (y > 0) {
            AnyType temp = array[0];
            array[0] = array[y];
            array[y] = temp;
            y--;
            downheap(array,0,y);
            numOfExchanges++;
        }
        
        System.out.printf("%-25s%s", "\tExchanges: " + numOfExchanges, "Comparisons: " + numOfComparisons);
        numOfExchanges = 0;
        numOfComparisons = 0;
        
        // System.out.println();
        // for (int i=0; i<array.length; i++)
        // {
            // array[i].PrintVal();
        // }
        // System.out.println();
    }
}