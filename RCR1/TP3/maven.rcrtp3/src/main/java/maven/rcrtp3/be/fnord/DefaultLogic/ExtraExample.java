/**
 * A special example for a special someone
 * 
 * Cosmological considerations of penguins
 * 
 * 
 * 
 * 
 * 
Given the world: 
	tweety_is_a_bird
 And the rules 
	[(tweety_is_a_bird):(tweety_can_fly) ==> (tweety_can_fly)]
Possible Extensions
	 Ext: Th(W U (tweety_can_fly))
	= tweety_can_fly & tweety_is_a_bird 
We one day learn that tweety is penguin.
Given the world: 
	tweety_is_a_bird & tweety_is_a_penguin & (tweety_is_a_penguin -> ~tweety_can_fly)
 And the rules 
	[(tweety_is_a_bird):(tweety_can_fly) ==> (tweety_can_fly)] , [(tweety_is_a_bird):(tweety_is_a_penguin) ==> (~tweety_can_fly)]
Possible Extensions
	 Ext: Th(W U (~tweety_can_fly))
	= ~tweety_can_fly & tweety_is_a_bird & tweety_is_a_penguin & (~tweety_can_fly | ~tweety_is_a_penguin) 
 */

package be.fnord.DefaultLogic;

import java.util.HashSet;

import be.fnord.util.logic.DefaultReasoner;
import be.fnord.util.logic.WFF;
import be.fnord.util.logic.defaultLogic.DefaultRule;
import be.fnord.util.logic.defaultLogic.RuleSet;
import be.fnord.util.logic.defaultLogic.WorldSet;

public class ExtraExample {

	// Example 2.9 From
	// J. P. Delgrande, T. Schaub, and W. K. Jackson (1994). Alternative
	// approaches to default logic. Artificial Intelligence, 70:167-237.

	public static void example() {
		WorldSet myWorld = new WorldSet();
		// Start by believing that tweety is a bird
		myWorld.addFormula("tweety_is_a_bird"); // We think that x is a bird
		

		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite("tweety_is_a_bird");
		rule1.setJustificatoin("tweety_can_fly");
		rule1.setConsequence("tweety_can_fly");
		
		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
//		myRules.addRule(rule2);

		DefaultReasoner loader = new DefaultReasoner(myWorld, myRules);
		HashSet<String> extensions = loader.getPossibleScenarios();

		a.e.println("Given the world: \n\t" + myWorld.toString()
				+ "\n And the rules \n\t" + myRules.toString());

		a.e.println("Possible Extensions");
		for (String c : extensions) {
			a.e.println("\t Ext: Th(W U (" + c + "))");
			// Added closure operator
			a.e.incIndent();
			WFF world_and_ext = new WFF("(( " + myWorld.getWorld() + " ) & ("
					+ c + "))");
			a.e.println("= " + world_and_ext.getClosure());
			a.e.decIndent();

		}
		
	}
	

	public static void example2() {
		WorldSet myWorld = new WorldSet();
		// Start by believing that tweety is a bird
		myWorld.addFormula("tweety_is_a_bird"); // We think that x is a bird
		a.e.println("We one day learn that tweety is penguin.");
		// Learn one day that tweety is a penguin 
		myWorld.addFormula("tweety_is_a_penguin");
		// Learn that although they like to think they can fly
		// penguins in fact can not fly
		myWorld.addFormula("(tweety_is_a_penguin " + a.e.IMPLIES + " " + a.e.NOT + "tweety_can_fly)"); 
		

		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite("tweety_is_a_bird");
		rule1.setJustificatoin("tweety_can_fly");
		rule1.setConsequence("tweety_can_fly");
		
		DefaultRule rule2 = new DefaultRule();
		rule2.setPrerequisite("tweety_is_a_bird");
		rule2.setJustificatoin("tweety_is_a_penguin");
		rule2.setConsequence(a.e.NOT + "tweety_can_fly");

		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
		myRules.addRule(rule2);

		DefaultReasoner loader = new DefaultReasoner(myWorld, myRules);
		HashSet<String> extensions = loader.getPossibleScenarios();

		a.e.println("Given the world: \n\t" + myWorld.toString()
				+ "\n And the rules \n\t" + myRules.toString());

		a.e.println("Possible Extensions");
		for (String c : extensions) {
			a.e.println("\t Ext: Th(W U (" + c + "))");
			// Added closure operator
			a.e.incIndent();
			WFF world_and_ext = new WFF("(( " + myWorld.getWorld() + " ) & ("
					+ c + "))");
			a.e.println("= " + world_and_ext.getClosure());
			a.e.decIndent();

		}
		
	}
	
	public static void main(String [] args){
		// Load example
		// Turn on the removal of empty effects from print statements
				a.e.HIDE_EMPTY_EFFECTS_IN_PRINT = true;

		example();
		example2();
	}

}
