package gameLogic.ai.evaluation;
import gameLogic.moves.ListOfMoves;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;
import haxe.ds.Vector;
import utilites.MathUtil;

/**
 * ...
 * @author 
 */
class EvaluationResult
{
	public var evaluationResults:Vector<Int>;
	public var listOfMoves:ListOfMoves;
	public var bestIndex:Int;
	public function new(listOfMoves:ListOfMoves) 
	{
		bestIndex = -1;
		this.listOfMoves = listOfMoves;
		this.evaluationResults = new Vector<Int>(listOfMoves.moves.length);
	}
	
	public function getBestMove():MoveData
	{
		if (bestIndex == -1)
		{
			return new MoveData(null, MoveType.Pass, -1);
		}
		else
			return listOfMoves.moves[bestIndex];
	}
	
	public function tryToSetBestIndex(index:Int)
	{
		if (bestIndex == -1)
			bestIndex = index;
		else if (evaluationResults[bestIndex] < evaluationResults[index])
			bestIndex = index;		 
	}
	
}