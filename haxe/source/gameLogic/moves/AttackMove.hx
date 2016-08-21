package gameLogic.moves;
import game.Creature;

/**
 * ...
 * @author 
 */
class AttackMove extends Move
{
	public var attacked:Creature;
	
	public function new(type:MoveType,creature:Creature,tileId:Int) 
	{
		super(type,tileId);
		this.attacked = creature;
	}
	
	public var attackedId(get, never):Int;
	function get_attackedId():Int
	{
		return attacked.id;
	}
	
	override public function getId():String 
	{
		return tileId+"."+attackedId;
	}
}