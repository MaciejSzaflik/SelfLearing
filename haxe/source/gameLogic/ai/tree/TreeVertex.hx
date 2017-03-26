package gameLogic.ai.tree;
import gameLogic.moves.ListOfMoves;
import utilites.UtilUtil;

/**
 * ...
 * @author 
 */
class TreeVertex<T>
{
	public static var idGenerator:Int = 0;
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
		
		if (parent != null)
		{
			this.parent.addVertexAsChild(this);
		}
	}
	
	public function getByIndex(index:Int):TreeVertex<T>
	{
		return children.get(index);
	}
	
	public function addVertexAsChild(child:TreeVertex<T>)
	{
		this.children.set(child.id, child);
	}
	
	public function childrenCount()
	{
		return UtilUtil.CountMap(children);
	}
	
	public function addChild(child:T): Int
	{
		var newChild = new TreeVertex<T>(this, child);
		children.set(newChild.id, newChild);
		return newChild.id;
	}
	
	public static function getOneBeforeRoot<T>(node : TreeVertex<T>) : TreeVertex<T>		
	{
		if (node.parent == null)
			return null;
		else if (node.parent.parent == null)
			return node;
		else
			return getOneBeforeRoot(node.parent);
		
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
		
		if (UtilUtil.CountMap(children) == 0)
		{
			stringBuf.add("|V: " + value);
			stringBuf.add(" |LEAF|");
		}
		stringBuf.add("\r\n");
		return stringBuf.toString();
	}
}