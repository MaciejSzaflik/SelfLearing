package gameLogic.ai.depth;

import gameLogic.ai.AlphaBeta;
import gameLogic.ai.evaluation.EvaluatueBoard;

/**
 * ...
 * @author ...
 */
class ConcreteNegaScout extends ConcreteNegaMax 
{

	public function new(depth : Int, shouldGetNextCreature : Bool) 
	{
		super(depth,shouldGetNextCreature);
	}

	override function tryToGetBestLeaf():TreeVertex<MinMaxNode>
	{
		initializeValues();

		var result = NegaScout.genericNegaScout(treeVertex, maximalDepth, 0, -1000000, 1000000,
		getPlayerColor,
		evaluateMinMaxNode,
		generateChildren,
		onFinish);

		traceAndClean();
		return result._0;
	}
}