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
		if (target == null)
			return;
		
		var healthToAdd = Std.int(Math.min(this.target.lostHitPoints, power*performer.stackCounter*performer.level));
		target.recalculateStackSize(target.totalHealth + healthToAdd);
		target.lostHitPoints -= healthToAdd;
	}
	
	override public function setTarget(tileId:Int) 
	{
		if(GameContext.instance.tileToCreature.exists(tileId))
			target = GameContext.instance.tileToCreature.get(tileId);
	}
	
	override public function getTargets():PossibleAttacksInfo 
	{
		return GameContext.instance.getCreaturesInRange(performer.getTileId(), this.range, performer.idPlayerId);
	}
	
}