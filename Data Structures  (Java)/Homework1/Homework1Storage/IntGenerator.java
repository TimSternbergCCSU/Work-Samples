import java.util.Random;

class IntGenerator
{ 
    public static void main(String[] args)
    {
        Random r = new Random();
        for (int i=0; i<2000; i++)
        {
            int n = r.nextInt(10000) + 1;
            System.out.print(n + " ");
        }
    }
}