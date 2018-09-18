class HeapSort implements SortType
{
    int numOfComparisons=0, numOfExchanges=0;
    
    public String getNameOfSort()
    {
        return "Heap Sort"; // Returns the name of the sort method
    }

    
    public void Sort(AnyType[] array) {
        
    }
}

/* LECTURES 9 & 10

heapSort (A[n], precedes)

int y := n / 2
while (y > 0) 
{
     downheap (A[n], y, precedes)
     y :=  y - 1
 }
 
 y := n
while (y > 1) 
{
    temp := A[1]
    A[1] := A[y]    
    A[y] := temp
    y := y - 1
    downheap(A[y], 1, precedes)
}

********************

downheap(A[n],j,precedes)

boolean foundSpot := false
int l := j
int key := A[l]
int k := 2 * l       // get the left child first
while (k <= n) and (! foundSpot) {
    if (k < n) and (! precedes (A[k+1], A[k]])
         k := k + 1
    if (! precedes (A[k], key))
         A[l] := A[k],     l := k,      k := 2 * l 
    else  foundSpot := true           }  // end while
A[l] := key
                                                                

*/