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
		var creatureDefinition = GameConfiguration.instance.creatures.get(creatureId);
		var summonPower = Math.max(1,Math.ceil((power * performer.stackCounter * performer.level) / creatureDefinition.health));
		var creature = Creature.fromDefinition(creatureDefinition,Math.ceil(summonPower));
		creature.addCreatureToState(MainState.getInstance());
		
		var hex = GameContext.instance.map.getHexByIndex(tileId);
		var point = hex.center;
		
		GameContext.instance.mapOfPlayers.get(performer.idPlayerId).addCreatureToPlayer(creature);
		
		creature.setPosition(point);
		creature.setCoodinates(hex.getCoor());
	}
	
}