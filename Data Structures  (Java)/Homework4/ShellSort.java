class ShellSort implements SortType
{   
    int IncrementalSequence = 3;

    int numOfComparisons=0, numOfExchanges=0;

    public String getNameOfSort()
    {
        return "Shell Sort [Incremental Sequence: " + IncrementalSequence + "]"; // Returns the name of the sort method
    }

    private void SegmentedInsertionSort(AnyType[] array, int N, int h)
    {
        AnyType temp;
        for (int i = h; i < N; i++) {
            int j = i-h;

            while (j >= 0) {
                numOfComparisons++; // Stating that we made a comparison
                if (array[j].isBetterThan(array[j+h])) {
                    // Swapping j and j+h
                    temp = array[j];
                    array[j] = array[j+h];
                    array[j+h] = temp;

                    j -= h; // Decrimenting j by h

                    numOfExchanges++; // Stating that we made an exchange
                }
                else
                    j = -1;
            }
        }
    }

    public void Sort(AnyType[] array) {
        int h = 1;
        while (h <= array.length / IncrementalSequence) {
            h = h * IncrementalSequence + 1;
        }

        while (h > 0) {
            SegmentedInsertionSort(array, array.length, h);
            h = (h-1) / IncrementalSequence;
        }

        //         System.out.println();
        //         for (int i=0; i<array.length; i++)
        //         {
        //             array[i].PrintVal();
        //         }

        // Will print out the exchanges and comparisons when we run the Main Program
        System.out.printf("%-25s%s", "\tExchanges: " + numOfExchanges, "Comparisons: " + numOfComparisons);
        numOfComparisons=0;
        numOfExchanges=0;
    }

}
