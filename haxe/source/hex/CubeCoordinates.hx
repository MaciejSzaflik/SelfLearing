package hex;

/**
 * ...
 * @author 
 */
class CubeCoordinates
{
	public var x : Int;
	public var y : Int;
	public var z : Int;
	
	public static function fromAxial(axial:HexCoordinates) : CubeCoordinates
	{
		var cube = new CubeCoordinates(0, 0, 0);
		cube.x = axial.q;
		cube.z = axial.r;
		cube.y = -cube.x - cube.z;
		return cube;
	}
	
	public function getAxial() : HexCoordinates
	{
		return new HexCoordinates(x, z);
	}
	
	public static function CubeAdd(axial:HexCoordinates,x:Int,y:Int,z:Int): HexCoordinates
	{
		var cube = CubeCoordinates.fromAxial(axial);
		cube.x += x;
		cube.y += y;
		cube.z += z;
		return cube.getAxial();
	}
	
	public function new(x:Int,y:Int,z:Int) 
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	
	
}