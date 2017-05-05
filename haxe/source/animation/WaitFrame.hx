package source.animation;
import animation.TweenAnimation;
import haxe.Constraints.Function;

/**
 * ...
 * @author ...
 */
class WaitFrame implements TweenAnimation
{
	private var numberOfFrames:Int;
	private var haveEnded:Bool;
	private var callback:Function;
	private var counter:Int;
	public function new(numberOfFrames : Int, onFinish : Function) 
	{
		this.numberOfFrames = numberOfFrames;
		callback = onFinish;
		haveEnded = false;
	}
	
	
	/* INTERFACE animation.TweenAnimation */
	
	public function Update(deltaTime:Float):Bool 
	{
		if (numberOfFrames == counter && !haveEnded)
		{
			if (callback != null)
			{
				callback();
			}
			haveEnded = true;
		}
		else
			counter++;
		return haveEnded;
	}
	
	public function HaveEnded():Bool 
	{
		return haveEnded;
	}
	
}