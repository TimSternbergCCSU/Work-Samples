/**
 * Name: Tim Sternberg
 * Email: tsternberg@my.ccsu.edu
 * Class: CS 152 - Computer Science II
 * Section: 02
 */

import java.util.ArrayList;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;

public class GraphPanel extends JPanel
{
    private final int SIZE = 10;  // radius of each node

    private Point point1 = null, point2 = null; // Initializing each points as null
    // Point1 is always the first place you click
    // Point2 is only not null if you click and drag

    private ArrayList<Point> nodeList;   // Graph nodes
    private ArrayList<Edge> edgeList;    // Graph edges

    private int[][] a = new int[100][100];  // Graph adjacency matrix

    private double alpha; // Variable used for creating the arrow

    private String mode = "Create"; // The mode variable used for add/delete. Initialized as create

    public GraphPanel()
    {
        nodeList = new ArrayList<Point>(); // Creating the node array
        edgeList = new ArrayList<Edge>(); // Creating the edge array

        // Adding the mouse listeners
        GraphListener listener = new GraphListener();
        addMouseListener (listener);
        addMouseMotionListener (listener);

        // Calling the create button and adding it to the frame
        JButton add = new JButton("Create");
        add.addActionListener (new addListener());
        add(add);

        // Calling the delete button and adding it to the frame
        JButton del = new JButton("Delete");
        del.addActionListener (new delListener());
        add(del);
        
        // Calling the print button and adding it to the frame
        JButton print = new JButton("Print adjacency matrix");
        print.addActionListener (new printListener());
        add(print);

        setBackground (Color.black); // Setting the background black
        setPreferredSize (new Dimension(500, 400)); // Initially our window size will be 500x400
    }

    //  Draws the graph
    public void paintComponent (Graphics page)
    {
        super.paintComponent(page);

        page.setColor (Color.green); // Setting color before drawing the mode string so that it's green too!
        page.drawString("Mode: " + mode,5,15); // Using the current string "mode" to draw a string that represents the mode

        // Draws the edge that is being dragged
        if (point1 != null && point2 != null) {
            page.drawLine (point1.x, point1.y, point2.x, point2.y);
            // If both point1 and point2 aren't null, that means we drew a line. So draw it on the page

            // Setting our alpha variable for the arrow. Depends on where point1 and point2 are located in respect to each other
            alpha = Math.atan((double)(point2.y-point1.y)/(point2.x-point1.x));
            if (point1.x > point2.x) alpha = alpha + Math.PI;
            if (point1.x < point2.x && point1.y > point2.y) alpha = alpha + 2*Math.PI;
            
            // We pass the page, and the two points of the line to the arrow method. It will then compute the alpha within the method, to make it look a bit nicer
            arrow(page,point1,point2);
        }

        // Draws the nodes      
        for (int i=0; i<nodeList.size(); i++) {
            page.setColor (Color.green); // Setting the color of the node to green
            page.fillOval (nodeList.get(i).x-SIZE, nodeList.get(i).y-SIZE, SIZE*2, SIZE*2);
            page.setColor (Color.black);
            page.drawString (String.valueOf(i), nodeList.get(i).x-SIZE/2, nodeList.get(i).y+SIZE/2);
        }

        // Draws the edges
        for (int i=0; i<edgeList.size(); i++) {
            page.setColor (Color.green); // Setting the color of the line to green
            page.drawLine (edgeList.get(i).a.x, edgeList.get(i).a.y,edgeList.get(i).b.x, edgeList.get(i).b.y);
            //page.fillOval (edgeList.get(i).b.x-3, edgeList.get(i).b.y-3, 6, 6);
            
            // We pass the page, and the two points of the line to the arrow method. It will then compute the alpha within the method, to make it look a bit nicer
            Point p1 = edgeList.get(i).a;
            Point p2 = edgeList.get(i).b;
            arrow(page,p1,p2);
        }
    }

    private void arrow(Graphics page, Point p1, Point p2)
    {
        int x = p2.x; // the x value of the end of the line
        int y = p2.y; // the y value of the end of the line
        
        // Determining the alpha for the arrow
        alpha = Math.atan((double)(p2.y-p1.y)/(p2.x-p1.x));
        if (p1.x > p2.x) alpha = alpha + Math.PI;
        if (p1.x < p2.x && p1.y > p2.y) alpha = alpha + 2*Math.PI;
        alpha = 1.57-alpha;
            
        page.setColor (Color.green); // We want the arrow to be green
        // Drawing the actual arrow
        page.drawLine (x, y, x, y);
        page.drawLine (x, y, x+(int)(20*Math.sin(alpha+2.5)), y+(int)(20*Math.cos(alpha+2.5)));
        page.drawLine (x, y, x+(int)(20*Math.sin(alpha+3.7)), y+(int)(20*Math.cos(alpha+3.7)));
    }

