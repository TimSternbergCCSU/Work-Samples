/**
 * Name: Tim Sternberg
 * Email: tsternberg@my.ccsu.edu
 * Class: CS 151 - Computer Science
 * Section: 01
 */

import java.util.Scanner;
public class Computations
{
    private static String GenerateStars(int value) // private class used to generate stars. Takes an integer input and returns that many stars as a string
    {
        String stars = ""; // Declaring the stars string
        
        for (int n=1; n<= value; n++)  // Goes through a for loop depending on the integer "value"
            stars = stars + "*"; // Add a star
        
        return stars;
    }
    
    
    public static void main (String[] args)
    {
        int n = 0, dcount = 0, acount = 0, pcount = 0, prime = 0; // declaring all integer values within the table
        int sigma; // Declaring sigma value here. Will be reset to 0 within each do statement
        int f; // Declaring f value here so that it doesn't have to keep being declared within the do statement
        int conditionvalue = 0; // Used for printing the graph. It's the specified condition's value
        
        String condition,evaluator,rawvalue; // Raw input string values
        int value; // This is the value that the person specifies to the conditions, converted to an integer so that it can be used for calculations
        
        boolean stop = false; // This is what will be used to tell the do loop to stop
        
        Scanner scan = new Scanner(System.in); // Declaring scanner
        System.out.println("Enter your condition and a positive integer in the form of \"Condition = value\": "); // Explanation of what to input
        
        // Scanning for three inputs. The condition, evaluator (which should be =) and the value
        condition = scan.next().toLowerCase(); // the toLowerCase statement is to rule out any erros in the case
        evaluator = scan.next(); // This should be "="
        rawvalue = scan.next(); // Value of the condition
        
        System.out.println(); // Putting a space after the input for formatting
        
        // If the value that is inputted is an integer, that integer is greater than 0, the word after is an "=", and there's a valid condition then go through the statement
        // If it's a valid condition, ithe string is either "limit" or "deficient" or "abundant" or "perfect" or "prime"
        if ( Type.isInteger(rawvalue) && (Integer.parseInt(rawvalue) > 0) && (evaluator.equals("=")) && (condition.equals("limit") || 
                                                                                                         condition.equals("deficient") || 
                                                                                                         condition.equals("abundant") ||
                                                                                                         condition.equals("perfect") || 
                                                                                                         condition.equals("prime")
                                                                                                        ) )
        {
            System.out.println("N" + "\t" + "Abundant" + " Deficient" + " Perfect" + " Prime \t" + condition + " horizontal bar diagram"); 
            // Printing the formatted table headers. Put a space before some of the conditions
            // Indenting with \t indents after the end of a string. To get a clean table, I put spaces between Abundant, Deficient, Perfect, and Prime
            // This was easy to account for in the printing of the values, since you can look at how it looks in the output and add spaces using that
            
            value = Integer.parseInt(rawvalue); // Setting value as an integer so that it can be used in calculations
            
            do // Using a "do" loop, since it needs to stop at at a defined condition
            {
                n++; // Adding to the value "n" in the beginning, as to keep consistancy with the if statements which stop the do loop. Makes it easier to understand.
                sigma = 0; // Resetting the sigma value to 0. All the other values are accumulitive
                
                for (f = 1; f <= n/2; f++) // Calculating the sigma value. Start at f = 2. As long as f is LESS than HALF of n, go through
                    if (n % f == 0) // If it's a proper factor
                    {
                        sigma = sigma + f; // Add "f" to sigma
                    }
                
                if (sigma<n) // If deficient
                    dcount++;
                else if (sigma>n) // If abundant
                    acount++;
                else if (sigma==n) // If perfect
                    pcount++;
                
                if (sigma == 1) // If prime number, then add to the prime number count
                    prime++;
                
                // Finds what the condition is, and then if it's equal to the value, it sets conditionvalue to it
                // it then checks if the condition value (specified in the input) is equal to the actual value. If it is, it sets the boolean value "stop" to true, which will end the loop
                if (condition.equals("limit")) {
                    conditionvalue = n;
                    if (n==value)
                        stop = true;
                    }
                else if (condition.equals("deficient")) {
                    conditionvalue = dcount;
                    if (dcount==value)
                        stop = true;
                    }
                else if (condition.equals("abundant")) {
                    conditionvalue = acount;
                    if (acount==value)
                        stop = true;
                    }
                else if (condition.equals("perfect")) {
                    conditionvalue = pcount;
                    if (pcount==value)
                        stop = true;
                    }
                else if (condition.equals("prime")) {
                    conditionvalue = prime;
                    if (prime==value)
                        stop = true;
                    }
                
                System.out.println(n + "\t" + acount + "\t " + dcount + "\t   " + pcount + "\t   " + prime + "\t \t" + GenerateStars(conditionvalue) ); // Printing the formatted values. Put spaces there to account for the table
                // Prints a star graph to the right of everything, labeling it as "[condition] horizontal bar graph"
                // Uses the private class GenerateStars
             }
             while (! stop); // if the stop value is false, then continue the loop. If not (AKA it's true) then stop
        }
    }
}
