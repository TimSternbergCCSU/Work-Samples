
/**
 * Name: Tim Sternberg
 * CCSU Email: tsternberg@my.ccsu.edu
 * Class: Computer Science I
 * Section: 01
 * 
 * The user enters two fractions each one specified as two integers: a numerator and a denominator separated by 
 * a forward slash character and spaces (e.g. 1 / 3)
 * 
 * Then the program adds, subtracts, multiplies and divides the fractions (without simplification) and prints 
 * the result both as a fraction, a mixed number, and as a decimal (floating point) number.
 */

import java.util.Scanner;

class Main
{
    public static void main (String[] args) {
      int InputNum1,InputDen1, InputNum2,InputDen2;                     // Declaring Initial Fraction Values
      
      int FracNum1,FracNum2,FracDen;                                    // Declaring Fraction Variables
      int MixInt1,MixNum1,MixDen1, MixInt2,MixNum2,MixDen2;             // Declaring Mixed Number Variables
      float Dec1, Dec2;                                                 // Declaring Decimal Variables
      
      Scanner scan = new Scanner(System.in);                            // Instantiate a Scanner object
      
      // Read fractions from user input (enter integers separated by space, / and space)
      
      System.out.print("Enter a fraction (integer / integer): ");
      InputNum1 = scan.nextInt();
      scan.next("/");
      InputDen1 = scan.nextInt();
      
      System.out.print("Enter another fraction (integer / integer): ");
      InputNum2 = scan.nextInt();
      scan.next("/");
      InputDen2 = scan.nextInt();
      
      
      
      
      
      // Fraction and Mixed Number Results
      
      System.out.println(); // Just putting a space in the output to make it look cleaner
      System.out.println("Result as fraction and mixed number:");
  
      // Computing Fractions so they have a common denominator, for Addition and Subtraction
      // Note that casting the values to be int isn't necessary, since they're already int values
      FracNum1 = InputNum1*InputDen2;
      FracNum2 = InputNum2*InputDen1;
      FracDen  = InputDen2*InputDen1;
      
      // Printing Addition of Fractions
      System.out.print( InputNum1 + "/" + InputDen1 + " + " + InputNum2 + "/" + InputDen2 + " = " + (FracNum1+FracNum2) + "/" + FracDen + " = " );
                          // An if then statement to count for mixed numbers less than 1
                          if ( (FracNum1+FracNum2) > (FracDen) ){
                              System.out.print( ((FracNum1+FracNum2)/FracDen) + " " + ((FracNum1+FracNum2) % FracDen) + "/" + FracDen );
                              // If the num is greater than den, then have the mixed number with the number in front, then the fraction
                              // Used System.out.print() so that I could add to the line with this if then statement
                          } else{
                              System.out.print( ((FracNum1+FracNum2) % FracDen) + "/" + FracDen );
                              // If the numbers less than 1, have the mixed number only be a fraction
                          }
      System.out.println(); // Clearing the line, since there's some System.out.print() statements prior
                          
      // Printing Subtraction of Fractions
      System.out.print( InputNum1 + "/" + InputDen1 + " - " + InputNum2 + "/" + InputDen2 + " = " + (FracNum1-FracNum2) + "/" + FracDen + " = " );
                          // An if then statement to count for mixed numbers less than 1
                          if ( (FracNum1-FracNum2) > (FracDen) ){
                              System.out.print( ((FracNum1-FracNum2)/FracDen) + " " + ((FracNum1-FracNum2) % FracDen) + "/" + FracDen );
                              // If num is greater than den, then have the mixed number with the number in front, then the fraction
                              // It's particularly important that it doesn't ask if it's less than 1, in case there's negative numbers
                              // Used System.out.print() so that I could add to the line with this if then statement
                          } else{
                              System.out.print( ((FracNum1-FracNum2) % FracDen) + "/" + FracDen );
                              // If the numbers less than 1, have the mixed number only be a fraction
                          }
      System.out.println(); // Clearing the line, since there's some System.out.print() statements prior
      
      // Printing Multiplication of Fractions
      System.out.print( InputNum1 + "/" + InputDen1 + " * " + InputNum2 + "/" + InputDen2 + " = " + (InputNum1*InputNum2) + "/" + (InputDen1*InputDen2) + " = ");
                          if ( (InputNum1*InputNum2) > (InputDen1*InputDen2) ){
                              System.out.print( ((InputNum1*InputNum2)/(InputDen1*InputDen2)) + " " + 
                                              ((InputNum1*InputNum2) % (InputDen1*InputDen2)) + "/" + (InputDen1*InputDen2) );
                              // If num is greater than den, then have the mixed number with the number in front, then the fraction
                              // Used System.out.print() so that I could add to the line with this if then statement
                          } else{
                              System.out.print( (InputNum1*InputNum2) + "/" + (InputDen1*InputDen2) );
                              // If the numbers less than 1, have the mixed number only be a fraction
                          }
      System.out.println(); // Clearing the line, since there's some System.out.print() statements prior
                          
      // Printing Division of Fractions
      System.out.print( InputNum1 + "/" + InputDen1 + " ÷ " + InputNum2 + "/" + InputDen2 + " = " + (InputNum1*InputDen2) + "/" + (InputDen1*InputNum2) + " = ");
                          if ( (InputNum1*InputDen2) > (InputDen1*InputNum2) ){
                              System.out.print( ((InputNum1*InputDen2)/(InputDen1*InputNum2)) + " " +
                                              ((InputNum1*InputDen2) % (InputDen1*InputNum2)) + "/" + (InputDen1*InputNum2) );
                              // If num is greater than den, then have the mixed number with the number in front, then the fraction
                              // Used System.out.print() so that I could add to the line with this if then statement
                          } else{
                              System.out.print( (InputNum1*InputDen2) + "/" + (InputDen1*InputNum2) );
                              // If the numbers less than 1, have the mixed number only be a fraction
                          }
      System.out.println(); // Clearing the line, since there's some System.out.print() statements prior

      
          
      
          
      // Decimal Results
      
      System.out.println(); // Just putting a space in the output to make it look cleaner
      System.out.println("Result as floating point number:");
  
      Dec1 = (float)InputNum1/InputDen1; // Have to cast a float value to them to be able to divide. They're originally int values
      Dec2 = (float)InputNum2/InputDen2;
      
      //Printing Addition of Decimals
      System.out.println( Dec1 + " + " + Dec2 + " = " + (Dec1+Dec2) );
      
      //Printing Subtraction of Decimals
      System.out.println( Dec1 + " - " + Dec2 + " = " + (Dec1-Dec2) );
      
      //Printing Multiplication of Decimals
      System.out.println( Dec1 + " * " + Dec2 + " = " + (Dec1*Dec2) );
      
      //Printing Division of Decimals
      System.out.println( Dec1 + " ÷ " + Dec2 + " = " + (Dec1/Dec2) );
      
        
    }
}
