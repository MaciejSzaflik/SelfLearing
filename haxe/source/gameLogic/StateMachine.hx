package gameLogic;
import flash.display3D.Context3D;
import gameLogic.states.State;

/**
 * ...
 * @author ...
 */
class StateMachine
{
	@:isVar public var currentState(get, set):State;
	private var changeListeners:List<StateChangeListener>;
	private var Contex:GameContext;
	
	public function new() 
	{
		this.changeListeners = new List<StateChangeListener>();
	}
	
	public function get_currentState():State
	{
		return currentState;
	}
	
	public function set_currentState(state:State)
	{
		if(this.currentState!=null)
			this.currentState.onLeave();
		
		informListeners(state.stateName);
		state.onEnter();
		return this.currentState = state;
	}
	
	public function informListeners(stateName:String)
	{
		trace(stateName);
		if (changeListeners == null)
			return;
		
		for (listener in changeListeners)
			listener.onStateChange(stateName);
	}
	
	public function handleInput(input:Input):Void
	{
		if(currentState!=null)
			currentState.handleInput(input);
	}
	
}