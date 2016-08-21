package gameLogic.moves;
import flixel.math.FlxPoint;
import game.Creature;

/**
 * ...
 * @author 
 */
class ListOfMoves
{
	public var moves:List<Move>;
	public var movesByTypes:Map<MoveType,Map<String,Move>>;
	public var affectedCreatures:Map<Int,Creature>;
	
	public function new() 
	{
		moves = new List<Move>();
		movesByTypes = new Map<MoveType,Map<String,Move>>();
		affectedCreatures = new Map<Int,Creature>();
	}
	
	public function addMove(moveToAdd:Move)
	{
		moves.push(moveToAdd);
		addToMap(moveToAdd);
	}
	
	private function addToMap(moveToAdd:Move)
	{
		if (!movesByTypes.exists(moveToAdd.type))
			movesByTypes.set(moveToAdd.type, new Map<String,Move>());
		
		movesByTypes.get(moveToAdd.type).set(moveToAdd.getId(), moveToAdd);
	}
	
	public function checkIfExist(moveType:MoveType, id:String):Bool
	{
		return movesByTypes.exists(moveType) && movesByTypes.get(moveType).exists(id);
	}
	
	public function getListOCenters(moveType:MoveType):List<FlxPoint>
	{
		var centers = new List<FlxPoint>();
		if (movesByTypes.exists(moveType))
		{
			for (move in movesByTypes.get(moveType))
			{
				centers.push(GameContext.instance.map.getHexCenter(move.tileId));
			}
		}
		
		return centers;
	}
	
	
}