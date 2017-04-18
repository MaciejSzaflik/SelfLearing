package gameLogic.ai.depth;

import game.Creature;
import gameLogic.actions.ActionFactory;
import gameLogic.ai.ArtificialInteligence;
import gameLogic.ai.MinMax;
import gameLogic.ai.MinMax.MinMaxNode;
import gameLogic.ai.evaluation.BasicBoardEvaluator;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;
import haxe.Timer;
import thx.Tuple.Tuple2;

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
	public var movesGenerated : Int;
	
	private var playerId : Int;
	private var enemyPlayerId : Int;
	private var startCreatureIndex : Int;
	
	private var maximalDepth : Int;
	
	private var shouldGetNextCreature : Bool;
	
	public function new(depth : Int, shouldGetNextCreature : Bool) 
	{
		super();
		maximalDepth = depth;
		this.shouldGetNextCreature = shouldGetNextCreature;
		boardEvaluator = new BasicBoardEvaluator();
	}
	
	private inline function evaluateMinMaxNode(node : TreeVertex<MinMaxNode>) : Tuple2<TreeVertex<MinMaxNode>,Float>
	{
		var time = Timer.stamp();
		var action = ActionFactory.actionFromMoveData(node.value.moveData, null);
		action.performAction();
		node.value.wasLeaf = true;
		var value = boardEvaluator.evaluateStateSingle(playerId, enemyPlayerId);
		nodesVistied++;
		GameContext.instance.undoNextAction();
		
		evaluationTimer += Timer.stamp() - time;
		return new Tuple2<TreeVertex<MinMaxNode>,Float>(node,value);
	}
	
	private inline function generateChildren(vertex : TreeVertex<MinMaxNode>, currentDepth : Int) : Iterable<TreeVertex<MinMaxNode>>
	{
		var time = Timer.stamp();
		var creature = null;
		if(shouldGetNextCreature)
			creature = GameContext.instance.inititativeQueue.getOnPlace(startCreatureIndex + currentDepth);
		else
			creature = GameContext.instance.inititativeQueue.getOnPlace(startCreatureIndex);
		
		if (vertex.value.moveData != null)
		{
			var action = ActionFactory.actionFromMoveData(vertex.value.moveData, null);
			action.performAction();
		}
		var toReturn = GameContext.instance.generateTreeVertexListMoves(vertex,creature);
		moveGenerationTimer += Timer.stamp() - time;
		movesGenerated += toReturn.length;
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
	
	
	private function tryToGetBestLeaf():TreeVertex<MinMaxNode>
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
		movesGenerated = 0;
		
		startCreatureIndex = GameContext.instance.inititativeQueue.getCurrentPosition();
		trace(startCreatureIndex);
		trace(GameContext.instance.inititativeQueue.getOnPlace(startCreatureIndex).name);
		
		var result = AlphaBeta.genericAlfaBeta(maximalDepth, 0, treeVertex, 
			evaluateMinMaxNode,
			getPlayerType,
			generateChildren, -1000000, 1000000,
			onFinish);
		
		Creature.ignoreUpdate = false;
		GameContext.instance.redrawCreaturesPositions();
		trace("Total time: " + (Timer.stamp() - totalTimer));
		trace("Move generation time: " + moveGenerationTimer);
		trace("Evaluation time: " + evaluationTimer);
		trace("Nodes visited: " + nodesVistied);
		trace("Children Generated: " + movesGenerated);
		
		return result._0;
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
	
	override public function generateMove():MoveData 
	{
		var moveData = TreeVertex.getOneBeforeRoot(tryToGetBestLeaf()).value.moveData;
		return moveData;
	}
	
}