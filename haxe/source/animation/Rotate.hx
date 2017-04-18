package animation;
import flixel.FlxSprite;
import haxe.Constraints.Function;
import utilites.MathUtil;

/**
 * ...
 * @author ...
 */
class Rotate implements TweenAnimation
{
	
	private var movingSprite:FlxSprite;
	private var timeOfAnimation:Float;
	private var startAngle:Float;
	private var endAngle:Float;
	
	private var currentProgress:Float;
	
	private var haveEnded:Bool;
	
	private var callback:Function;
	

	public function new(movingSprite:FlxSprite,startAngle:Float,endAngle:Float,timeOfAnimation:Float, callback:Function)
	{
		this.timeOfAnimation = timeOfAnimation;
		this.callback = callback;
		this.movingSprite = movingSprite;
		
		this.startAngle = startAngle;
		this.endAngle = endAngle;
		this.currentProgress = 0;
	}
	
	
	/* INTERFACE animation.TweenAnimation */
	
	public function Update(deltaTime:Float):Bool 
	{
		try
		{
		var step = deltaTime / timeOfAnimation;
		this.currentProgress += step;
		
		if (this.currentProgress >= 1)
		{
			movingSprite.angle = endAngle;
			if (callback != null)
			{
				callback();
			}
			haveEnded = true;
			return true;
		}
		movingSprite.angle = MathUtil.lerp(startAngle, endAngle,MathUtil.smooothStep(0,1,currentProgress));
		}
		catch (msg:String)
		{
			trace(msg);
		}
		return false;
	}
	
	public function HaveEnded():Bool 
	{
		return haveEnded;
	}
	
}