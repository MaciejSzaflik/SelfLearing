package gameLogic.ai.depth;

import gameLogic.actions.ActionFactory;
import gameLogic.ai.ArtificialInteligence;
import gameLogic.ai.MinMax.MinMaxNode;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;
import haxe.Timer;
import thx.Tuple.Tuple2;

/**
 * ...
 * @author ...
 */
class ConcreteNegaMax extends ConcreteAlphaBeta
{

	var fliping  : Bool;
	
	public function new(depth : Int, shouldGetNextCreature : Bool, fliping : Bool) 
	{
		super(depth, shouldGetNextCreature);
		this.fliping = fliping;
	}

	override function tryToGetBestLeaf():TreeVertex<MinMaxNode>
	{
		initializeValues();

		var result = NegaMax.genericNegaMax(treeVertex, maximalDepth, 0, -1000000, 1000000,
		getPlayerColor,
		evaluateMinMaxNode,
		generateChildren,
		onFinish);

		traceAndClean();
		return result._0;
	}

	private inline function getPlayerColor(node : MinMaxNode) : Int
	{
		return (node.playerId == playerId) ? 1 : -1;
	}

	override function evaluateMinMaxNode(value:Bool,node : TreeVertex<MinMaxNode>) : Tuple2<TreeVertex<MinMaxNode>,Float>
	{
		var time = Timer.stamp();
		var move = node.value.moveData;
		var action = ActionFactory.actionFromMoveData(move, null);
		var value = 0.0;
		if (action != null && move!=null)
		{
			action.performAction();
			node.value.wasLeaf = true;
			
			value = CurrentStateData.EvaluateForPlayer(this.playerId);
			
			GameContext.instance.undoNextAction();
			movesReversed++;
		}
		else
		{
			value = CurrentStateData.EvaluateForPlayer(this.playerId);
			nodesVistied++;
		}
		value *= getPlayerColor(node.value);
		
		evaluationTimer += Timer.stamp() - time;
		return new Tuple2<TreeVertex<MinMaxNode>,Float>(node, value);
	}
	
	override public function generateMoveFuture():Array<MoveData> 
	{
		var moves = new Array<MoveData>();
		var currentNode = tryToGetBestLeaf();
		
		while (currentNode != null && currentNode.parent != null)
		{
			moves.push(currentNode.value.moveData);
			currentNode = currentNode.parent;
		}
		return moves;
	}

}