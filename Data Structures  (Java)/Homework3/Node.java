class Node {

    private String data;
    private Node next;

    public Node () {
        this("", null);  
    }

    public Node (String d) {
        data = d;   
    }

    public Node (String d, Node n) {
        data = d;
        next = n;   
    }

    public void setData (String newData) {
        data = newData;   
    }

    public void setNext (Node newNext) {
        next = newNext;   
    }

    public String getData () {
        return data;   
    }

    public Node getNext () {
        return next;   
    }

    public void displayNode () {
        System.out.print (data);   
    }
}
