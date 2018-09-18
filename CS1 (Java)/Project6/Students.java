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
    private static int count = 0; // Declaring count as a static variable within the students class as whole allows us to use it in the CheckForCommand method to create an array that's smaller than 1000 place values (in theory saves memory)
    
    public static void main (String[] args) throws IOException
    {   String first_name, last_name; // Declaring first/last string variables
        int grade; // Declaring the integer grade variables
        
        Scanner fileInput = new Scanner(new File("students.txt")); // Declaring the file input that we'll use for our list of students
        
        Student[] st = new Student[1000]; // Declaring the array of students with 1000 place values, since we don't know the length of the list yet
        
        while (fileInput.hasNext()) // If the fileInput has more information for us, then go through the loop. If it doesn't, then the loop ends
        {
            // Declares all the values to put in the student object
            first_name = fileInput.next();
            last_name = fileInput.next();
            grade = fileInput.nextInt();
            
            // Declaring the student object in the st array
            st[count] = new Student(first_name, last_name, grade);
            count++; // Adding 1 to our number of students
        }
        
        CheckForCommand(st); // Call CheckForCommand method
    }
    
    private static void CheckForCommand (Student[] arr)
    {
        // This method asks for a command, and from a list of if statements decides what to do
        // If the command is anything except "end" then it will go through its statement, and then repeat the statement
        Scanner scan = new Scanner(System.in);  // Reading from System.in
        System.out.print("Enter a command: ");
        String command = scan.next();
        if (command.equals("end")) { // If the command is "end" then we print program and and don't call the method again
            System.out.println();
            System.out.println("--[[PROGRAM END]]--");
        }
        else if (command.equals("printall")) { // Print the list of students as it is in the array
            prAll(arr,count);
            CheckForCommand(arr); // Go through the method again, asking for a new command
        }
        else if (command.equals("firstname")) { // Print a list of students with an inputted index of the first name
            prFirst(arr,count,scan.next());
            CheckForCommand(arr); // Go through the method again, asking for a new command
        }
        else if (command.equals("lastname")) { // Print a list of students with an inputted index of the last name
            prLast(arr,count,scan.next());
            CheckForCommand(arr); // Go through the method again, asking for a new command
        }
        else if (command.equals("interval")) { // Prints a list of students that are on interval that is inputted
            prGrade(arr,count,scan.nextInt(),scan.nextInt());
            CheckForCommand(arr); // Go through the method again, asking for a new command
        }
        else if (command.equals("sort")) { // Print the list of names from highest to lowest grade
            prSort(arr);
            CheckForCommand(arr); // Go through the method again, asking for a new command
        }
        else { // If the command isn't any of these, then print invalid command and prompts for another command
            System.out.println("Invalid command!");
            CheckForCommand(arr); // Go through the method again, asking for a new command
        }
    }
    
    private static void prSort (Student[] rawarr) // Prints the list of students from highest to lowest grades
    {
        // We have our raw array with 1000 place values as our only input
        // Using count as a length, rather than rawarr, so we're not making another array with length 1000 (I assume this saves memory)
        // Declare the array that we'll use for the sort. We don't want to use "rawarr", since that's simply a directory to the "st" array, and if we sort that, then that array will permanently be sorted
        Student[] arr = new Student[count+1]; // We want count+1, so that there's an extra space of null that the for loop can check for. Don't want to get an out of bounds error
        for (int i=0; i<rawarr.length && (rawarr[i] != null); i++) // populating the "arr" array with variables. Checks to make sure the value isn't null, and then adds it. If it is null, the for loop stops
            arr[i] = rawarr[i];
            
        int swaps; // declaring the swaps integer for the bubble sort
        Student t; // declaring the temporary student object
        do { 
            swaps = 0; // Starting off with 0 swaps
            for (int i=0; i<arr.length && (arr[i+1] != null); i++) // Checks to make sure there's an object to swap with. If there is, go through with statement. If not, end the for loop.
                if (arr[i].getGrade()<arr[i+1].getGrade()) { // If the grade is less than the one in front of it in the array, swap it. Ends up sorting it from highest to lowest grade. Using the getter method in "Student"
                    t=arr[i];
                    arr[i]=arr[i+1];
                    arr[i+1]=t; 
                    swaps++; // Tells the do while loop that there was a swap, so we need to go through at least one more time
            }
        } while (swaps>0);
        
        for (int i=0; i<arr.length && (arr[i] != null); i++) // Going through the array, and if the place valid isn't null, then we go ahead and print the object's information
            System.out.println(arr[i]);
        
        System.out.println(); // Printing a blank line for nice formatting
    }
    
    private static void prGrade (Student[] arr, int n, int a, int b) // Printing on an interval of grades
    {
        // int n being the "count" or number of students
        // We're on the interval [a,b]
        for (int i=0; i<n; i++) { // If "i" is LESS THAN "n" (the number of students), then go through the statement
            if ( arr[i].getGrade() >= a && arr[i].getGrade() <= b) // If the grade is greater than or equal to a, and less than or equal to b, then print (If it's on the interval [a,b], then print)
                System.out.println(arr[i]);
        }
        
        System.out.println(); // Printing a blank line for nice formatting
    }    

    private static void prFirst (Student[] arr, int n, String fn)
    {
        // String fn being the firstname specified. This can be any PART of the first name however
        for (int i=0; i<n; i++) { // If "i" is LESS THAN "n" (the number of students), then go through the statement
            if ( arr[i].getFname().indexOf(fn) != -1 ) // Using java's indexOf method. If the object name in the array is an "index of" the first name, it won't print -1. If it's not, then it will print -1. So if it's not -1, then print
                System.out.println(arr[i]); 
        }
        
        System.out.println(); // Printing a blank line for nice formatting
    }
    
    private static void prLast (Student[] arr, int n, String ln)
    {
        // String ln being the lastname specified. This can be any PART of the last name however
        for (int i=0; i<n; i++) { // If "i" is LESS THAN "n" (the number of students), then go through the statement
            if ( arr[i].getLname().indexOf(ln) != -1 )
                System.out.println(arr[i]); 
        }
        
        System.out.println(); // Printing a blank line for nice formatting
    }
    
    private static void prAll (Student[] arr, int n)
    {
        // Simple going through the array "n" times (number of students) and printing it
        for (int i=0; i<n; i++) // If "i" is LESS THAN "n" (the number of students), then go through the statement
            System.out.println(arr[i]); 
        
        System.out.println(); // Printing a blank line for nice formatting
    }
}
