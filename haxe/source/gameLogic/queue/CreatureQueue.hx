package gameLogic.queue;
import game.Creature;
import haxe.Constraints.Function;

/**
 * @author M
 */
class CreatureQueue 
{
	private var fillListeners:List<Function>;
	private var popListeners:List<Function>;
	private var killListeners:List<Function>;
	
	public function new() 
	{
		fillListeners = new List<Function>();
		popListeners = new List<Function>();
		killListeners = new List<Function>();
	}
	
	public function fillWithPlayers(players:Map<Int,GamePlayer>)
	{
	}
	
	public function getNextCreature():Creature
	{
		return null;
	}
	
	public function getQueueIterator() : Iterable<Creature>
	{
		return null;
	}
	
	public function getSizeOfQueue() : Int
	{
		return 0;
	}
	
	public function getCurrentPosition() : Int
	{
		return 0;
	}
	
	public function putCreatureOnQueueBottom(creature:Creature)
	{
	}
	
	public function MakeCreatureWait(creature:Creature)
	{
	}
	
	public function SetFromMomentum(currentPos : Int, creatures : Array<Creature>, pos : Map<Int,Int>)
	{
		
	}
	
	public function putCreatureOnIndex(creature:Creature,index:Int)
	{
	}
	
	public function getOnPlace(index:Int):Creature
	{
		return null;
	}
	
	public function getInOrder(index:Int):Creature
	{
		return null;
	}
	
	public function onPop(creature:Creature):Creature
	{
		return null;
	}
	
	public function removeCreatureFromQueue(toRemove:Creature):Int
	{
		return 0;
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
		{
			if(listener!=null)
				listener(killed);
		}
	}
	public function informOnPop(poped:Creature)
	{
		for (listener in popListeners)
		{
			if(listener!=null)
				listener(poped);
		}
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