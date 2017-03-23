package gameLogic.queue;
import game.Creature;
import thx.Tuple.Tuple2;

/**
 * ...
 * @author M
 */
class ContinuesQueue extends CreatureQueue
{

	public var queue:Array<Creature>;
	public var creaturesToQueuePosition : Map<Int,Int>;
	
	public var currentCounter : Int = -1;
	public function new() 
	{
		super();
		queue = new Array<Creature>();
		creaturesToQueuePosition = new Map<Int,Int>();
	}
	
	override public function fillWithPlayers(players:Map<Int, GamePlayer>) 
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
		
		for (i in 0...queue.length)
		{
			creaturesToQueuePosition.set(queue[i].id, i);
		}
		
		informOnFill();
	}
	
	override public inline function getNextCreature():Creature
	{
		currentCounter++;
		
		if (currentCounter == queue.length)
			endOfTurnOperations();
		
		currentCounter = currentCounter % queue.length;
		
		trace(currentCounter);
		return onPop(queue[currentCounter]);
	}
	
	private inline function endOfTurnOperations()
	{
		trace("endOfTurnOperations");
		
		for (creature in queue)
		{
			creature.waited = false;
		}
		
		queue.sort(function(x:Creature, y:Creature):Int 
		{
			return  creaturesToQueuePosition[x.id] - creaturesToQueuePosition[y.id];
		});	

	}
	
	override public inline function getQueueIterator():Iterable<Creature> 
	{
		return queue;
	}
	
	override public inline function getSizeOfQueue():Int
	{
		return queue.length;
	}
	
	override public inline function getCurrentPosition():Int 
	{
		return currentCounter;
	}
	
	override public inline function MakeCreatureWait(creature:Creature)
	{
		currentCounter--;
		queue.remove(creature);
		queue.push(creature);
		informOnFill();
	}
	
	override public inline function putCreatureOnIndex(creature:Creature,index:Int)
	{
		queue.insert(index,creature);
	}
	
	override public inline function getInOrder(index:Int):Creature
	{
		var index : Int = (currentCounter + index) % queue.length;
		return queue[index];
	}
	
	override public function onPop(creature:Creature):Creature
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
	
	override public function removeCreatureFromQueue(toRemove:Creature):Int
	{
		var index = queue.indexOf(toRemove);
		queue.remove(toRemove);
		informOnKill(toRemove);
		
		return index;
	}
	
}