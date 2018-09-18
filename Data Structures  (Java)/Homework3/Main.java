
public class Main
{   
    static String[] Tokens = { "*","/","+","-","(",")","#" };
    static int[] Priority = { 2,2,1,1,3,0,0 };
    static LLStackADT OperatorStack;
    static LLQueueADT Infix;
    static LLQueueADT Postfix;

    private static int TokenPriority(String token)
    {
        for (int i=0; i<Tokens.length; i++)
        {
            if (Tokens[i].equals(token))
                return Priority[i];
        }

        return -1; // Is an operand
    }
    
    private static int InfixPriority() 
    {
        return TokenPriority(Infix.front());
    }

    private static int StackPriority() 
    {
        return TokenPriority(OperatorStack.ontop());
    }

    public static void main(String[] args) 
    {
        OperatorStack     = new LLStackADT();
        Infix             = new LLQueueADT();
        Postfix           = new LLQueueADT();

        String infixString = "A*B+(C-D/E)";
        for (int i=0; i<infixString.length(); i++)
            Infix.enqueue( "" + infixString.charAt(i) );
        Infix.enqueue("#");
        
        String token;
        OperatorStack.push("#");
        do
        {
            token = Infix.dequeue();
            //System.out.println(token);
            if (token.equals("#"))
            {
                while (!OperatorStack.empty())
                    Postfix.enqueue( OperatorStack.pop() );
            }
            else if ( TokenPriority(token) == -1 ) // If the token is an operand
                Postfix.enqueue(token);
            else if (token.equals(")"))
            {
                String poppedtoken = OperatorStack.pop();
                while (! poppedtoken.equals("(") )
                {
                    Postfix.enqueue(poppedtoken);
                    poppedtoken = OperatorStack.pop();
                }
            }
            else
            {
                // Pop operator stack and enqueue on postfix operators whose stack priority is >= infix priority of the token, except if "("
                if ( TokenPriority( OperatorStack.ontop() ) >= TokenPriority( token ) && !OperatorStack.ontop().equals("(") )
                    Postfix.enqueue( OperatorStack.pop() );
                
                // Push token on operator stack
                OperatorStack.push(token);
            }
        } 
        while ( !token.equals("#") );
        
        System.out.println("Infix form: " + infixString);
        
        System.out.print("Postfix form: ");
        while (! Postfix.empty() ){
            String element = Postfix.dequeue();
            if (! element.equals("#"))
                System.out.print( element + " " );
        }
        System.out.println();
    }
}
