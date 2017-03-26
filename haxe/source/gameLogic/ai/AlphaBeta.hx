package gameLogic.ai;
import haxe.Constraints.Function;
import haxe.Timer;
import game.Creature;
import gameLogic.actions.ActionFactory;
import gameLogic.ai.MinMax.MinMaxNode;
import gameLogic.ai.evaluation.EvaluatueBoard;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;
import thx.Tuple.Tuple2;
import utilites.UtilUtil;

/**
 * ...
 * @author 
 */
class AlphaBeta 
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
		getValue : TreeVertex<T>-> Tuple2<TreeVertex<T>,Float>, 
		getPlayerType : T -> Bool, 
		getChildren : TreeVertex<T> -> Int -> Iterable<TreeVertex<T>>,
		alpha : Float,
		beta : Float,
		beforeReturn : T-> Bool = null) : Tuple2<TreeVertex<T>,Float>
	{
		var bestValue : Tuple2<TreeVertex<T>,Float> = new Tuple2<TreeVertex<T>,Float> (node, 0);
		
		if (currentDepth == maxDepth)
		{
			bestValue = getValue(node);
		}
		else if (getPlayerType(node.value))
		{
			bestValue._1 = alpha;
			var counter : Int = 0;
			for (child in getChildren(node, currentDepth)) {
				counter++;
				var childValue = genericAlfaBeta(maxDepth,currentDepth+1,child, getValue, getPlayerType, getChildren, bestValue._1, beta, beforeReturn);
				
				if (bestValue._1 < childValue._1)
				{
					bestValue = childValue;
				}
				
				if (beta <= bestValue._1) {
					break;
				}
			}
			if (counter == 0)
				bestValue = getValue(node);
		}
		else
		{
			bestValue._1 = beta;
			var counter : Int = 0;
			for (child in getChildren(node,currentDepth)) {
				counter++;
				var childValue = genericAlfaBeta(maxDepth,currentDepth+1,child, getValue, getPlayerType, getChildren, alpha, bestValue._1, beforeReturn);
				
				if (bestValue._1 > childValue._1)
				{
					bestValue = childValue;
				}
				
				if (bestValue._1 <= alpha) {
					break;
				}
			}
			if (counter == 0)
				bestValue = getValue(node);
		}
		if (beforeReturn != null)
			beforeReturn(node.value);
			
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