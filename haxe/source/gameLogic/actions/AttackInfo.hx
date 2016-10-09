package gameLogic.actions;

/**
 * ...
 * @author 
 */
class AttackInfo
{
	public var isAlive:Bool;
	public var attackPower:Int;
	public var placeInQueue:Int;
	
	public function new(isAlive:Bool,attackPower:Int,placeInQueue:Int)
	{
		this.isAlive = isAlive;
		this.attackPower = attackPower;
		this.placeInQueue = placeInQueue;
	}
}