package gameLogic;
import game.Creature;
import haxe.Constraints.Function;
import haxe.ds.ListSort;

/**
 * ...
 * @author 
 */
class InitiativeQueue
{
	public var queue:Array<Creature>;
	private var fillListeners:List<Function>;
	private var popListeners:List<Function>;
	private var killListeners:List<Function>;
	
	public function new() 
	{
		queue = new Array<Creature>();
		fillListeners = new List<Function>();
		popListeners = new List<Function>();
		killListeners = new List<Function>();
	}
	
	public function fillWithPlayers(players:Map<Int,GamePlayer>)
	{
		for (player in players)
		{
			for (creature in player.creatures)
			{
				if(creature != null)
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
		informOnFill();
	}
	
	public function getNextCreature():Creature
	{
		return onPop(queue.pop());
	}
	
	public function putCreatureOnQueueBottom(creature:Creature)
	{
		queue.insert(0, creature);
		informOnFill();
	}
	
	public function putCreatureOnTop(creature:Creature)
	{
		queue.push(creature);
	}
	
	public function putCreatureOnIndex(creature:Creature,index:Int)
	{
		queue.insert(index,creature);
	}
	
	public function getInOrder(index:Int):Creature
	{
		if (queue.length > index)
			return queue[queue.length - index - 1];
		else
			return null;
	}
	
	public function onPop(creature:Creature):Creature
	{
		if (creature == null)
			return null;
		creature.currentActionPoints = creature.range;
		creature.contrattackCountter = 0;
		creature.moved = false;
		creature.defending = false;
		informOnPop(creature);
		return creature;
	}
	
	public function removeCreatureFromQueue(toRemove:Creature):Int
	{
		var index = queue.indexOf(toRemove);
		queue.remove(toRemove);
		informOnKill(toRemove);
		return index;
	}
	
	public function addFillListener(listener:Function)
	{
		fillListeners.add(listener);
	}
	public function addPopListener(listener:Function)
	{
		popListeners.add(listener);
	}
	public function addKillListener(listener:Function)
	{
		killListeners.add(listener);
	}
	
	public function informOnKill(killed:Creature)
	{
		for (listener in killListeners)
			listener(killed);
	}
	public function informOnPop(poped:Creature)
	{
		for (listener in popListeners)
			listener(poped);
	}
	public function informOnFill()
	{
		for (listener in fillListeners)
		{
			if(listener!=null)
				listener();
		}
	}
	
	
}