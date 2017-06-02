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
		getValue : Bool -> TreeVertex<T>->Tuple2<TreeVertex<T>,Float>, 
		getChildren : TreeVertex<T> -> Int -> Iterable<TreeVertex<T>>,
		beforeReturn : T-> Bool = null,
		fliping : Bool = true) : Tuple2<TreeVertex<T>,Float>
	{	
		var max : Tuple2<TreeVertex<T>,Float> = new Tuple2<TreeVertex<T>,Float> (node, -1000000000000);
		if (depth == maxDepth)
		{
			max = getValue(true,node);
		}
		else
		{
			var index = 0;
			for (child in getChildren(node,depth))
			{
				var shouldFlip = -1;
				if (getColor(child.value) == getColor(node.value))
					shouldFlip = 1;
				
				index++;
				var x : Tuple2<TreeVertex<T>,Float>  = genericNegaMax(child, maxDepth, depth + 1, shouldFlip*beta, shouldFlip*alpha, getColor,getValue,getChildren,beforeReturn);
				x._1 = shouldFlip * x._1;
				
				if (x._1 > max._1)
					max = x;
					
				if (max._1> alpha )
					alpha = max._1;
				
				if (max._1 >= beta)
					break;
			}
			if (index == 0)
				max = getValue(false,node);
		}
		if (beforeReturn != null)
			beforeReturn(node.value);
		
		max._1 = alpha;
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