package gameLogic.ai;
import game.Creature;
import gameLogic.actions.ActionFactory;
import gameLogic.ai.ArtificialInteligence;
import gameLogic.ai.evaluation.EvaluationMethod;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.ListOfMoves;
import gameLogic.moves.MoveData;
import haxe.Timer;

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
	
	private function generateTree():TreeVertex<MinMaxNode>
	{
		var treeRoot = new TreeVertex<MinMaxNode>(null,null);
		goToNextLevel(null, treeRoot, GameContext.instance.currentCreature, 1);
		return treeRoot;
	}
	
	private function goToNextLevel(leadingMove: MoveData, currentRoot:TreeVertex<MinMaxNode>, creature:Creature,depth : Int)
	{
		if (creature == null)
			return;
		
		var listOfMoves = GameContext.instance.generateListOfMovesForCreature(creature);
		//evaluate
		var newNode = new MinMaxNode( -1, leadingMove, listOfMoves);
		var index = currentRoot.addChild(newNode);
		newNode.vertId = index;
		if (depth >= maxDepth)
			return
		else
		{
			if (leadingMove != null)
			{
				var action = ActionFactory.actionFromMoveData(leadingMove, null);
				action.performAction();
			}
			
			var nextCreature = GameContext.instance.getNextCreature();
			for (moveData in listOfMoves.moves)
			{
				goToNextLevel(moveData, currentRoot.getByIndex(index), nextCreature, depth + 1);
			}
		}
		
		if (leadingMove != null)
		{
			GameContext.instance.undoNextAction();
		}
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
		var timer = Timer.stamp();
		trace(generateTree().treeToString() + " " +  (Timer.stamp() - timer));
		return null;
	}
}

class MinMaxNode
{
	public var moveData : MoveData;
	public var listOfMoves : ListOfMoves;
	public var vertId : Int;
	
	public function new(vertId : Int, moveData : MoveData, listOfMoves : ListOfMoves)
	{
		this.moveData = moveData;
		this.vertId = vertId;
		this.listOfMoves = listOfMoves;
	}
}