package gameLogic.ai;
import flixel.input.FlxAccelerometer;
import gameLogic.ai.AlphaBeta.SimpleNode;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;

/**
 * ...
 * @author 
 */
class NegaScout extends ArtificialInteligence
{

	override public function generateMove():MoveData 
	{
		return super.generateMove();
	}
	
	
	public static function genericNegaScout<T>(node : TreeVertex<T>, maxDepth : Int, depth : Int, alfa : Float, beta : Float,
		getColor : T->Int,
		getValue : T->Float, 
		getChildren : TreeVertex<T> -> Iterable<TreeVertex<T>>) : Float
	{
		var a : Float = alfa;
		var b : Float = beta;
		var t : Float;
		
		if (depth == maxDepth || node.childrenCount() == 0)
			return getColor(node.value) * getValue(node.value);
		var index = 0;
		for (child in getChildren(node))
		{
			t = -genericNegaScout(child, maxDepth, depth + 1, -b, -alfa, getColor, getValue, getChildren);
			if ((t > a) && (t < beta) && index > 0)
				t = -genericNegaScout(child, maxDepth, depth + 1, -beta, -alfa, getColor, getValue, getChildren);
			alfa = Math.max(alfa, t);
			
			if (alfa >= beta)
				return alfa;
			
			b = alfa + 1;
			index++;
		}
		
		return alfa;
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