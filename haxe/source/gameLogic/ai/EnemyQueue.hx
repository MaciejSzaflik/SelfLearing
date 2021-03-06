package gameLogic.ai;
import game.Creature;
import gameLogic.ai.evaluation.EnemySelectEvaluation;
import gameLogic.ai.evaluation.EvaluationResult;
import gameLogic.moves.MoveData;

/**
 * ...
 * @author 
 */
class EnemyQueue extends ArtificialInteligence
{
	private static inline var rangerMultiplayer = 2.0;
	
	public var enemies : Array<Creature>;
	public var enemiesValues : Map<Int,Float>;
	private var evaluator : EnemySelectEvaluation;
	
	public function new(playerId : Int, evaluator : EnemySelectEvaluation) 
	{
		super();
		enemies = new Array<Creature>();
		enemiesValues = new Map<Int,Float>();
		this.evaluator = evaluator;
		this.evaluator.SetEnemyQueue(this);
		
		for (creature in GameContext.instance.getEnemies(playerId))
		{
			enemies.push(creature);
			enemiesValues.set(creature.id, 0);
		}	
	}
	
	public function toString()
	{
		return "EnemyQueue : " + evaluator;
	}
	
	override public function generateMove():MoveData 
	{
		return getEvaluationResult().getBestMove();
	}
	
	public function getEvaluationResult() : EvaluationResult
	{
		UpdateValues();
		var listOfMoves = GameContext.instance.generateMovesForCurrentCreature();
		return evaluator.evaluateMoves(listOfMoves);
	}
	
	public function UpdateValues()
	{
		for (creature in enemies)
		{
			enemiesValues.set(creature.id, CalculateCreatureAIValue(creature));
		}
		enemies.sort(function(x:Creature, y:Creature):Int 
		{
			return Std.int(enemiesValues.get(x.id) - enemiesValues.get(y.id));
		});		
	}
	
	private function CalculateCreatureAIValue(creature : Creature) : Float
	{
		var multipler = creature.attackRange > 1 ? rangerMultiplayer : 1;
		
		return (creature.calculateAttack() / creature.totalHealth)*multipler;
	}
}