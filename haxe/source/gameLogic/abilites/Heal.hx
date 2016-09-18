package gameLogic.abilites;
import game.Creature;
import gameLogic.GameContext;
import gameLogic.PossibleAttacksInfo;

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
		var healthToAdd = Std.int(Math.min(this.target.lostHitPoints, power));
		target.recalculateStackSize(target.currentHealth + healthToAdd);
		target.lostHitPoints -= healthToAdd;
	}
	
	public function selectTarget(target:Creature)
	{
		this.target = target;
	}
	
	override public function getTargets():PossibleAttacksInfo 
	{
		return GameContext.instance.getCreaturesInRange(performer.getTileId(), this.range, performer.idPlayerId);
	}
	
}