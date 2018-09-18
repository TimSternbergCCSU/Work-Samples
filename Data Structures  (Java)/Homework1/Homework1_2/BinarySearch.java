
/**
 * Tim Sternberg
 */

import java.io.*;

public class BinarySearch
{
    private static boolean BinarySearch(int[] data, int target, int min, int max)
    {   
        int mid = (min+max) / 2; // Calculating the mid based on the min and max
        //System.out.println("min: " + min + " | " + "max: " + max + " mid: " + mid); // Used for debugging. Prints out the path of the recursive program
        
        if (min <= max)
            if (data[mid] == target) // If the mid value is equal to the target, we've found it! Then we return true
                return true;
            else
                if (data[mid] > target) // Adjusting min or max depending on the value of the target compared to the mid value
                    max = mid-1;
                else
                    min = mid+1;
        else
            return false; // Return false if the target isn't in the set. This happens when the min is less than the max
            
        return BinarySearch(data,target,min,max); // Go through the recursive call again, searching for the target in the data
    }
    
    public static void main(String[] args) throws IOException
    {
        int target = 7; // What we're trying to find using binary search
        int dataLength = 14; // Length of data
        
        int[] data = new int[dataLength]; // Declaring array with length dataLength
        
        for (int i=0; i<data.length; i++) // Populating array
            data[i] = i;
        
        System.out.println( BinarySearch(data,target,0,data.length) );
    }
}
