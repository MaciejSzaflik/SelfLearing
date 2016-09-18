package gameLogic.abilites;
import game.Creature;

/**
 * ...
 * @author 
 */
class Ability
{
	public var timing:AbilityTiming;
	public var range:Int;
	
	private var performer:Creature;
	
	public function new(performer:Creature) 
	{
		this.performer = performer;
	}
	
	public function perform()
	{
		
	}
	
	public function setTarget(tileId:Int)
	{
	
	}
	
	public function getTargets():PossibleAttacksInfo
	{
		return null;
	}
	
}