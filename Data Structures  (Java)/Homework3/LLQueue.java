public interface LLQueue {

    public void enqueue (String item);

    public String dequeue();

    public int size();

    public boolean empty();

    public String front();
}

class LLQueueADT implements LLQueue {

    private int size;
    private Node front;
    private Node rear;

    public LLQueueADT () {
        size = 0;
        front = null;
        rear = null;
    }

    public boolean empty () {
        return (size == 0);
    }

    public int size () {
        return size;
    }

    public void enqueue (String token) {
        Node newNode = new Node ();
        newNode.setData(token);
        newNode.setNext(null);
        if (this.empty()) 
            front = newNode;
        else
            rear.setNext(newNode);
        rear = newNode;
        size++;
    }

    public String dequeue () {
        String token = front.getData();
        front = front.getNext();
        size--;
        if (this.empty())
            rear = null;
        return token;
    }

    public String front () {
        return front.getData();
    }
}
