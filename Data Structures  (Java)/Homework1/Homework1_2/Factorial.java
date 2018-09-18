
/**
 * Tim Sternberg
 */

import java.io.*;

public class Factorial
{
    private static int CalcFactorial(int n)
    {
        // Multiply the current n value by essentially the number 1 less. Will keep going until n == 0
        if (n==0) 
            return 1;
        else
            return n * CalcFactorial(n-1);
    }
    
    public static void main(String[] args) throws IOException
    {
        int Factorial = 5; // Factorial we're trying to calculate
        System.out.println( CalcFactorial(Factorial) );
    }
}
