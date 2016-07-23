package graph;

/**
 * ...
 * @author ...
 */
class Vertex
{
	public static inline var MAX = 1000000;
	public var index:Int;
	public var distance:Int;
	public var parent:Vertex;
	public function new(value:Int)
	{
		this.index = value;
		this.distance = MAX; //supposed to be infinity
		this.parent = null;
	}
	
	public function hashCode():Int
    {
        return index;
    }
	
}