package gameLogic.states;
import gameLogic.moves.Move;

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
	
	public function handleMove(move:Move)
	{
		
	}
	
	public function onEnter():Void
	{
		
	}
	
	public function onLeave():Void
	{
		
	}
	
}