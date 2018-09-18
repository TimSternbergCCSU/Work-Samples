/**
 * Name: Tim Sternberg
 * Email: tsternberg@my.ccsu.edu
 * Class: CS 151 - Computer Science
 * Section: 01
 */
import java.util.Scanner;
public class Age
{
    public static void main (String[] args) 
    {
        final int CurrentMonth = 3;                      // The current month
        final int CurrentYear = 2016;                    // The current year
        final int SmallestYear = 1900;                   // The smallest year allowed
        
        Scanner scan = new Scanner(System.in);           // Delcaring the scanner class
        int MOB, YOB, Months, MonthsLived, YearsLived;   // Declaring integer variables
        String FName, LName, input;                      // Declaring string variables
        

        System.out.print("Enter your first and last name: "); // Asking for first and last name
        FName = scan.next(); // The first word will be the first name
        LName = scan.next(); // Second word will be the last name. The two inputs are seperated by a space, which is how the program knows the difference between the two
        System.out.print("Enter Month of Birth: "); // Asking for birth month
        input = scan.next(); // Raw input of the month
        
        // The while loop will go to the statement if the input is not an integer (A string, or a double value) using the isInteger method
        // It will also go to the statement if the input is an integer, and it is less than 1 or greater than 12. It wouldn't be a valid month in that case
        // This works because it checks the first condition, and if it is not an integer, it just goes straight to the statement
        // This repeats until the input is a valid month
        while (! Type.isInteger(input) || Integer.parseInt(input) < 1 || Integer.parseInt(input) > 12 ) 
        {
            System.out.println("Invalid month input!");
            System.out.println("Please enter your month of birth number between 1 and 12: ");
            input = scan.next(); // Wait for next input and then go through the while loop again
        }
        MOB = Integer.parseInt(input); // The month is an integer on the interval [1,12], so we can save it as the month of birth
        System.out.print("Enter Year of Birth: "); // Asking for year of birth
        input = scan.next(); // Raw input of the year
        
        // The while loop will go to the statement if the input is not an integer (A string, or a double value) using the isInteger method
        // It will also go to the statement if the input is an integer, and it is less than the constant "SmallestYear" or larger than the current year 
        // This works because it checks the first condition, and if it is not an integer, it just goes straight to the statement
        // This repeats until the input is a valid month
        while (! Type.isInteger(input) || Integer.parseInt(input) < SmallestYear || Integer.parseInt(input) > CurrentYear )
        {
            System.out.println("Invalid year input!"); // There was an error with the user's input
            System.out.println("Please enter a numerical year between " + SmallestYear + " and " + CurrentYear + ":"); // Re-enter the value
            input = scan.next(); // Wait for next input and then go through the while loop again
        }
        
        YOB = Integer.parseInt(input); // The year is an integer on the interval [SmallestYear,CurrentYear] ( AKA [1900,2016] ), so we can save it as the year of birth
        MonthsLived = (CurrentYear * 12) - (YOB * 12) + CurrentMonth - MOB; // Calculating the months lived
        Months = MonthsLived % 12;  // Remainder from integer division, used for printing age
        YearsLived = MonthsLived / 12;   // Integer division, used for printing age
        System.out.println(); // Putting a space in the output to make it look nice and seperate the inputs from results
        System.out.println("Your name is " + FName + " " + LName); // Printing name
        System.out.println("You are approximately " + YearsLived + " years and " + Months +" months old"); // Printing approximate age

        if (YearsLived > 65) // If they're older than 65
            System.out.println("You are a senior"); // Print they're a senior
        else if (YearsLived < 18) // If they're younger than 18
            System.out.println("You are a kid"); // Print they're a kid
        else // Otherwise, they have to be in the range of 19 to 64,
            System.out.println("You are an adult"); // Print they're an adult

        if (CurrentMonth == MOB) // If the current month is equal to the month of birth, then that means it's their birthday month
            System.out.println("Happy Birthday " + FName + " " + LName + ", it's your birthday this month!"); // Print a nice happy birthday month message

        System.out.println(); // Making a space in the output
    }
}

