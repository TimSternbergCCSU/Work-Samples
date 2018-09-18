class PrototypeProgram
{ 
    public static void main(String[] args)
    {
        AnyType[] arr = new AnyType[5];
        
        for (int i=arr.length-1; i>=0; i--)
        {
            arr[i] = new IntegerType( i*2 );
            System.out.println("Value: " + ((IntegerType)arr[i]).toInteger() );
        }
        
        BubbleSort.bubbleSort(arr);
        
        System.out.println();
        for (int i=0; i<arr.length; i++)
            System.out.println("Value: " + ( (IntegerType)arr[i] ).toInteger() );
    }
}