package gameLogic.ai;
import game.Creature;

/**
 * ...
 * @author 
 */
class EnemyQueue extends ArtificialInteligence
{
	public var enemies : Array<Creature>;
	public var enemiesValues : Map<Int,Float>;
	public function new(playerId : Int) 
	{
		super();
		enemies = new Array<Creature>();
		enemiesValues = new Map<Int,Float>();

		for (creature in GameContext.instance.getEnemies(playerId))
		{
			enemies.push(creature);
			enemiesValues.set(creature.id, 0);
		}	
		UpdateValues();
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
		return 0.0;
	}
	
	
	
}