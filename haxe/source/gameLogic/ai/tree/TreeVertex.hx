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
	public var children:Map<Int,TreeVertex<T>>;
	public function new(parent:TreeVertex<T> = null,value:T = null) 
	{
		this.id = idGenerator++;
		this.value = value;
		this.parent = parent;
		this.children = new Map<Int,TreeVertex<T>>();
	}
	
	public function getByIndex(index:Int):TreeVertex<T>
	{
		return children.get(index);
	}
	
	public function addChild(child:T): Int
	{
		var newChild = new TreeVertex<T>(this, child);
		children.set(newChild.id, newChild);
		return newChild.id;
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