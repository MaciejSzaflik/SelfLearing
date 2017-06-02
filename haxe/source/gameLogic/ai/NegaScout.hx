package gameLogic.ai;
import flixel.input.FlxAccelerometer;
import gameLogic.ai.AlphaBeta.SimpleNode;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;
import thx.Tuple.Tuple2;

/**
 * ...
 * @author 
 */
class NegaScout
{
	
	public static function genericNegaScout<T>(node : TreeVertex<T>, maxDepth : Int, depth : Int, alfa :  Tuple2<TreeVertex<T>,Float>, beta : Tuple2<TreeVertex<T>,Float>,
		getColor : T->Int,
		getValue : Bool -> TreeVertex<T>->Tuple2<TreeVertex<T>,Float>, 
		getChildren : TreeVertex<T> -> Int -> Iterable<TreeVertex<T>>,
		beforeReturn : T-> Bool = null) : Tuple2<TreeVertex<T>,Float>
	{
		var a : Tuple2<TreeVertex<T>,Float> = copy(alfa);
		var b : Tuple2<TreeVertex<T>,Float> = copy(beta);
		var t : Tuple2<TreeVertex<T>,Float>;
		
		
		if (depth == maxDepth)
		{
			a = new Tuple2<TreeVertex<T>,Float> (node, getValue(true,node)._1);
		}
		else
		{
			var index = 0;
			for (child in getChildren(node,depth))
			{
				t = flipValue(genericNegaScout(child, maxDepth, depth + 1, flipWithCopy(b), flipWithCopy(a), getColor, getValue, getChildren, beforeReturn));
				
				if ((t._1 > a._1) && (t._1 < beta._1) && index > 0)
				{
					a = flipValue(genericNegaScout(child, maxDepth, depth + 1, flipWithCopy(beta), flipWithCopy(t), getColor, getValue, getChildren , beforeReturn));
				}
				
				if(t._1 > a._1)
					a = t;
				
				if (a._1 >= beta._1)
					break;
				
				b._1 = a._1 + 1;
				index++;
			}
			
			if (index == 0)
				a = new Tuple2<TreeVertex<T>,Float> (node, getValue(false,node)._1);
		}
		if (beforeReturn != null)
		{
			beforeReturn(node.value);
		}
		
		return a;
	}
	private static inline function flipValue<T>(alfa : Tuple2<TreeVertex<T>,Float>) : Tuple2<TreeVertex<T>,Float>
	{
		alfa._1 = -alfa._1;
		return alfa;
	}
	
	private static inline function copy<T>(alfa : Tuple2<TreeVertex<T>,Float>) : Tuple2<TreeVertex<T>,Float>
	{
		return new Tuple2<TreeVertex<T>,Float>(alfa._0,alfa._1);
	}
	
	private static inline function flipWithCopy<T>(alfa : Tuple2<TreeVertex<T>,Float>) : Tuple2<TreeVertex<T>,Float>
	{
		return new Tuple2<TreeVertex<T>,Float>(alfa._0,-alfa._1);
	}
	
	public static function valueNegaScout(node : TreeVertex<SimpleNode>, maxDepth : Int, depth : Int, alfa : Float, beta : Float) : Float
	{
		var b : Float = beta;
		var t : Float;
		var a : Float = alfa;
		if (depth == maxDepth || node.childrenCount() == 0)
			return node.value.getColor() * node.value.getValue();
		var index = 0;
		for (child in node.children)
		{
			t = -valueNegaScout(child, maxDepth, depth + 1, -b, -alfa);
			if ((t > a) && (t < beta) && index > 0)
				t = -valueNegaScout(child, maxDepth, depth + 1, -beta, -alfa);
			alfa = Math.max(alfa, t);
			
			if (alfa >= beta)
				return alfa;
			
			b = alfa + 1;
			index++;
		}
		
		return alfa;
	}
}