package gameLogic.ai.evaluation;
import game.Creature;
import gameLogic.moves.ListOfMoves;
import gameLogic.ai.evaluation.EvaluationMethod;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;

/**
 * ...
 * @author 
 */
class KillTheWeakest implements EvaluationMethod
{
	public var strongest:Bool = false;
	public var opponentCreatures:Array<Creature>;
	public function new(strongest:Bool) 
	{
		this.strongest = strongest;
	}
	
	public function evaluateMoves(listOfMoves:ListOfMoves):EvaluationResult 
	{
		var result = new EvaluationResult(listOfMoves);
		sortTheOpponentCreature();
		if (opponentCreatures.length == 0)
			return result;
		
		var index:Int = 0;
		var creatureTileId = GameContext.instance.currentCreature.getTileId();
		for (move in listOfMoves.moves)
		{
			var currentDistance = GameContext.instance.map.getManhatanDistance(creatureTileId, opponentCreatures[0].getTileId());
			var afterMoveDistance = GameContext.instance.map.getManhatanDistance(move.tileId, opponentCreatures[0].getTileId()); 
			var currentRanking = Math.floor(currentDistance - afterMoveDistance);
			if (move.type == MoveType.Attack)
			{
				if (opponentCreatures[0].id == move.attacked.id)
					currentRanking = 1000 - currentRanking;
				else
					currentRanking = 1 - currentRanking;
			}

			result.evaluationResults[index] = currentRanking;
			result.tryToSetBestIndex(index);
			index++;
		}	
		return result;
	}
	
	public function sortTheOpponentCreature()
	{
		opponentCreatures = new Array<Creature>();
		for (player in GameContext.instance.mapOfPlayers)
		{
			if (player.id != GameContext.instance.currentCreature.idPlayerId)
				opponentCreatures = opponentCreatures.concat(player.creatures);
		}
		opponentCreatures.sort(function(x:Creature, y:Creature):Int {
			if(!strongest)
				return x.totalHealth - y.totalHealth;
			else
				return y.totalHealth - x.totalHealth;
		});
	}
	
}