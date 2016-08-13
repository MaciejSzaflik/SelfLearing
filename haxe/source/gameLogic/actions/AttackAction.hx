package gameLogic.actions;
import game.Creature;

/**
 * ...
 * @author 
 */
class AttackAction extends Action
{
	private var attacker:Creature;
	private var defender:Creature;
	
	public function new(attacker:Creature,defender:Creature) 
	{
		this.attacker = attacker;
		this.defender = defender;
	}
	
	override public function performAction() 
	{
		var attackPower = attacker.calculateAttack();
		var isAlive = defender.getHit(attackPower);
	}
	
	
	
}