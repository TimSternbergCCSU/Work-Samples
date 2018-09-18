/**
 * Name: Tim Sternberg
 * Email: tsternberg@my.ccsu.edu
 * Class: CS 151 - Computer Science
 * Section: 01
 */

import java.util.Random;

class AddRationals {

    public static void main (String[] args)
    {
        Random gen = new Random();
        int aDen = gen.nextInt(8) + 1; // Generate a random integer on the interval [1,9] for the denominator
        int aNum = gen.nextInt(aDen); // Generate a random integer on the interval [0,Denominator-1] for the numerator
        int bDen = gen.nextInt(8) + 1;
        int bNum = gen.nextInt(bDen);
        int cDen = gen.nextInt(8) + 1;
        int cNum = gen.nextInt(cDen);

        Rational Sum,Avg,Max,Min; // Declaring the Sum, Average, Maximum, and Minimum Rational Variables

        Rational p = new Rational(aNum,aDen); // p points to a new instance of Rational
        Rational q = new Rational(bNum,bDen); // q points to a new instance of Rational
        Rational t = new Rational(cNum,cDen); // t points to a new instance of Rational
        System.out.println("Rational Numbers: " + p + ", " + q + ", " + t); // Printing the initial rational numbers

        Max = p.CalculateMax(q).CalculateMax(t); // Calculate the max between p and q, and then compute the max of THAT and t
        // Print the rational version of the max, and then the float conversion
        System.out.println("Maximum: " + Max + " (" + Max.ToFloat() + ")");

        Min = p.CalculateMin(q).CalculateMin(t); // Calculate the min between p and q, and then compute the min of THAT and t
        // Print the rational version of the max, and then the float conversion
        System.out.println("Minimum: " + Min + " (" + Min.ToFloat() + ")");

        Sum = p.sum(q).sum(t); // Calculate the sum of p, q, and t
        Sum.reduce(); // Reduce to lowest terms
        // Print the rational version of the sum, and then the float conversion
        System.out.println("Sum: " + Sum + " (" + Sum.ToFloat() + ")");

        Avg = Sum.Divide(3); // Take the sum of the three rationals and divide by integer 3
        Avg.reduce(); // Reduce to lowest terms
        // Print the rational version of the sum, and then the float conversion
        System.out.println("Average: " + Avg + " (" + Avg.ToFloat() + ")");
    }

}
