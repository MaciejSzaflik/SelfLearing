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
		super();
		this.attacker = attacker;
		this.defender = defender;
	}
	
	override public function performAction() 
	{
		var isAlive = attack(attacker, defender);
		if (isAlive)
			attack(defender,attacker);
	}
	
	private function attack(hitter:Creature,gettingHit:Creature):Bool
	{
		var attackPower = hitter.calculateAttack();
		var isAlive = gettingHit.getHit(attackPower);
		
		if (!isAlive)
			GameContext.instance.onCreatureKilled(gettingHit);
			
		return isAlive;
		
	}
	
	
	
}