
/**
 * Tim Sternberg
 */

import java.io.*;

public class Fibonacci
{
    private static int CalcFibonacci(int n)
    {  
        // Goes down the recursive tree from original n, going until n == 0 or n == 1, and adds all those values up together, resulting in our fibonacci number!
        if (n <= 1)
            return n;
        else
            return CalcFibonacci(n - 1) + CalcFibonacci(n - 2);
    }
    
    public static void main(String[] args) throws IOException
    {
        int n = 11; // We're assuming the sequence {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ...}
        
        System.out.println( CalcFibonacci(n) );
    }
}
