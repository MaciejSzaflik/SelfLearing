package gameLogic.ai.depth;

import gameLogic.ai.AlphaBeta;
import gameLogic.ai.MinMax.MinMaxNode;
import gameLogic.ai.evaluation.EvaluatueBoard;
import gameLogic.ai.tree.TreeVertex;
import thx.Tuple.Tuple2;

/**
 * ...
 * @author ...
 */
class ConcreteNegaScout extends ConcreteNegaMax 
{

	public function new(depth : Int, shouldGetNextCreature : Bool, fliping : Bool) 
	{
		super(depth,shouldGetNextCreature,fliping);
	}

	override function tryToGetBestLeaf():TreeVertex<MinMaxNode>
	{
		initializeValues();

		var startAlfa =  new Tuple2<TreeVertex<MinMaxNode>,Float>(treeVertex, -1000000);
		var startBeta =  new Tuple2<TreeVertex<MinMaxNode>,Float>(treeVertex, 1000000);
		
		var result = NegaScout.genericNegaScout(treeVertex, maximalDepth, 0, startAlfa, startBeta,
			getPlayerColor,
			evaluateMinMaxNode,
			generateChildren,
			onFinish);

		traceAndClean();
		return result._0;
	}
	
	override private function onFinish(node : MinMaxNode) : Bool
	{
		if (node.moveData == null)
			return false;
			
		if (!node.wasLeaf)
		{
			
			GameContext.instance.undoNextAction();
			movesReversed++;
		}
		return true;
	}
}