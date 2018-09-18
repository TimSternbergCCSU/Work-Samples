public class Student
{
    private String fname, lname; // Declaring the string first and last name variables for student
    private int grade; // Declaring the int grade variables for student

    // Declaring the int variables for all the totals and counts
    private static int TotalAvg=0, TotalCount=0; // Total Average of students and Total amount of students
    private static int TotalExc=0, ExcCount=0; // Total Average of Excellent students, and the amount of Excellent students
    private static int TotalOk=0, OkCount=0; // Total Average of Ok students, and the amount of Ok students
    private static int TotalFail=0, FailCount=0; // Total Average of Failure students, and the amount of Failure student

    private static int H_Grade, L_Grade; // Declaring the int variables for the highest and lowest grades
    private static String H_Name, L_Name; // Declaring the string variables for the names of the highest and lowest grades

    public Student(String fname, String lname, int grade)
    {
        // Using "this" so that it knows it's talking about the class "Student" variables, and not the one's inside the operator
        this.fname = fname;
        this.lname = lname;
        this.grade = grade;

        // Don't have to use "this" since TotalAvg is static
        TotalAvg = TotalAvg + grade; // Adding to the total average
        TotalCount++; // +1 to the total count

        // If the name == null, that means it hasn't been declared yet, so it'll set that student as the highest/lowest grade, since that's all it has so far
        // If it isn't null, that means there exists a student to compare it to, and so it compares it to
        if ( (H_Name == null) || (grade > H_Grade) ) { // If H_Name doesn't exist yet, or the grade is higher than the highest grade
            H_Name = fname + " " + lname; // Set the full name, so it's easier to print later
            H_Grade = grade; // Set the integer variable grade to H_Grade
        }
        else if ( (L_Name == null) || (grade < L_Grade) ) { // If the first condition is false, then if L_Name doesn't exist yet, or the grade is lower than the lowest grade
            L_Name = fname + " " + lname; // Set the full name, so it's easier to print later
            L_Grade = grade; // Set the integer variable grade to L_Grade
        }

        if (grade > 89) { // If the grade is higher than 89, it's considered excellent (90+)
            TotalExc = TotalExc + grade; // Add to the total excellent average
            ExcCount++; // +1 to the total excellent count
        }
        else if (grade > 59) { // Because the previous condition is false, that means it's less than 89. So if it's above 60, that means it's on the interval [60,89]
            TotalOk = TotalOk + grade; // Add to the total ok average
            OkCount++; // +1 to the total ok count
        }
        else { // Otherwise, if all the other conditions are false, that means it's less than a grade of 60 (< 60)
            TotalFail = TotalFail + grade; // Add to the total failure average
            FailCount++; // +1 to the total failure count
        } // +1 to the total excellent count

    }

    public String toString() // Converts the first name, last name, and grade into a string
    {
        return fname + " " + lname + "\t" + grade;
    }

    public static String getHighest() // Takes H_Name and H_Grade and puts them in a string, which will be directly printed
    {
        return H_Name + " recieved the highest grade of " + H_Grade;
    }

    public static String getLowest() // Takes L_Name and L_Grade and puts them in a string, which will be directly printed
    {
        return L_Name + " recieved the lowest grade of " + L_Grade;
    }

    
    // All of these methods return their associated totals and counts that will be used to print in the Students class
    public static double getTotalAvg()
    {
        return (double)TotalAvg/TotalCount; // Cast the division to double, since they're int. Only have to do one, since the other will become a double as well in the operation
    }

    public static int getTotalCount()
    {
        return TotalCount; // Returning the count variable
    }

    public static double getTotalExc()
    {
        return (double)TotalExc/ExcCount;
    }

    public static int getExcCount()
    {
        return ExcCount;
    }

    public static double getTotalOk()
    {
        return (double)TotalOk/OkCount;
    }

    public static int getOkCount()
    {
        return OkCount;
    }

    public static double getTotalFail()
    {
        return (double)TotalFail/FailCount;
    }

    public static int getFailCount()
    {
        return FailCount;
    }
}
