package gameLogic.ai;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;
import haxe.CallStack;
import haxe.Constraints.Function;
import utilites.ThreadProvider;

/**
 * ...
 * @author 
 */
class ArtificialInteligence
{

	public function new() 
	{
		
	}
	
	public function isThreadNeeded():Bool
	{
		return false;
	}
	
	public function generateMoveWithThread(callBack : MoveData->Void, before : Function, after : Function)
	{
		if (before != null)
			before();
		
		if (isThreadNeeded())
		{
			ThreadProvider.instance.AddTask(function(){
				try{
					
					callBack(generateMove());
							
				} catch (msg:String)
				{
					trace("msg :" + msg);
					trace("Stack: " + CallStack.toString(CallStack.exceptionStack()));
					callBack(new MoveData(null, MoveType.Pass, -1));
				}
				if (after != null)
					after();
			});
		}
		else
		{
			var moveData = generateMove();
			callBack(moveData);
			if (after != null)
				after();
		}
	}
	
	public function generateMove():MoveData
	{
		return new MoveData(null,MoveType.Pass, -1);
	}
	
	public function generateMoveFuture():Array<MoveData> 
	{
		return null;
	}
	
}