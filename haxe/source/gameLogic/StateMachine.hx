package gameLogic;
import flash.display3D.Context3D;
import gameLogic.states.State;
import haxe.Constraints.Function;

/**
 * ...
 * @author ...
 */
class StateMachine
{
	@:isVar public var currentState(get, set):State;
	private var changeListeners:List<Function>;
	private var Contex:GameContext;
	
	public function new() 
	{
		this.changeListeners = new List<Function>();
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
	
	public function addNewStateChangeListener(newListener:Function)
	{
		if (changeListeners == null)
			this.changeListeners = new List<Function>();
		changeListeners.add(newListener);
	}
	
	public function informListeners(stateName:String)
	{
		if (changeListeners == null)
			return;
		for (listener in changeListeners)
		{
			listener(stateName);
		}
	}
	
	public function handleInput(input:Input):Void
	{
		if(currentState!=null)
			currentState.handleInput(input);
	}
	
}