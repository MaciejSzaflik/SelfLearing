package gameLogic.ai;
import gameLogic.ai.AlphaBeta.SimpleNode;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;
import thx.Tuple.Tuple2;

/**
 * ...
 * @author 
 */
class NegaMax 
{
	public static function genericNegaMax<T>(node :TreeVertex<T>, maxDepth : Int, depth : Int, alpha : Float, beta : Float,
		getColor : T->Int,
		getValue : TreeVertex<T>->Tuple2<TreeVertex<T>,Float>, 
		getChildren : TreeVertex<T> -> Int -> Iterable<TreeVertex<T>>,
		beforeReturn : T-> Bool = null) : Tuple2<TreeVertex<T>,Float>
	{	
		var max : Tuple2<TreeVertex<T>,Float> = new Tuple2<TreeVertex<T>,Float> (node, -1000000000000);
		if (depth == maxDepth)
		{
			max = getValue(node);
		}
		else
		{	
			for (child in getChildren(node,depth))
			{
				var x : Tuple2<TreeVertex<T>,Float>  = genericNegaMax(child, maxDepth, depth + 1, -beta, -alpha, getColor,getValue,getChildren,beforeReturn);
				x._1 = -x._1;
				if (x._1 > max._1) 
					max._1 = x._1;
				if (x._1 > alpha )
					alpha = x._1;
				if (alpha > beta)
					break;
			}
		}
		if (beforeReturn != null)
			beforeReturn(node.value);
		
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
				break;
		}
		return max;
	}
	
}