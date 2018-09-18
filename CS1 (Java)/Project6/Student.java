/**
 * Name: Tim Sternberg
 * Email: tsternberg@my.ccsu.edu
 * Class: CS 151 - Computer Science
 * Section: 01
 */

public class Student
{
    private String fname, lname; // declaring private strings for the first and last names
    private int grade; // declaring private integer grade
    
    public Student(String fname, String lname, int grade)
    {
        this.fname = fname; // calls on the Student's fname (using this.) and then calls on the fname that was in the input
        this.lname = lname; // calls on the Student's lname (using this.) and then calls on the lname that was in the input
        this.grade = grade; // calls on the Student's grade (using this.) and then calls on the grade that was in the input
    }

    public String toString() // converts the information into one whole string value
    {
        return fname + " " + lname + "\t" + grade;
    }
    
	// getter methods for the Students class, as a way to enforce encapsulation
    public String getFname() { return fname; }
    public String getLname() { return lname; }
    public int getGrade() { return grade; }
}
