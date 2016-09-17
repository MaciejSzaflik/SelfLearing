package data;

/**
 * ...
 * @author 
 */
class CreatureDefinition
{
	public var id:Int;
	
	public var initiative:Int;
	public var health:Int;
	public var actionPoints:Int;
	public var attackRange:Int;
	public var attackPointCost:Int;
	
	public var attackPower:Int;
	public var attackRandom:Int;
	
	public var name:String;
	public var spriteDef:Int;
	
	public var isRanger:Bool;
	public var contrattactsNumber:Int;
	
	public var abilities:Array<Int>;
	
	public static function createEmpty():CreatureDefinition
	{
		return new CreatureDefinition( -1, -1, -1, -1, -1, -1, -1, -1, "", -1,-1,false);
	}
	
	//public var 
	
	public function new(id:Int, attackPower:Int,
	attackRandom:Int, initiative:Int, health:Int, actionPoints:Int,
	attackRange:Int, attackPointCost:Int, name:String, spriteDef:Int,
	contrattactsNumber:Int,isRanger:Bool) 
	{
		this.id = id;
		this.attackPower = attackPower;
		this.attackRandom = attackRandom;
		this.initiative = initiative;
		this.health = health;
		this.actionPoints = actionPoints;
		this.attackRange = attackRange;
		this.attackPointCost = attackPointCost;
		
		this.name = name;
		this.spriteDef = spriteDef;
		
		this.contrattactsNumber = contrattactsNumber;
		this.isRanger = isRanger;
	}
	
	public function toString():String
	{
		return 'I:$initiative, H:$health, AP:$actionPoints, APC:$attackPointCost, N:$name, SD:$spriteDef';
	}
	
}