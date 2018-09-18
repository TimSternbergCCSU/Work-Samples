/**
 * Name: Tim Sternberg
 * Email: tsternberg@my.ccsu.edu
 * Class: CS 152 - Computer Science II
 * Section: 02
 */

/**
 * CLASSES AND METHODS USED:
 * 
 * Bubble Sort Method in class Sort used from Sort class in syllabus
 * Student Class used from Student Class in syllabus
 * Students class used from Students Class in syllabus
 * Derived part of the while loop which read user input from Project 1
 */

public class Student implements Comparable // Uses the comparable interface
{
    private String first_name,last_name; // Declaring our string name variables
    private int grade; // Our grade variable
    private static String type = "nothing"; // Our type variable. Notice that it's a string object, and then we initialize with "nothing" since technically the list is not initially sorted with anything
    
    InvalidGradeException grExc = new InvalidGradeException ("Invalid Grade Entered"); // Declaring InvalidGradeException object
    
    public Student (String first_name, String last_name, int grade) throws InvalidGradeException
    {
        try
        {
            this.first_name = first_name; // The object's first name is equal to the one sent over
            this.last_name = last_name; // The object's last name is equal to the one sent over
            this.grade = grade; // The object's object is equal to the one sent over
            
            if (grade < 0 || grade > 100) throw grExc; // Throws the exception if there is an invalid grade (not [0,100])
        }
        catch (InvalidGradeException e) // The exception for if the grade is not valid (not on the interval [0,100])
        {
            System.out.println(e);
        }
    }    

    // All the below methods up until compareTo are used to enforce encapulation
    public static void SetType(String val) // Our type setter
    {
        type = val;
    }

    public static String GetType() // Our type getter
    {
        return type;
    }

    public String Getfname() // Get first name
    {
        return first_name;
    }

    public String Getlname() // Get last name
    {
        return last_name;
    }

    public int Getgrade() // Get grade
    {
        return grade;
    }

    // When we call compareTo, and give it a string or int, we use the given compareTo in the Comparable interface
    public int compareTo (Object x) // Overriding the compareTo in our given Comparable inteface with a compareTo that takes Objects
    {
        if (type.equals("first name")) // If type = "first name"
            return first_name.compareTo( ((Student)x).Getfname() ); // Return the value of our GIVEN compareTo result when we compare two string. Comparing first names
        else if (type.equals("last name")) // if type = "last name"
            return last_name.compareTo( ((Student)x).Getlname() ); // Return the value of our GIVEN compareTo result when we compare two string. Comparing last names
        else if ( type.equals("grade") && grade > ((Student)x).Getgrade() ) // Simply comparing two int values. Easy. If this student has a greater grade than the comparabable one, then we return 1
            return 1;
        else
            return -1;

    }
}
