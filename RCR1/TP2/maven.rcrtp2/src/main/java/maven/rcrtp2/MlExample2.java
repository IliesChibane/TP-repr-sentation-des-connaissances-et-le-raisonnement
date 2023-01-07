package maven.rcrtp2;

import java.io.IOException;

import org.tweetyproject.commons.ParserException;
import org.tweetyproject.logics.commons.syntax.Predicate;
import org.tweetyproject.logics.commons.syntax.RelationalFormula;
import org.tweetyproject.logics.fol.syntax.FolFormula;
import org.tweetyproject.logics.fol.syntax.FolSignature;
import org.tweetyproject.logics.ml.parser.MlParser;
import org.tweetyproject.logics.ml.reasoner.AbstractMlReasoner;
import org.tweetyproject.logics.ml.reasoner.MleanCoPReasoner;
import org.tweetyproject.logics.ml.reasoner.SPASSMlReasoner;
import org.tweetyproject.logics.ml.reasoner.SimpleMlReasoner;
import org.tweetyproject.logics.ml.syntax.MlBeliefSet;


public class MlExample2 {
	public static void main(String[] args) throws ParserException, IOException {
		MlBeliefSet bs = new MlBeliefSet();
		MlParser parser = new MlParser();
		FolSignature sig = new FolSignature();
		sig.add(new Predicate("p", 0));
		sig.add(new Predicate("q", 0));
		
		parser.setSignature(sig);
		bs.add((RelationalFormula) parser.parseFormula("<>(p && q)")); 
		bs.add((RelationalFormula) parser.parseFormula("[](!(p) || q)")); 
		bs.add((RelationalFormula) parser.parseFormula("[](q && <>(!(q)))")); 
		

		System.out.println("Modal knowledge base: " + bs);
		SimpleMlReasoner reasoner = new SimpleMlReasoner();
		System.out.println("[](!p)      " + reasoner.query(bs, (FolFormula) parser.parseFormula("[](!p)"))+"\n");
		System.out.println("<>(p && q)      " + reasoner.query(bs, (FolFormula) parser.parseFormula("<>(p && q)"))+"\n");
		
	}
}
