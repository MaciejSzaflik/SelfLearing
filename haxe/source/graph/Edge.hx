package graph;

/**
 * ...
 * @author ...
 */
class Edge
{
	public var left:Int;
	public var right:Int;
	
	public function new(left:Int,right:Int) 
	{
		this.left = left;
		this.right = right;
	}
	
	public function toString():String
	{
		return "Edge:"+left + "|" + right;
	}
	
}