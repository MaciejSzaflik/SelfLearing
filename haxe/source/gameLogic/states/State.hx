package gameLogic.states;

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
	
	public function handleInput(input:Input):Input
	{
		
	}
	
	public function onEnter():Void
	{
		
	}
	
	public function onLeave():Void
	{
		
	}
	
}