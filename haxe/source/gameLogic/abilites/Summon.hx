package gameLogic.abilites;

import game.Creature;

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
	
	override public function getTargets():Array<Int> 
	{
		return super.getTargets();
	}
	
	override public function perform() 
	{
		super.perform();
	}
	
}