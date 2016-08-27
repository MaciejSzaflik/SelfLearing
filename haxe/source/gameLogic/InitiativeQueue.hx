package gameLogic;
import game.Creature;
import haxe.ds.ListSort;

/**
 * ...
 * @author 
 */
class InitiativeQueue
{
	private var queue:Array<Creature>;
	
	public function new() 
	{
		queue = new Array<Creature>();
	}
	
	public function fillWithPlayers(players:Map<Int,Player>)
	{
		for (player in players)
		{
			for (creature in player.creatures)
			{
				queue.push(creature);
			}
		}
		queue.sort(function(x:Creature, y:Creature):Int 
		{
			if (x.initiative == y.initiative)
				return Random.int( -1, 1);
			else
				return x.initiative - y.initiative;
		});		
	}
	
	public function getNextCreature():Creature
	{
		return onPop(queue.pop());
	}
	
	public function onPop(creature:Creature):Creature
	{
		if (creature == null)
			return null;
		creature.currentActionPoints = creature.range;
		creature.contrattackCountter = 0;
		creature.moved = false;
		return creature;
	}
	
	public function removeCreatureFromQueue(toRemove:Creature)
	{
		queue.remove(toRemove);
	}
	
}