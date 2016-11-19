package gameLogic.ai;
import game.Creature;
import gameLogic.actions.ActionFactory;
import gameLogic.ai.ArtificialInteligence;
import gameLogic.ai.evaluation.EvaluationMethod;
import gameLogic.moves.MoveData;

/**
 * ...
 * @author 
 */
class MinMax extends ArtificialInteligence
{
	private var evaluationMethod:EvaluationMethod;
	private var maxDepth:Int;
	private var howManyUndo:Int;
	public function new(depth:Int ,evaluationMethod:EvaluationMethod) 
	{
		this.evaluationMethod = evaluationMethod;
		maxDepth = depth;
		howManyUndo = 0;
		super();
	}
	
	private function goToNextLevel(creature:Creature)
	{
		var currentDepth = howManyUndo;
		howManyUndo++;
		var listOfMoves = GameContext.instance.generateListOfMovesForCreature(creature);
		var selectedMove = listOfMoves.moves[0];
		var action = ActionFactory.actionFromMoveData(selectedMove, null);
		
		action.performAction();
		
		if (howManyUndo < maxDepth)
			goToNextLevel(GameContext.instance.getNextCreature());
		
		trace(currentDepth);
	}
	
	private function restoreContext()
	{
		GameContext.instance.getNextCreature();
		for (i in 0 ... howManyUndo)
			GameContext.instance.undoNextAction();
				
		howManyUndo = 0;
	}	

	
	override public function generateMove():MoveData 
	{ 
		goToNextLevel(GameContext.instance.currentCreature);
		restoreContext();
		return null;
	}
	
	
	
}