package be.fnord.DefaultLogic;

/**
 * Starting point
 * Loads the examples
 *
 */
public class App 
{
    public static void main( String[] args )
    {
        a.e.println("Demonstrating reasoners:");
        
        AbductiveExample.main(args);
        DefaultLogicExample.main(args);
    }
}
