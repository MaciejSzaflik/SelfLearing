package gameLogic.ai;
import haxe.Timer;
import game.Creature;
import gameLogic.actions.ActionFactory;
import gameLogic.ai.MinMax.MinMaxNode;
import gameLogic.ai.evaluation.EvaluatueBoard;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;
import utilites.UtilUtil;

/**
 * ...
 * @author 
 */
class AlphaBeta extends ArtificialInteligence
{
	private var evaluationMethod:EvaluatueBoard;
	private var maxDepth:Int;
	private var howManyUndo:Int;
	private var alpha : Float;
	private var beta : Float;
	private var maximazingPlayer : Int;
	private var bestnode : TreeVertex<MinMaxNode>;
	
	public function new(depth:Int ,evaluationMethod:EvaluatueBoard = null) 
	{
		this.evaluationMethod = evaluationMethod;
		maxDepth = depth;
		howManyUndo = 0;
		super();
	}
	
	private function generateTree():TreeVertex<MinMaxNode>
	{
		alpha = -1000000;
		beta = 1000000;
		maximazingPlayer = GameContext.instance.currentCreature.idPlayerId;
		var treeRoot = new TreeVertex<MinMaxNode>(null, null);
		bestnode = treeRoot;
		goToNextLevel(null, treeRoot, GameContext.instance.currentCreature, 1);
		return treeRoot;
	}
	
	private function alphaBeta(node:MinMaxNode, alpha:Float, beta:Float, maximisingPlayer:Int, depth:Int) : Float
	{
		var bestValue : Float = 0;
		if (depth == maxDepth)
		{
			var action = ActionFactory.actionFromMoveData(node.moveData, null);
			action.performAction();
			
			var evalResult = evaluationMethod.evaluateState(node.playerId, GameContext.instance.getEnemyId(node.playerId));
			node.nodeValue = evalResult._0 * (1 / evalResult._1);
			bestValue = node.nodeValue;
		}
		
		return bestValue;
		
	}
	
	public static function valueAlfaBeta(node : TreeVertex<SimpleNode>,alpha,beta) : Int
	{
		var bestValue : Int;
		if (node.childrenCount() == 0)
		{
			bestValue = node.value.value;
		}
		else if (node.value.maximazingPlayer) 
		{
			bestValue = alpha;
			for (child in node.children) {
				var childValue = valueAlfaBeta(child, bestValue, beta);
				bestValue = Std.int(Math.max(bestValue, childValue));
				if (beta <= bestValue) {
					break;
				}
			}
		}
		else
		{
			bestValue = beta;
			for (child in node.children) {
				var childValue = valueAlfaBeta(child, alpha, bestValue);
				bestValue = Std.int(Math.min(bestValue, childValue));
				if (bestValue <= alpha) {
					break;
				}
			}
		}
		
		return bestValue;
	}
	
	private function goToNextLevel(leadingMove: MoveData, currentRoot:TreeVertex<MinMaxNode>, creature:Creature,depth : Int)
	{
		if (creature == null)
			return;
		
		var bestValue = 0;
		var listOfMoves = GameContext.instance.generateListOfMovesForCreature(creature);
		var newNode = new MinMaxNode( -1, leadingMove, listOfMoves);
		var index = currentRoot.addChild(newNode);
		newNode.vertId = index;
		newNode.nodeValue = 0;
		if (depth >= maxDepth)
			return
		else
		{
			if (leadingMove != null)
			{
				var action = ActionFactory.actionFromMoveData(leadingMove, null);
				action.performAction();
				newNode.playerId = action.performer.idPlayerId;
				var evalResult = evaluationMethod.evaluateState(newNode.playerId, GameContext.instance.getEnemyId(newNode.playerId));
				newNode.nodeValue = evalResult._0 * (1 / evalResult._1);
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


class SimpleNode
{
	public var value : Null<Int>;
	public var maximazingPlayer : Bool;
	
	public function new(value : Null<Int>, maximazingPlayer : Bool)
	{
		this.maximazingPlayer = maximazingPlayer;
		this.value = value;
	}
	
	 public function toString() {
        return "("+value+","+maximazingPlayer+")";
    }
}