package gameLogic;
import flash.display3D.Context3D;

/**
 * ...
 * @author ...
 */
class StateMachine
{
	public var currentState(get, set):State;
	private var changeListeners:List<StateChangeListener>;
	private var Contex:Context;
	
	public function new() 
	{
		this.changeListeners = new List<StateChangeListener>();
	}
	
	public function get_currentState():State
	{
		return currentState;
	}
	
	public function set_currentState(stateTochange:State):Void
	{
		currentState = stateTochange;
		informListeners(stateTochange.stateName);
	}
	
	public function informListeners(stateName:String)
	{
		for (listener in changeListeners)
			listener.onStateChange(stateName);
	}
	
	public function handleInput(input:Input):Void
	{
		if(currentState!=null)
			currentState.handleInput(input);
	}
	
import gameLogic.states.State;
}