/**
 * Tim Sternberg
 */

interface AnyType 
{
    // The following two methods will be accessed by the Main Program
    public boolean isBetterThan(AnyType datum);
    public void PrintVal();
}

class IntegerType implements AnyType 
{
    private int number; // The value of the object

    IntegerType() 
    {
        number = 0;  
    }  

    IntegerType(int i) 
    {
        number = i;
    }

    public boolean isBetterThan(AnyType datum) 
    { 
        if ( MainProgram.Ordering.equals("Ascending") ) // If the ordering variable (in MainProgram) is set to Ascending, we sort in Ascending order
            return (this.number > ((IntegerType)datum).number);
        else // Otherwise, we sort in the only other way possible. Ascending!
            return (this.number < ((IntegerType)datum).number);
            
    }
    
    public void PrintVal() // This method is mainly used for debugging. Prints out the value of the object
    {
        System.out.println(number);
    }
}

class StringType implements AnyType 
{   
    private String word;

    StringType()
    {
        word = "";
    }

    StringType(String s)
    {
        word = s;
    }

    public boolean isBetterThan(AnyType datum) 
    {
        if ( MainProgram.Ordering.equals("Ascending") )
            return (this.word.compareTo(((StringType)datum).word) > 0); 
        else
            return (this.word.compareTo(((StringType)datum).word) < 0); 
    }
    
    public void PrintVal()
    {
        System.out.println(word);
    }
}

class DoubleType implements AnyType 
{   
    private double number;

    DoubleType() 
    {
        number = 0;  
    }  

    DoubleType(double i) 
    {
        number = i; 
    }

    public boolean isBetterThan(AnyType datum) 
    { 
        if ( MainProgram.Ordering.equals("Ascending") )
            return (this.number > ((DoubleType)datum).number);
        else
            return (this.number < ((DoubleType)datum).number);
            
    }
    
    public void PrintVal()
    {
        System.out.println(number);
    }
}