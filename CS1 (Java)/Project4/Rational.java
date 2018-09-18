// A class representing rational numbers

class Rational {

    private int numerator;
    private int denominator;

    public Rational (int a, int b) 
    {
        numerator = a; 
        denominator = b;
    }

    public Rational sum (Rational r) 
    {
        int num, den;
        den = denominator * r.getDenominator();
        num = numerator * r.getDenominator() + r.getNumerator() * denominator;
        return new Rational (num, den);
    }

    public int getNumerator() { return numerator; }

    public int getDenominator() { return denominator; }

    public String toString () { return numerator + "/" + denominator; }

    public void reduce() {

        int factor;
        factor = gcd(numerator, denominator);
        numerator = numerator / factor;
        denominator = denominator / factor;
    }

    private int gcd (int x, int y) {

        int t;
        while (y>0) {
            t = x % y;
            x = y;
            y = t;
        }
        return x;
    }

    // We're comparing the rational that CalculateMax is attached to and comparing to given local b
    public Rational CalculateMax(Rational b)
    {
        // Cross multiply the rationals to compare them
        if (numerator*b.getDenominator() > b.getNumerator()*denominator)
            return this; // return the rational of this method
        else
            return b; // return the local rational b, given when the method was called
    }

    // Same as CalculateMax, except with "<"
    public Rational CalculateMin(Rational b)
    {
        if (numerator*b.getDenominator() < b.getNumerator()*denominator)
            return this;
        else
            return b;
    }

    public float ToFloat()
    {
        // Returns the float value of the numerator and denominator
        // Important to remember that numerator and denominator are originally integers, so you need to cast them
        return (float)(numerator) / (float)(denominator);
    }

    public Rational Divide (int Amount)
    {
        // When a rational is divided by a number, essentially its denominator is being multiplied by it
        int newDen = denominator * Amount; // Calculate the "new" denominator
        Rational p = new Rational(numerator,newDen); // Still using the original numerator. That doesn't change
        p.reduce(); // Reduce to lowest terms
        return p; // Return the divided fraction, reduced to lowest possible terms
    }
}
