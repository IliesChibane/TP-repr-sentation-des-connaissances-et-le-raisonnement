package be.fnord.DefaultLogic;

import java.util.HashSet;

import be.fnord.util.logic.DefaultReasoner;
import be.fnord.util.logic.WFF;
import be.fnord.util.logic.defaultLogic.DefaultRule;
import be.fnord.util.logic.defaultLogic.RuleSet;
import be.fnord.util.logic.defaultLogic.WorldSet;

public class SydneyPapers {

	public static void main(String [] args) {
		// Slide 1
//		Tweety1();
//		Tweety2();
		
		// Slide 2
//		PersonHometown();
//		PersonHometown2();
		
		// Slide 3
//		FalseIfNotTrue();
//		FalseIfNotTrue2();

		//Slide N
//		SpouseEmployerHometown();
//		SpouseEmployerHometown2();

//		FirstExampleAfterDefinition();
//		SecondExampleAfterDefinition();
		ThirdExampleAfterDefinition();
	}
	
	public static void Tweety1() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		myWorld.addFormula("Birdx"); // Bird(x)

		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite("Birdx");			// Bird(x)	
		rule1.setJustificatoin("Flyx");		// Fly(x)
		rule1.setConsequence("Flyx");			// Fly(x)

		
		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
		
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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			
			a.e.decIndent();

		}
	}
	
	public static void Tweety2() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		myWorld.addFormula("(Penguinx)"); // Penguin(x)
		myWorld.addFormula("(Birdx)"); // Bird(x)
		myWorld.addFormula("(Penguinx -> ~Flyx)"); // Penguin(x)
		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite("Birdx");			// Bird(x)	
		rule1.setJustificatoin("Flyx");		// Fly(x)
		rule1.setConsequence("Flyx");			// Fly(x)

		
		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
		
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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	}
	
	public static void PersonHometown() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		myWorld.addFormula("PersonX"); // Bird(x)

		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite("PersonX");			// Bird(x)	
		rule1.setJustificatoin("HometownSydX");		// Fly(x)
		rule1.setConsequence("HometownSydX");			// Fly(x)

		
		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
		
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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	}

	
	public static void PersonHometown2() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		myWorld.addFormula("PersonX"); // Bird(x)
		myWorld.addFormula("~HometownSydX"); // Bird(x)

		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite("PersonX");			// Bird(x)	
		rule1.setJustificatoin("HometownSydX");		// Fly(x)
		rule1.setConsequence("HometownSydX");			// Fly(x)

		
		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
		
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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	}

	
	public static void FalseIfNotTrue() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

	
		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite(a.e.EMPTY_EFFECT);			// Bird(x)	
		rule1.setJustificatoin("~ConnectABC");		// Fly(x)
		rule1.setConsequence("~ConnectABC");			// Fly(x)

		
		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
		
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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	}	

	public static void FalseIfNotTrue2() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		myWorld.addFormula("ConnectABC"); // Bird(x)
		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite(a.e.EMPTY_EFFECT);			// Bird(x)	
		rule1.setJustificatoin("~ConnectABC");		// Fly(x)
		rule1.setConsequence("~ConnectABC");			// Fly(x)

		
		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
		
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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	}	
	
	public static void SpouseEmployerHometown() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		myWorld.addFormula("(SpouseXY & hometownYZ)"); 
		myWorld.addFormula("(EmployerXY & locationYZ)");
		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite("(SpouseXY & hometownYZ)");				
		rule1.setJustificatoin("hometownXZ");		
		rule1.setConsequence("hometownXZ");			

		DefaultRule rule2 = new DefaultRule();
		rule2.setPrerequisite("(EmployerXY & locationYZ)");				
		rule2.setJustificatoin("hometownXZ");
		rule2.setConsequence("hometownXZ");	

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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	}	

	public static void SpouseEmployerHometown2() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		myWorld.addFormula("(SpouseXY & hometownYZ)"); 
		myWorld.addFormula("(EmployerXY & locationYP)");
		
		myWorld.addFormula("~(hometownXZ & hometownXP)");	// Constraint on the function of hometown
		
		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite("(SpouseXY & hometownYZ)");				
		rule1.setJustificatoin("hometownXZ");		
		rule1.setConsequence("hometownXZ");			

		DefaultRule rule2 = new DefaultRule();
		rule2.setPrerequisite("(EmployerXY & locationYP)");				
		rule2.setJustificatoin("hometownXP");
		rule2.setConsequence("hometownXP");	

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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	}	
	
	
	public static void FirstExampleAfterDefinition() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		myWorld.addFormula("(B -> ~A & ~C)"); 
		
		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite(a.e.EMPTY_EFFECT);				
		rule1.setJustificatoin("A");		
		rule1.setConsequence("A");			

		DefaultRule rule2 = new DefaultRule();
		rule2.setPrerequisite(a.e.EMPTY_EFFECT);				
		rule2.setJustificatoin("B");		
		rule2.setConsequence("B");			

		DefaultRule rule3 = new DefaultRule();
		rule3.setPrerequisite(a.e.EMPTY_EFFECT);				
		rule3.setJustificatoin("C");		
		rule3.setConsequence("C");			

		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
		myRules.addRule(rule2);
		myRules.addRule(rule3);
		
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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	}
	
	public static void SecondExampleAfterDefinition() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		
		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite(a.e.EMPTY_EFFECT);				
		rule1.setJustificatoin("C");		
		rule1.setConsequence("~D");			

		DefaultRule rule2 = new DefaultRule();
		rule2.setPrerequisite(a.e.EMPTY_EFFECT);				
		rule2.setJustificatoin("D");		
		rule2.setConsequence("~E");			

		DefaultRule rule3 = new DefaultRule();
		rule3.setPrerequisite(a.e.EMPTY_EFFECT);				
		rule3.setJustificatoin("E");		
		rule3.setConsequence("~F");			

		RuleSet myRules = new RuleSet();
		myRules.addRule(rule1);
		myRules.addRule(rule2);
		myRules.addRule(rule3);
		
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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	}
	
	public static void ThirdExampleAfterDefinition() {
		WorldSet myWorld = new WorldSet();
		myWorld.addFormula(a.e.EMPTY_EFFECT);

		
		DefaultRule rule1 = new DefaultRule();
		rule1.setPrerequisite(a.e.EMPTY_EFFECT);				
		rule1.setJustificatoin("C");		
		rule1.setConsequence("~D");			

		DefaultRule rule2 = new DefaultRule();
		rule2.setPrerequisite(a.e.EMPTY_EFFECT);				
		rule2.setJustificatoin("D");		
		rule2.setConsequence("~C");			

	
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
			a.e.println("= " + world_and_ext.getClosure()
						// Input Cleanup
						.replaceAll("eeee", "")
						.replaceAll("&&", "&")
						.replaceAll("& &", "&")
						.replaceAll("&  &", "&")
						.replaceAll("&   &", "&")
						.replaceAll("^ &", "")
						.replaceAll("^&", ""));
			a.e.decIndent();

		}
	
	}
}
