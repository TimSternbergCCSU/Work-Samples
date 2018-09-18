interface AnyType 
{
    public boolean isBetterThan(AnyType datum);
}

class IntegerType implements AnyType 
{
    private int number;

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
        return (this.number > ((IntegerType)datum).number); 
    } 

    public int toInteger() 
    {
        return number; 
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
        return (this.word.compareTo(((StringType)datum).word) > 0); 
    }

    public String toString() 
    {
        return word; 
    }
}