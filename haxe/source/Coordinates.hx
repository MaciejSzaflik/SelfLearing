package source;


class Coordinates
{
	public var q : Int;
	public var r : Int;
	
	public function getX() : Int
	{
		return q;
	}
	
	public function getY() : Int
	{
		return -q - r;
	}
	
	public function getZ() : Int
	{
		return r;
	}
	
	public function new(q : Int,r : Int) 
	{
		this.q = q;
		this.r = r;
	}
	
	public function toString()  : String
	{
		return "Coordinates("+q+","+r+")";
	}
	
}