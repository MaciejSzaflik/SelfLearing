package gameLogic.ai;
import haxe.Constraints.Function;
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
		super();
		this.evaluationMethod = evaluationMethod;
		maxDepth = depth;
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
	
	
	public static function genericAlfaBeta<T>(
		maxDepth : Int, 
		currentDepth : Int,
		node : TreeVertex<T>, 
		getValue : T->Float, 
		getPlayerType : T -> Bool, 
		getChildren : TreeVertex<T> -> Iterable<TreeVertex<T>>,
		alpha : Float,
		beta : Float) : Float
	{
		var bestValue : Float;
		if (currentDepth == maxDepth)
		{
			bestValue = getValue(node.value);
		}
		else if (getPlayerType(node.value))
		{
			bestValue = alpha;
			var counter : Int = 0;
			for (child in getChildren(node)) {
				counter++;
				var childValue = genericAlfaBeta(maxDepth,currentDepth+1,child, getValue, getPlayerType, getChildren, bestValue, beta);
				bestValue = Std.int(Math.max(bestValue, childValue));
				if (beta <= bestValue) {
					break;
				}
			}
			if (counter == 0)
				bestValue = getValue(node.value);
		}
		else
		{
			bestValue = beta;
			var counter : Int = 0;
			for (child in getChildren(node)) {
				counter++;
				var childValue = genericAlfaBeta(maxDepth,currentDepth+1,child, getValue, getPlayerType, getChildren, alpha, bestValue);
				bestValue = Std.int(Math.min(bestValue, childValue));
				if (bestValue <= alpha) {
					break;
				}
			}
			if (counter == 0)
				bestValue = getValue(node.value);
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
	
	private function restoreContext()	
	{
		GameContext.instance.getNextCreature();
		for (i in 0 ... howManyUndo)
			GameContext.instance.undoNextAction();
				
		howManyUndo = 0;
	}	

	override public function generateMove():MoveData 
	{ 
		return null;
	}
}


class SimpleNode
{
	public var value : Null<Int>;
	public var maximazingPlayer : Bool;
	
	public function getValue() : Float
	{
		return value;
	}
	public function getPlayerType() : Bool
	{
		return maximazingPlayer;
	}
	
	public function getColor() : Int
	{
		return maximazingPlayer ? 1 : -1;
	}
	
	public function new(value : Null<Int>, maximazingPlayer : Bool)
	{
		this.maximazingPlayer = maximazingPlayer;
		this.value = value;
	}
	
	 public function toString() {
        return "("+value+","+maximazingPlayer+")";
    }
}