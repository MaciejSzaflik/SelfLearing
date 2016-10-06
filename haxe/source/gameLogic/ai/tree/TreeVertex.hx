package gameLogic.ai.tree;

/**
 * ...
 * @author 
 */
class TreeVertex<T>
{
	public var id:Int;
	public var value:T;
	public var parent:TreeVertex;
	public var children:TreeVertex[];
	public function new() 
	{
		parent = null;
	}
	
}