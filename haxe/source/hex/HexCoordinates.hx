package hex;
import utilites.IntPair;


class HexCoordinates
{
	public var q:Int;
	public var r:Int;
	
	public var x(get, null):Int;
	public var y(get, null):Int;
	public var z(get, null):Int;
	
	
	
	function get_x():Int
	{
		return q;
	}
	
	function get_y():Int
	{
		return -q - r;
	}
	
	function get_z():Int
	{
		return r;
	}
	
	public function new(q:Int,r:Int) 
	{
		this.q = q;
		this.r = r;
	}
	
	public function getOddRCol():Int
	{
		return Math.round(x + (z - z & 1) / 2);
	}
	public function getOddRRow():Int
	{
		return z;
	}
	
	public function addAxial(q:Int, r:Int):HexCoordinates
	{
		return new HexCoordinates(this.q + q, this.r + r);
	}
	
	static public function fromCube(xValue:Int,zValue:Int):HexCoordinates
	{
		return new HexCoordinates(xValue, zValue);
	}
	
	static public function froomOddROffset(offset : IntPair):HexCoordinates
	{
		return fromOddR(offset.left, offset.right);
	}
	
	static public function fromOddR(row:Int,col:Int):HexCoordinates
	{
		var xValue = Math.round(col - (row - (row & 1)) / 2);
		var zValue = row;
		return new HexCoordinates(xValue, zValue);
	}
	
	static public function getManhatanDistance(start:HexCoordinates, end:HexCoordinates):Float
	{
		return (Math.abs(start.x - end.x) + Math.abs(start.y - end.y) + Math.abs(start.z - end.z)) / 2;
	}
	
	public function toString():String
	{
		return "Coordinates("+q+","+r+")";
	}
	
	public function toKey():Int
	{
		var xValue = q < 0 ? q + 5000 : q;
		var yValue = r < 0 ? r + 5000 : r;
		
		return Math.floor(((xValue + yValue + 1) * (xValue + yValue)) / 2) + yValue; 
	}
	
}