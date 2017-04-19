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

	public function new(depth : Int, shouldGetNextCreature : Bool) 
	{
		super(depth,shouldGetNextCreature);
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

	override function evaluateMinMaxNode(node : TreeVertex<MinMaxNode>) : Tuple2<TreeVertex<MinMaxNode>,Float>
	{
		var time = Timer.stamp();
		var action = ActionFactory.actionFromMoveData(node.value.moveData, null);
		var value = 0;
		if (action != null)
		{
			action.performAction();
			movesPerformed++;
			node.value.wasLeaf = true;
			nodesVistied++;
			GameContext.instance.undoNextAction();
			movesReversed++;
		}
		else
		{
			var value = boardEvaluator.evaluateStateSingle(playerId, enemyPlayerId);
			value *= getPlayerColor(node.value);
			nodesVistied++;
		}
		
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