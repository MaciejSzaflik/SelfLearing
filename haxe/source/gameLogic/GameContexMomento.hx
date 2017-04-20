package gameLogic;
import animation.Tweener;
import game.Creature;
import game.CreatureDynamicInfo;
import gameLogic.queue.ContinuesQueue;

/**
 * ...
 * @author ...
 */
class GameContexMomento 
{
	public var savePlayers : Map<Int,PlayerArrays>;
	
	public var mapImpassableVertices : Map<Int,Bool>;
	
	public var queueCreaturesArray : Array<Int>;
    public var creaturesToQueuePosition : Map<Int,Int>;
	public var currentCounter : Int = -1;
	
	public var creaturesDynamicInfo : Map<Int,CreatureDynamicInfo>;
	
	public var currentCreatureId : Int;
	
	public function new() 
	{
		
	}
	
	public function StoreContex(toStore : GameContext)
	{
		currentCreatureId = toStore.currentCreature.id;
		
		savePlayersArrys(toStore);
		saveCreadturesDynamicInfo(toStore);
		saveMap(toStore);
		saveInitiaveQueue(toStore);
	}
	
	public function RestoreContex(toFill : GameContext) : GameContext
	{
		toFill.currentCreature = toFill.creaturesMap.get(currentCreatureId);
		
		restorePlayers(toFill);
		restoreCreadturesDynamicInfo(toFill);
		restoreMap(toFill);
		restoreInitiaveQueue(toFill);
		return toFill;
	}
	
	public function savePlayersArrys(toStore : GameContext)
	{
		savePlayers = new Map<Int,PlayerArrays>();
		for (player in toStore.mapOfPlayers)
		{
			savePlayers.set(player.id, new PlayerArrays(player));
		}
	}
	
	public function restorePlayers(toFill : GameContext)
	{
		for (player in toFill.mapOfPlayers)
		{
			savePlayers.get(player.id).ApplyToPlayer(toFill.creaturesMap, player);
		}
	}
	
	public function saveCreadturesDynamicInfo(toStore : GameContext)
	{
		creaturesDynamicInfo = new Map<Int,CreatureDynamicInfo>();
		for (creature in toStore.creaturesMap)
		{
			creaturesDynamicInfo.set(creature.id, creature.getDynamicInfoCopy());
		}
	}
	
	public function restoreCreadturesDynamicInfo(toFill : GameContext)
	{
		for (creature in toFill.creaturesMap)
		{
			creature.applyDynamicInfo(creaturesDynamicInfo.get(creature.id));
		}
	}
	
	public function saveMap(toStore : GameContext)
	{
		mapImpassableVertices = new Map<Int,Bool>();
		for (vertId in toStore.map.getGraph().impassableVertices.keys())
		{
			mapImpassableVertices.set(vertId, true);
		}
	}
	
	public function restoreMap(toFill : GameContext)
	{
		mapImpassableVertices = new Map<Int,Bool>();
		for (vertId in mapImpassableVertices.keys())
		{
			toFill.map.getGraph().impassableVertices.set(vertId, true);
		}
	}
	
	public function saveInitiaveQueue(toStore : GameContext)
	{
		var queue = cast(toStore.inititativeQueue, ContinuesQueue);
		
		queueCreaturesArray = new Array<Int>();
		creaturesToQueuePosition = new Map<Int,Int>();
		
		for (i in 0...queue.queue.length)
		{
			queueCreaturesArray.push(queue.queue[i].id);
		}
		
		for (key in queue.creaturesToQueuePosition.keys())
		{
			creaturesToQueuePosition.set(key, queue.creaturesToQueuePosition.get(key));
		}
		
		currentCounter = queue.currentCounter;
	}
	
	public function restoreInitiaveQueue(toFill : GameContext)
	{
		var queue = new Array<Creature>();
		for (value in queueCreaturesArray)
		{
			queue.push(toFill.creaturesMap.get(value)); 
		}
		
		toFill.inititativeQueue.SetFromMomentum(currentCounter, queue, creaturesToQueuePosition);
	}
	
}

class PlayerArrays
{
	public var playerId : Int;
	public var aliveCreatures : Array<Int>;
	public var deadCreatures : Array<Int>;
	
	public function new(player : GamePlayer)
	{
		playerId = player.id;
		aliveCreatures= new Array<Int>();
		deadCreatures = new Array<Int>();
		
		for (creature in player.creatures)
		{
			aliveCreatures.push(creature.id);
		}
		
		for (creature in player.deadCreatures)
		{
			deadCreatures.push(creature.id);
		}
	}
	
	public function ApplyToPlayer(creaturesMain : Map<Int,Creature>, player : GamePlayer)
	{
		player.deadCreatures = new Array<Creature>();
		player.creatures = new Array<Creature>();
		
		for (ids in aliveCreatures)
		{
			player.creatures.push(creaturesMain.get(ids));
		}
		
		for (ids in deadCreatures)
		{
			player.deadCreatures.push(creaturesMain.get(ids));
		}
	}
}