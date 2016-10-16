package gameLogic.ai.tree;
import gameLogic.moves.ListOfMoves;

/**
 * ...
 * @author 
 */
class TreeVertex<T>
{
	static var idGenerator:Int = 0;
	public var id:Int;
	public var value:T;
	public var parent:TreeVertex<T>;
	public var children:Array<TreeVertex<T>>;
	public function new(parent:TreeVertex<T> = null,value:T = null) 
	{
		this.id = idGenerator++;
		this.value = value;
		this.parent = parent;
	}
	
/*	public function getByIndex(index:Int):TreeVertex
	{
		return children[index];
	}*/
	
	public function initializeChildren(array:Array<T>)
	{
		this.children = new Array<TreeVertex<T>>();
		for (element in array)
		{
			this.children.push(new TreeVertex<T>(this, element));
		}
	}
	
	public function treeToString():String
	{
		var stringBuf = new StringBuf();
		stringBuf.add("|| TV: "+id+" | Children: ");
		if (children != null)
		{
			for (child in children)
				stringBuf.add("\r\n * " + child.treeToString());
			stringBuf.add("|CE|");
		}
		else
			stringBuf.add("|LEAF|");
		stringBuf.add("\r\n");
		return stringBuf.toString();
	}
}