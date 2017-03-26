package gameLogic.ai.depth;

import gameLogic.actions.ActionFactory;
import gameLogic.ai.ArtificialInteligence;
import gameLogic.ai.MinMax;
import gameLogic.ai.MinMax.MinMaxNode;
import gameLogic.ai.evaluation.BasicBoardEvaluator;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;
import haxe.Timer;

/**
 * ...
 * @author ...
 */
class ConcreteAlphaBeta extends ArtificialInteligence 
{
	private var boardEvaluator : BasicBoardEvaluator;
	
	public var totalTimer : Float;
	public var moveGenerationTimer : Float;
	public var evaluationTimer : Float;
	public var nodesVistied : Int;
	private var playerId : Int;
	private var enemyPlayerId : Int;
	private var startCreatureIndex : Int;
	
	public function new() 
	{
		super();
		boardEvaluator = new BasicBoardEvaluator();
	}
	
	private inline function evaluateMinMaxNode(node : MinMaxNode) : Float
	{
		var time = Timer.stamp();
		var action = ActionFactory.actionFromMoveData(node.moveData, null);
		action.performAction();
		node.wasLeaf = true;
		var value = boardEvaluator.evaluateStateSingle(playerId, enemyPlayerId);
		nodesVistied++;
		GameContext.instance.undoNextAction();
		
		evaluationTimer += Timer.stamp() - time;
		return value;
	}
	
	private inline function generateChildren(vertex : TreeVertex<MinMaxNode>, currentDepth : Int) : Iterable<TreeVertex<MinMaxNode>>
	{
		var time = Timer.stamp();
		var creature = GameContext.instance.inititativeQueue.getInOrder(startCreatureIndex + currentDepth);

		if (vertex.value.moveData != null)
		{
			var action = ActionFactory.actionFromMoveData(vertex.value.moveData, null);
			action.performAction();
		}
		var toReturn = GameContext.instance.generateTreeVertexListMoves(vertex,creature);
		moveGenerationTimer += Timer.stamp() - time;
		return toReturn;
	}
	
	private inline function getPlayerType(node : MinMaxNode) : Bool
	{
		return node.playerId == playerId;
	}
	
	private inline function onFinish(node : MinMaxNode) : Bool
	{
		if (node.moveData == null)
			return false;
		if(!node.wasLeaf)
			GameContext.instance.undoNextAction();
		return true;
	}
	
	
	override public function generateMove():MoveData 
	{
		var minimaxNode = new MinMaxNode(0, null, null);

		var treeVertex = new TreeVertex<MinMaxNode>();
		treeVertex.value = minimaxNode;
		treeVertex.value.playerId = GameContext.instance.currentPlayerIndex;
		
		playerId = GameContext.instance.currentPlayerIndex;
		enemyPlayerId =  GameContext.instance.currentPlayerIndex == 0 ? 1 : 0;
		
		totalTimer = Timer.stamp();
		moveGenerationTimer = 0;
		evaluationTimer = 0;
		nodesVistied = 0;
		
		startCreatureIndex = GameContext.instance.inititativeQueue.getCurrentPosition();
		
		var result = AlphaBeta.genericAlfaBeta(4, 0, treeVertex, evaluateMinMaxNode,
			getPlayerType,
			generateChildren, -1000000, 1000000,
			onFinish);
			
		GameContext.instance.redrawCreaturesPositions();
		trace("Total time: " + (Timer.stamp() - totalTimer));
		trace("Move generation time: " + moveGenerationTimer);
		trace("Evaluation time: " + evaluationTimer);
		trace("Nodes visited: " + nodesVistied);
		trace(result);
		return null;
	}
	
}