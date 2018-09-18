public class Wallet
{
    private int singles,fives,tens,twenties;
    
    public Wallet (int a, int b, int c, int d) // Constructor
    {
        singles = a;
        fives = b;
        tens = c;
        twenties = d;
    }
    
    public int getSingles() {return singles;}
    public int getFives() {return fives;}
    public int getTens() {return tens;}
    public int getTwenties() {return twenties;}
    
    public void setSingles(int val) {singles = val;}
    public void setFives(int val) {fives = val;}
    public void setTens(int val) {tens = val;}
    public void setTwenties(int val) {twenties = val;}
    
    public void getMoney(int money)
    {
        setTwenties(( money - (money%20) )/20);
        money = money - (twenties*20);
        
        setTens(( money - (money%10) )/10);
        money = money - (tens*10);
        
        setFives(( money - (money%5) )/5);
        money = money - (fives*5);
        
        setSingles(money);
    }
    
    public int totalMoney()
    {
        return singles + fives*5 + tens*10 + twenties*20;
    }
}