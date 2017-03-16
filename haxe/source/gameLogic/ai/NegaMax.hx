package gameLogic.ai;
import gameLogic.ai.AlphaBeta.SimpleNode;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;

/**
 * ...
 * @author 
 */
class NegaMax extends ArtificialInteligence
{
	override public function generateMove():MoveData 
	{
		return super.generateMove();
	}
	
	public static function genericNegaMax<T>(node :TreeVertex<T>, maxDepth : Int, depth : Int, alpha : Float, beta : Float,
		getColor : T->Int,
		getValue : T->Float, 
		getChildren : TreeVertex<T> -> Iterable<TreeVertex<T>>) : Float
	{
		if (node.childrenCount() == 0 || depth == maxDepth)
		{
			return getColor(node.value) * getValue(node.value);
		}
		var max : Float = -10000000;
		for (child in getChildren(node))
		{
			var x : Float = -genericNegaMax(child, maxDepth, depth + 1, -beta, -alpha, getColor,getValue,getChildren);
			if (x > max) 
				max = x;
			if (x > alpha )
				alpha = x;
			if (alpha > beta)
				return alpha;
		}
		return max;
	}
	
	public static function valueNegaMax(node :TreeVertex<SimpleNode>, maxDepth : Int, depth : Int, alpha : Float, beta : Float)
	{
		if (node.childrenCount() == 0 || depth == maxDepth)
		{
			return node.value.getColor() * node.value.getValue();
		}
		var max : Float = -10000000;
		for (child in node.children)
		{
			var x : Float = -valueNegaMax(child, maxDepth, depth + 1, -beta, -alpha);
			if (x > max) 
				max = x;
			if (x > alpha )
				alpha = x;
			if (alpha > beta)
				return alpha;
		}
		return max;
	}
	
}