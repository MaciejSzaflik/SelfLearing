package gameLogic.actions;
import game.Creature;
import haxe.Constraints.Function;
import hex.HexCoordinates;

/**
 * ...
 * @author 
 */
class AttackAction extends Action
{
	private var attacker:Creature;
	private var defender:Creature;
	private var onFinish:Function;
	
	public function new(attacker:Creature,defender:Creature,onFinish:Function) 
	{
		super();
		this.attacker = attacker;
		this.defender = defender;
		this.onFinish = onFinish;
	}
	
	override public function performAction() 
	{
		var angle = attacker.sprite.getPosition();
		
		var isAlive = attack(attacker, defender);
		var distance = HexCoordinates.getManhatanDistance(attacker.currentCordinates, defender.currentCordinates);
		if (isAlive && distance == 1 && defender.canContrattack)
		{
			attack(defender, attacker);
			defender.contrattackCountter++;
		}
		
		if (onFinish != null)
			onFinish();
	}
	
	private function attack(hitter:Creature,gettingHit:Creature):Bool
	{
		var attackPower = hitter.calculateAttack();
		var isAlive = gettingHit.getHit(attackPower);
		
		if (!isAlive)
			GameContext.instance.onCreatureKilled(gettingHit);
		
		return isAlive;
	}
	
	private function doSimpleAttackAnimation()
	{
		
	}
	
	
	
}