    //  The listener for mouse events.
    private class GraphListener extends MouseAdapter // Using mouseadapter so we don't have to have empty definitions
    {
        public void mouseClicked (MouseEvent event)
        {
            if ( mode.equals("Create") )
                nodeList.add(event.getPoint()); // If we're in create mode, then add the node
            else if ( mode.equals("Delete") ) // Otherwise, let's figure out if we have anything to delete
            {
                // Goes through the nodes    
                for (int i=0; i<nodeList.size(); i++) {
                    // Creating a Point2D.Double point so we can compare it to where we clicked
                    Point2D.Double p = new Point2D.Double(nodeList.get(i).x, nodeList.get(i).y);
                    
                    double dist = p.distance( event.getPoint() );
                    // Using the distance method that's part of Point2D.Double. Can either take an X and Y value
                    // Or, like we use here, just the point itself!
                    
                    if (dist < SIZE) { // Using the size of the node as a distance parameter, since that's what makes most sense
                        point1 = null; // Setting point1 and point2 to null, so that no other lines are redrawn
                        point2 = null;
                        nodeList.remove(i); // Removing the node from the arraylist
                    }
                }

                // Goes through the edges
                for (int i=0; i<edgeList.size(); i++) {
                    // Creating a Line2D.Double object segment, so we can sue it to measure the distance
                    Line2D.Double seg = new Line2D.Double(
                    edgeList.get(i).a.x, edgeList.get(i).a.y,edgeList.get(i).b.x, edgeList.get(i).b.y);
                    
                    double dist = seg.ptSegDist( event.getPoint() );
                    // Using the ptSegDist method that's part of the Line2D.Double object to get the distance from
                    // The line to where the user clicked
                    
                    if (dist < SIZE) { // Could use any size for the distance parameter, but may as well use the same as the node
                        point1 = null; // Setting point1 and point2 to null, so that no other lines are redrawn
                        point2 = null;
                        edgeList.remove(i); // Removing the segment from the arraylist
                    }
                }   
            }

            repaint(); // Whether we're creating or deleting a point, we still have to repaint
        }

        public void mousePressed (MouseEvent event) 
        {
            if ( mode.equals("Create") ) // If in mode create, then set the point1 to the current mouse position
                point1 = event.getPoint();
            // Notice we don't need a repaint here. If it's pressed, that means it's dragged. And the dragged event repaints already
        }

        public void mouseDragged (MouseEvent event)
        {
            if ( mode.equals("Create") ) // If in create mode, then set point2 to the current mouse position
            {
                point2 = event.getPoint();
                repaint();
            }
        }

        public void mouseReleased (MouseEvent event)
        {
            if ( mode.equals("Create") ) // If in mode create
            {
                point2 = event.getPoint(); // Setting the point2. Notice it's inside the if statement for mode, since we don't need it called if we're in delete mode
                if (point1.x != point2.x && point1.y != point2.y)
                {
                    edgeList.add(new Edge(point1,point2));
                    repaint();
                }
            }
        }
        
//         public void mouseMoved (MouseEvent event)
//         {
//             
//         }
    }

    // Represents the graph edges
    private class Edge {
        Point a, b; // a is the starting point, b is the end point

        public Edge(Point a, Point b) 
        {
            this.a = a; // "this" referring to the global a
            this.b = b;
        }
    }

    private class printListener implements ActionListener
    {
        public void actionPerformed (ActionEvent event)
        {
            // Initializes graph adjacency matrix
            for (int i=0; i<nodeList.size(); i++)
                for (int j=0; j<nodeList.size(); j++) a[i][j]=0;

            // Includes the edges in the graph adjacency matrix
            for (int i=0; i<edgeList.size(); i++)
            {
                for (int j=0; j<nodeList.size(); j++)
                    if (distance(nodeList.get(j),edgeList.get(i).a)<=SIZE+3)
                        for (int k=0; k<nodeList.size(); k++)
                            if (distance(nodeList.get(k),edgeList.get(i).b)<=SIZE+3) 
                            {
                                System.out.println(j+"->"+k);
                                a[j][k]=1;
                            }
            }

            // Prints the graph adjacency matrix
            for (int i=0; i<nodeList.size(); i++)
            {
                for (int j=0; j<nodeList.size(); j++)
                    System.out.print(a[i][j]+"\t");
                System.out.println();
            }    
        }

        // Euclidean distance function      
        private int distance(Point p1, Point p2) {
            return (int)Math.sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
        }
    }

    private class addListener implements ActionListener
    {
        public void actionPerformed (ActionEvent e)
        {
            mode = "Create"; // Setting the mode to create
            repaint(); // Repainting so the mode is updated
        }
    }

    private class delListener implements ActionListener
    {
        public void actionPerformed (ActionEvent e)
        {
            mode = "Delete"; // Setting the mode to delete
            repaint(); // Repainting so the mode is updated
        }
    }

}
