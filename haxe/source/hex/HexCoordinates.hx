package hex;


class HexCoordinates
{
	public var q:Int;
	public var r:Int;
	
	public function getX():Int
	{
		return q;
	}
	
	public function getY():Int
	{
		return -q - r;
	}
	
	public function getZ():Int
	{
		return r;
	}
	
	public function new(q:Int,r:Int) 
	{
		this.q = q;
		this.r = r;
	}
	
	static public function fromCube(x:Int,z:Int):HexCoordinates
	{
		return new HexCoordinates(x, z);
	}
	
	public function toString():String
	{
		return "Coordinates("+q+","+r+")";
	}
	
}