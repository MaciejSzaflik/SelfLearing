package gameLogic.actions;
import animation.MoveBetweenPoints;
import animation.Tweener;
import flixel.math.FlxPoint;
import game.Creature;
import haxe.Constraints.Function;
import hex.HexCoordinates;

/**
 * ...
 * @author 
 */
class AttackAction extends Action
{
	private var useAnimation:Bool;
	private var attacker:Creature;
	private var defender:Creature;
	private var onFinish:Function;
	
	public function new(attacker:Creature,defender:Creature,onFinish:Function) 
	{
		super();
		this.attacker = attacker;
		this.defender = defender;
		this.onFinish = onFinish;
		useAnimation = true;
	}
	
	override public function performAction() 
	{	
		doSimpleAttackAnimation(attacker, defender, -1, null);
		doSimpleAttackAnimation(defender, attacker, 1, function()
		{
			var isAlive = attack(attacker, defender);
			var distance = HexCoordinates.getManhatanDistance(attacker.currentCordinates, defender.currentCordinates);
			if (isAlive && distance == 1 && defender.canContrattack)
			{
				doSimpleAttackAnimation(defender, attacker, -1, null);
				doSimpleAttackAnimation(attacker, defender, 1, function()
				{				
					attack(defender, attacker);
					defender.contrattackCountter++;
					if (onFinish != null)
						onFinish();
				});
			}
			else if (onFinish != null)
				onFinish();
		});
	}
	
	private function attack(hitter:Creature,gettingHit:Creature):Bool
	{
		var attackPower = hitter.calculateAttack();
		var isAlive = gettingHit.getHit(attackPower);
		
		if (!isAlive)
			GameContext.instance.onCreatureKilled(gettingHit);
		
		trace(hitter.definition.name + " attacked " + gettingHit.definition.name + " for " + attackPower);
		trace("Hitpoints left: " + gettingHit.stackCounter + " " + gettingHit.totalHealth);
		return isAlive;
	}
	
	private function doSimpleAttackAnimation(mover:Creature,director:Creature,direction:Int,afterAnimation:Function)
	{
		var v = new FlxPoint(mover.position.x - director.position.x, mover.position.y - director.position.y);
		var l = 1 / Math.sqrt(v.x * v.x + v.y * v.y);
		var normalized = new FlxPoint(v.x * l, v.y * l);
		
		var copyPos = new FlxPoint();
		copyPos.copyFrom(mover.position);
		
		var midpoint = copyPos.addPoint(normalized.scale(direction*15));
		var listPoints = new List<FlxPoint>();
		listPoints.add(mover.position);
		listPoints.add(midpoint);
		listPoints.add(mover.position);
		
		var bumpAnimation = new MoveBetweenPoints(mover, listPoints, 0.04, function(){
			if (afterAnimation != null)
				afterAnimation();
		});
		
		Tweener.instance.addAnimation(bumpAnimation);
	}
	
	
	
}