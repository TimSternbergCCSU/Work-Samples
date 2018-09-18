/**
 * Name: Tim Sternberg
 * Email: tsternberg@my.ccsu.edu
 * Class: CS 152 - Computer Science II
 * Section: 02
 */

import javax.swing.JFrame;

public class Graph
{
   public static void main (String[] args)
   {
      JFrame frame = new JFrame ("Directed Graph"); // Calling the JFrame, our main window, naming it "Directed Graph"
      frame.setDefaultCloseOperation (JFrame.EXIT_ON_CLOSE); // The close function

      frame.getContentPane().add (new GraphPanel()); // Calling GraphPanel

      frame.pack();
      frame.setVisible(true);
   }
}
