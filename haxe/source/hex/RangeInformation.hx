package hex;
import flixel.math.FlxPoint;

/**
 * ...
 * @author 
 */
class RangeInformation
{
	public var centers:List<FlxPoint>;
	public var hexList:List<Hex>;
	
	public function FillRange(indexes:List<Int>,mapToCheck:Map<Int,Hex>)
	{
		for (vert in indexes)
		{
			if (mapToCheck.exists(vert))
			{
				var hex = mapToCheck.get(vert);
				hexList.add(hex);
				centers.add(hex.center);
			}
		}
	}
	
	public function new()
	{
		hexList = new List<Hex>();
		centers = new List<FlxPoint>();
	}
}
	