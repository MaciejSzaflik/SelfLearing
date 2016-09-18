package gameLogic.abilites;

import game.Creature;
import gameLogic.PossibleAttacksInfo;

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
	
	override public function getTargets():PossibleAttacksInfo
	{
		return super.getTargets();
	}
	
	override public function perform() 
	{
		super.perform();
	}
	
}