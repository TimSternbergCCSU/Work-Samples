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

public class Sort
{

    public static void bubbleSort (Student[] list, String type) // Sending over our list, and the type that we're sorting with
    {
        Student.SetType(type); // Enforcing encapulation, we set the type equal to the string type we sent over
        boolean sorted; // bool sorted value, to let the bubble sort know when we're done
        Student temp; // our temp student ojbect used in the bubble sort

        do // Do while sorted is equal to false. When we run through, and it doesn't set sorted = false, then we end
        {
            sorted = true;
            for (int i = 0; i < list.length-1; i++) // run from i = 0 until list length
                if ( list[i].compareTo(list[i+1]) > 0 ) // Using the compareTo, we compare the list index to the one ahead of it. If we're sent back with a value above 0, (would be 1) then go through the if statement
                {
                    temp = list[i]; // temp is equal to the object in list of the current index
                    list[i] = list[i+1]; // the object in list of the current index is equal to the one ahead of it
                    list[i+1] = temp; // The one in index+1 is equal to the temp object
                    sorted = false; // We had to sort, so sorted = false, so we run through the do while loop again
                }
        } while (!sorted);
    }   

}
