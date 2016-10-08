package gameLogic.actions;
import animation.MoveBetweenPoints;
import animation.Tweener;
import flixel.math.FlxPoint;
import game.Creature;
import gameLogic.actions.AttackInfo;
import haxe.Constraints.Function;
import hex.HexCoordinates;

/**
 * ...
 * @author 
 */
class AttackAction extends Action
{
	private var useAnimation:Bool;
	private var defender:Creature;
	
	private var attackerAttack:AttackInfo;
	private var defenderAttack:AttackInfo;
	private var creatureAlreadyMoved:Bool;
	
	public function new(attacker:Creature,defender:Creature,onFinish:Function,withAnimation:Bool = false) 
	{
		super();
		this.performer = attacker;
		this.defender = defender;
		this.onFinish = onFinish;
		useAnimation = withAnimation;
		creatureAlreadyMoved = attacker.moved;
	}
	
	override public function performAction() 
	{	
		super.performAction();
		if (useAnimation)
			actionWithAnimation();
		else
			actionWithoutAnimation();
	}
	
	private function actionWithoutAnimation()
	{
		attackerAttack = attack(performer, defender);
		var distance = HexCoordinates.getManhatanDistance(performer.currentCordinates, defender.currentCordinates);
		
		if (attackerAttack.isAlive && distance == 1 && defender.canContrattack)
		{
			defenderAttack = attack(defender, performer);
			defender.contrattackCountter++;
			if (onFinish != null)
				onFinish();
		}
		if (onFinish != null)
			onFinish();
	}
	
	private function actionWithAnimation()
	{
		doSimpleAttackAnimation(performer, defender, -1, null);
		doSimpleAttackAnimation(defender, performer, 1, function()
		{
			attackerAttack = attack(performer, defender);
			var distance = HexCoordinates.getManhatanDistance(performer.currentCordinates, defender.currentCordinates);
			
			if (attackerAttack.isAlive && distance == 1 && defender.canContrattack)
			{
				doSimpleAttackAnimation(defender, performer, -1, null);
				doSimpleAttackAnimation(performer, defender, 1, function()
				{				
					attack(defender, performer);
					defender.contrattackCountter++;
					if (onFinish != null)
						onFinish();
				});
			}
			else if (onFinish != null)
				onFinish();
		});
	}
	
	private function attack(hitter:Creature,gettingHit:Creature):AttackInfo
	{
		var attackPower = hitter.calculateAttack();
		var isAlive = gettingHit.getHit(attackPower);
		
		if (!isAlive)
			GameContext.instance.onCreatureKilled(gettingHit);
		
		return new AttackInfo(isAlive,attackPower);
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
	
	override public function resetAction() 
	{
		super.resetAction();
	}
	
	
	
}