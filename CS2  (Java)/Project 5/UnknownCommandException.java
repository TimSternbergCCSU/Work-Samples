// Defines the exception for an unkown command. Needs to extend the exception class
public class UnknownCommandException extends Exception
{
    public UnknownCommandException(String message)
    {
        super(message); // Calling on the superclass's constructor, and passing the message
    }
}
