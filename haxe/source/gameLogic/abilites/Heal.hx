package gameLogic.abilites;
import game.Creature;

/**
 * ...
 * @author 
 */
class Heal extends Ability
{
	public var power:Int;
	private var target:Creature;
	
	public function new(performer:Creature) 
	{
		super(performer);
		
	}
	
	override public function perform() 
	{
		
	}
	
	public function selectTarget(target:Creature)
	{
		this.target = target;
	}
	
	override public function getTargets():Array<Int> 
	{
		return super.getTargets();
	}
	
}