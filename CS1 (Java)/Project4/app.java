
public class app
{
    public static void main (String[] args)
    {
        Wallet w1 = new Wallet(5,2,2,1);
        Wallet w2 = new Wallet(3,1,0,2);
        
        System.out.println(w1.totalMoney());
        System.out.println(w2.totalMoney());
        
        w1.getMoney(w1.totalMoney()-27);
        w2.getMoney(w2.totalMoney()+27);
        
        System.out.println(w1.totalMoney());
        System.out.println(w2.totalMoney());
        
    }
}