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
	public var movesPerformed : Int;
	public var movesReversed : Int;
	
	private var playerId : Int;
	private var enemyPlayerId : Int;
	private var startCreatureIndex : Int;
	
	private var maximalDepth : Int;
	
	private var shouldGetNextCreature : Bool;
	
	private var treeVertex : TreeVertex<MinMaxNode>;
	
	public function new(depth : Int, shouldGetNextCreature : Bool) 
	{
		super();
		maximalDepth = depth;
		this.shouldGetNextCreature = shouldGetNextCreature;
		boardEvaluator = new BasicBoardEvaluator();
	}
	
	override public function isThreadNeeded():Bool 
	{
		return true;
	}
	
	private function evaluateMinMaxNode(node : TreeVertex<MinMaxNode>) : Tuple2<TreeVertex<MinMaxNode>,Float>
	{
		var time = Timer.stamp();
		var action = ActionFactory.actionFromMoveData(node.value.moveData, null);
		action.performAction();
		movesPerformed++;
		node.value.wasLeaf = true;
		var value = boardEvaluator.evaluateStateSingle(playerId, enemyPlayerId,node.value.moveData);
		nodesVistied++;
		
		GameContext.instance.undoNextAction();
		movesReversed++;
		evaluationTimer += Timer.stamp() - time;
		return new Tuple2<TreeVertex<MinMaxNode>,Float>(node,value);
	}
	
	private function generateChildren(vertex : TreeVertex<MinMaxNode>, currentDepth : Int) : Iterable<TreeVertex<MinMaxNode>>
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
			movesPerformed++;
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
	
	private function onFinish(node : MinMaxNode) : Bool
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
	
	
	private function tryToGetBestLeaf():TreeVertex<MinMaxNode>
	{
		initializeValues();
		var result = AlphaBeta.genericAlfaBeta(maximalDepth, 0, treeVertex, 
			evaluateMinMaxNode,
			getPlayerType,
			generateChildren, -1000000, 1000000,
			onFinish);
		
		traceAndClean();
		return result._0;
	}
	
	private function traceAndClean()
	{
		Creature.ignoreUpdate = false;
		GameContext.instance.redrawCreaturesPositions();
		trace("Total time: " + (Timer.stamp() - totalTimer));
		trace("Move generation time: " + moveGenerationTimer);
		trace("Evaluation time: " + evaluationTimer);
		trace("Nodes visited: " + nodesVistied);
		trace("Children Generated: " + movesGenerated);
		trace("Moves Reversed: " + movesReversed);
		trace("Moves Performed: " + movesPerformed);
		
		if (movesPerformed != movesReversed)
			MainState.getInstance().RestoreMomento(false);
	}
	
	private function initializeValues()
	{
		var minimaxNode = new MinMaxNode(0, null, null);

		treeVertex = new TreeVertex<MinMaxNode>();
		treeVertex.value = minimaxNode;
		treeVertex.value.playerId = GameContext.instance.currentPlayerIndex;
		
		playerId = GameContext.instance.currentPlayerIndex;
		enemyPlayerId =  GameContext.instance.currentPlayerIndex == 0 ? 1 : 0;
		
		totalTimer = Timer.stamp();
		moveGenerationTimer = 0;
		evaluationTimer = 0;
		nodesVistied = 0;
		movesGenerated = 0;
		movesReversed = 0;
		movesPerformed = 0;
		
		startCreatureIndex = GameContext.instance.inititativeQueue.getCurrentPosition();
		trace(GameContext.instance.inititativeQueue.getOnPlace(startCreatureIndex).name + " " + GameContext.instance.inititativeQueue.getOnPlace(startCreatureIndex).id);
	}
	
	override public function generateMoveFuture():Array<MoveData> 
	{
		var moves = new Array<MoveData>();
		var currentNode = tryToGetBestLeaf();
		
		trace((currentNode == null) + " " + (currentNode.parent == null));
		
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