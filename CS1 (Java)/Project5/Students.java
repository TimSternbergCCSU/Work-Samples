/**
 * Name: Tim Sternberg
 * Email: tsternberg@my.ccsu.edu
 * Class: CS 151 - Computer Science
 * Section: 01
 */

import java.util.Scanner;
import java.io.*;

public class Students
{
    public static void main (String[] args) throws IOException
    {   String first_name, last_name;
        int grade; // int grade variable
        Scanner fileInput = new Scanner(new File("students.txt")); // Declaring the text file that will be used to input all of the students and their grades

        while (fileInput.hasNext()) // while loop that checks to make sure the fileInput has something else to look for
        {
            //Important to remember that all of these variables are local, and cannot be referanced anywhere outside of this loop
            first_name = fileInput.next(); // Next input will be the first name
            last_name = fileInput.next(); // Next input will be the last name
            grade = fileInput.nextInt(); // Next input (and the last one, for this run through of the loop) will be the grade

            Student st = new Student(first_name, last_name, grade); // Declaring local student object that will printed

            System.out.println(st); // Print the student object (Thanks to toString() method, it will return the name of the student and the grade)
        } // If the loop has already gone through everything, then end the loop

        System.out.println(); // Print a blank line, for formatting purposes

        // The following will print the total number of students in the specified set, and then the total average grade of that set
        System.out.println("There are " + Student.getTotalCount() + " students with average grade " + Student.getTotalAvg());
        System.out.println("There are " + Student.getExcCount() + " excellent students with average grade " + Student.getTotalExc());
        System.out.println("There are " + Student.getOkCount() + " ok students with average grade " + Student.getTotalOk());
        System.out.println("There are " + Student.getFailCount() + " failure students with average grade " + Student.getTotalFail());

        System.out.println(); // Print a blank line, for formatting purposes

        // Calls on the getHighest and getLowest methods to get a string that will be directly printed
        // The reason I decided to do it this way, is because it's much easier than calling an array, or trying to set a Student object to the Highest and Lowest
        // The first and last name are saved as a single string, and then the grade integer is saved
        // Use getter methods, since it's frowned upon to be able to access the variables directly from this method
        System.out.println(Student.getHighest());
        System.out.println(Student.getLowest());
    }
}
