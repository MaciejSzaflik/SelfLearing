package gameLogic.states;
import gameLogic.moves.MoveData;

/**
 * ...
 * @author ...
 */
class State
{
	public var stateName(default, null):String;
	private var stateMachine:StateMachine;

	public function new(stateMachine:StateMachine) 
	{
		this.stateMachine = stateMachine;
	}
	
	public function handleInput(input:Input)
	{
		
	}
	
	public function handleMove(move:MoveData)
	{
		
	}
	
	public function onEnter():Void
	{
		
	}
	
	public function onLeave():Void
	{
		
	}
	
}