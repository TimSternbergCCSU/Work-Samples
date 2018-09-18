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