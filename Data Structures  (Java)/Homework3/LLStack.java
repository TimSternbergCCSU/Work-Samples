public interface LLStack {

    public void push (String item);

    public String pop();

    public int size();

    public boolean empty();

    public String ontop();
}

class LLStackADT implements LLStack {

    private Node top;
    private int size;

    public LLStackADT () {
        top = null;
        size = 0;
    }          

    public boolean empty () {
        return (top == null);
    }

    public int size () {
        return size;
    }

    public void push (String token) {
        Node newNode = new Node ();
        newNode.setData(token);
        newNode.setNext(top);
        top = newNode;
        size++;     
    }

    public String pop () {
        String token = top.getData();
        top = top.getNext();
        size--;
        return token;
    }

    public String ontop () {
        String token = pop();
        push(token);
        return token;
    }
}
