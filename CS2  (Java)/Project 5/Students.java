/**
 * Name: Tim Sternberg
 * Email: tsternberg@my.ccsu.edu
 * Class: CS 152 - Computer Science II
 * Section: 02
 */

import java.util.Scanner;
import java.io.*;

public class Students
{
    public static void main (String[] args) throws IOException, UnknownCommandException, InvalidGradeException
    {
        String first_name, last_name, fullname; // String variables used for names
        int grade, count = 0; // Primitive integer variables. Notice how we start count at 0, since the first index of a list is 0
        boolean found; // Bool value used in deletion of students from the array
        Scanner fileInput = new Scanner(new File("students.txt")); // Declaring the text file input with all the students and their grades
        Student[] templist = new Student[10], list; // Declaring two different arrays. list is the main array. templist is used for reordering the main array list.
        // If the file size has anything more than 10 elements, we'll get an error

        UnknownCommandException commExc = new UnknownCommandException ("Invalid Command Entered"); // Declaring InvalidCommandException object

        try // Going to "try" to run the following body, and look for errors. If there is an error that is defined, then it will catch it and print the error
        {

            while (fileInput.hasNext()) // Starting the loop which populates the templist
            {
                first_name = fileInput.next(); // Taking the first string and assigning it to first_name
                last_name = fileInput.next(); // Taking the second string and assigning it to first_name
                grade = fileInput.nextInt(); // Taking the third string and assigning it to first_name
                
                templist[count] = new Student (first_name,last_name,grade); // Starting with index 0 (from count = 0) we populate the templist with students
                count++; // Add 1 to count each time we add a student. We count it AFTER, since the length of an array is different than the index
            }
            list = new Student[count]; // Referance list to a array with length count

            for (int index = 0; index < list.length; index++) // Populate list with all the students. This list will have count students, with length count. We go until the length of list, which is = count. Notice index < list.length
            {
                list[index] = templist[index]; // The index in list is = the index of templist. This is okay up until we surpass the actual length of list, which we won't since the loop only goes as far as the length of the list
            }
            templist = null; // We don't need this anymore, so may as well make it null until next time we use it

            boolean Continue = true; // When this is false, we stop our while loop
            while (Continue) // while continue is true
            {
                String command; // command input string
                Scanner scan = new Scanner(System.in); // Scanner class
                System.out.print("Enter a command: "); // Prompting user to enter a command
                command = scan.nextLine(); // The command = next line inputted

                if (command.equals("end")) // If they enter end, then we set continue = false, and end our while loop
                    Continue = false;
                else if (command.equals("sortgrade")) // If the command is sortgrade, then we sort the list with a bubble sort, and we send over "grade" to the bubble sort method, which will set type = "grade"
                    Sort.bubbleSort(list,"grade");
                else if (command.equals("sortfirst")) // If the command is sortfirst, then we sort the list with a bubble sort, and we send over "first name" to the bubble sort method, which will set type = "first name"
                    Sort.bubbleSort(list,"first name");
                else if (command.equals("sortlast")) // If the command is sortlast, then we sort the list with a bubble sort, and we send over "last name" to the bubble sort method, which will set type = "last name"
                    Sort.bubbleSort(list,"last name");
                else if (command.equals("print")) // If it's equal to print, then we print the current state of our list
                {
                    System.out.println ("\nSorted by " + Student.GetType() + "\n----------------------------------"); // Using our static variable "type" in students to let the user know what we're sorting by
                    for (int index = 0; index < list.length; index++) // From index = 0 until list.length, run through
                    {
                        System.out.print ("Name: " + list[index].Getfname() + " " + list[index].Getlname()); // Print the first and last name
                        System.out.println ("\t Grade: " + list[index].Getgrade()); // Print the grade
                    }
                    System.out.println();
                }
                else if (command.equals("add")) // if command is "add"
                {
                    System.out.print("Enter first name, last name, then grade: "); // Prompts user to enter first name, last name, then grade on the same line,
                    first_name = scan.next(); // first name = first input
                    last_name = scan.next(); // last name = second input
                    grade = Integer.parseInt( scan.next() ); // grade = third input. Converting whatever string is entered to a number, so that it works even if user enters a decimal

                    System.out.println("New addition: " + first_name + " " + last_name + " " + grade); // Letting the user know the exact addition
                    templist = list; // Setting templist = list, so that we can restructure list to have an extra index
                    list = new Student[list.length+1]; // Setting list equal to a blank list with 1 more index

                    for (int index = 0; index < templist.length; index++) // Running from 0 until the new length
                        list[index] = templist[index]; // the index in list is equal to the index in templist, much similar to how we first populated the list before

                    list[list.length-1] = new Student (first_name,last_name,grade); // finally, after we've populated list with our all old info, we tack on our new addition to the last index of the list

                    Sort.bubbleSort(list,Student.GetType()); // Bubble sorting list with the previous sorting method

                    templist = null; // setting templist = null since we don't need this copy anymore
                }
                else if (command.equals("delete"))
                {
                    System.out.print("Enter first and last name: "); // Prompting user to enter the first and last name of the student they want to delete
                    fullname = scan.nextLine(); // We have the input as one full name in one string

                    found = false; // Initially not found. If this is still false, then the user inputted a student that does not exist
                    for (int index = 0; index < list.length; index++) // Running from 0 to the index length searching for a student with a matching name as the one inputted
                    {
                        if ((found == false) && fullname.equals("" + list[index].Getfname() + " " + list[index].Getlname() )) // If we haven't found the index yet, and the fullname = the index's first + last name, then we got our match!
                        {
                            found = true; // Letting our code know that we found it
                            templist = list; // Setting templist = list, so we can restructure list with one less index
                            list = new Student[templist.length-1]; // The list now has 1 less index. It's also blank so we'll have to repopulate it
                            count = 0; // Using a count value to keep track of when we delete our index
                            // The count value will be equal to the num value up until we get to our unwanted index, and skips it, leaving count to be the same as it was
                            for (int num = 0; num < templist.length; num++) // Running from 0 to the templist length
                            {
                                if (num != index) // If the num does NOT EQUAL THE INDEX OF THE DESIRED DELETED STUDENT
                                {
                                    list[count] = templist[num]; // Populate list in index count of the next value of templist
                                    // Notice that once we get to our desired index, count and num will no longer be equal. We skip that index, and go on our merry way with the next value of templist
                                    count++; // Tack 1 onto count
                                }
                            }
                            templist = null; // Setting templist to null once more
                        } 
                    }

                    if (found == true) // If we found the student which they wanted to delete
                    {
                        System.out.println("Student [" + fullname + "] deleted from list"); // let the user know who we deleted
                        Sort.bubbleSort(list,Student.GetType()); // Bubble sorting list with the previous sorting method
                    }
                    else
                        System.out.println("Student " + fullname + " not found"); // Otherwise, if we didn't find the desired user, we let the user know with an error message "Student NAME not found"
                }
                else throw commExc; // If the command was not among the allowed commands, we throw the InvalidCommandException
            }

        }

        catch (ArrayIndexOutOfBoundsException e) // The exception for if an array is read from the file that is out of bounds
        {
            System.out.println(e); // Printing our error!
        }

        catch (UnknownCommandException e) // Exception for if the user enters an invalid command (one that is not defined in the code basically)
        {
            System.out.println(e);
        }

        finally
        {
            System.out.println(); // Printing an empty line for formatting in the terminal
        }

    }
}
