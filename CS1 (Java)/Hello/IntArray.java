public class IntArray
{
    public static void main (String[] args)
    {
        int[] arr = {1,4,2,5,7,9,3,2,6,8};
        sumsquare(arr);
    }
    
    public static void sumsquare (int[] a)
    {
        int sum = 0;
        for (int i=0; i<a.length; i++)
            sum = sum + a[i]*a[i];
        System.out.println("The sum of sqaures is " + sum);
    }
}