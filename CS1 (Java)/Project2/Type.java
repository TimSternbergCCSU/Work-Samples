
/**
 * Boolean methods to check if a string is Integer or Double
 * @author Zdravko Markov 
 * @version 2-22-2009
 */
public class Type
{

  public static boolean isInteger(String s)
  {  
    try
    {
        Integer.parseInt(s);  
        return true;  
    }  
    catch(NumberFormatException e)  
    {  
        return false;  
    }  
  }
  
  public static boolean isDouble(String s)
  {  
    try
    {
        Double.parseDouble(s);  
        return true;  
    }  
    catch(NumberFormatException e)  
    {  
        return false;  
    }  
  }
  
}