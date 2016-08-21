package gameLogic.moves;
import flixel.math.FlxPoint;
import game.Creature;

/**
 * ...
 * @author 
 */
class ListOfMoves
{
	public var moves:List<MoveData>;
	public var movesByTypes:Map<MoveType,Map<String,MoveData>>;
	public var affectedCreatures:Map<Int,Creature>;
	
	public function new() 
	{
		moves = new List<MoveData>();
		movesByTypes = new Map<MoveType,Map<String,MoveData>>();
		affectedCreatures = new Map<Int,Creature>();
	}
	
	public function addMove(moveToAdd:MoveData)
	{
		moves.push(moveToAdd);
		addToMap(moveToAdd);
	}
	
	private function addToMap(moveToAdd:MoveData)
	{
		if (!movesByTypes.exists(moveToAdd.type))
			movesByTypes.set(moveToAdd.type, new Map<String,MoveData>());
		
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