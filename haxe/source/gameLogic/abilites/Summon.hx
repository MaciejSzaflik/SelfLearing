package gameLogic.abilites;

import flixel.math.FlxPoint;
import game.Creature;
import gameLogic.PossibleAttacksInfo;
import utilites.GameConfiguration;

/**
 * ...
 * @author 
 */
class Summon extends Ability
{
	public var creatureId:Int;
	public var power:Int;
	
	private var tileId:Int;
	
	public function new(performer:Creature) 
	{
		super(performer);
		
	}
	
	override public function setTarget(tileId:Int) 
	{
		this.tileId = tileId;
	}
	
	override public function getTargets():PossibleAttacksInfo
	{
		var range = GameContext.instance.map.getRange(performer.getTileId(), this.range, true);
		var listOfCenters = new List<FlxPoint>();
		var listOfHex = new Map<Int,Bool>();
		for (value in range) 
		{
			listOfCenters.add(GameContext.instance.map.getHexCenter(value));
			listOfHex.set(value, true);
		}
		return new PossibleAttacksInfo(null, listOfCenters, listOfHex);
	}
	
	override public function perform() 
	{
		trace("summon!");
		var creatureDefinition = GameConfiguration.instance.creatures.get(creatureId);
		var creature = Creature.fromDefinition(creatureDefinition,power);
		creature.addCreatureToState(MainState.getInstance());
		creature.sprite.
		GameContext.instance.mapOfPlayers.get(performer.idPlayerId).addCreatureToPlayer(creature);
	}
	
}