class BubbleSort {
    public static void bubbleSort(AnyType[] array) {
        AnyType temp;
        int numberOfItems = array.length;
        boolean cont = true;

        for (int pass=1; pass != numberOfItems; pass++) 
        { 
            if (cont) 
            {    
                cont = false;  
                for (int index=0; index != numberOfItems-pass; index++) 
                {
                    if (array[index].isBetterThan(array[index+1])) 
                    {
                        temp = array[index];
                        array[index] = array[index+1];
                        array[index+1] = temp;
                        cont = true;
                    }  // end inner if              
                }  // end inner for            
            }
            else
                break;  // end outer if
        }      
    }      
}