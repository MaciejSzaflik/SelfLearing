package animation;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import game.Creature;
import haxe.Constraints.Function;
import utilites.MathUtil;

/**
 * ...
 * @author ...
 */
class MoveBetweenPoints implements TweenAnimation
{
	private var movingSprite:Creature;
	private var checkpoints:List<FlxPoint>;
	private var timeOfAnimation:Float;
	
	private var currentProgress:Float;
	
	private var startCheckpoint:FlxPoint;
	private var endCheckpoint:FlxPoint;
	
	private var haveEnded:Bool;
	
	private var callback:Function;
	
	public function new(movingSprite:Creature,checkpoints:List<FlxPoint>,timeOfAnimation:Float, callback:Function) 
	{
		this.movingSprite = movingSprite;
		this.checkpoints = checkpoints;
		this.timeOfAnimation = timeOfAnimation;
		
		this.currentProgress = 0;
		this.startCheckpoint = checkpoints.pop();
		this.endCheckpoint = checkpoints.pop();
		this.callback = callback;
		
		this.haveEnded = false;
	}
	
	/* INTERFACE animation.TweenAnimation */
	
	public function Update(deltaTime:Float):Bool 
	{
		var step = deltaTime / timeOfAnimation;
		this.currentProgress += step;
		if (this.currentProgress >= 1)
		{
			this.currentProgress = 0;
			this.movingSprite.setPosition(endCheckpoint);
			if (checkpoints.length > 0)
			{
				startCheckpoint = endCheckpoint;
				endCheckpoint = checkpoints.pop();
				return false;
			}
			else
			{
				if (callback != null)
				{
					callback();
				}
				haveEnded = true;
				return true;
			}
		}
		movingSprite.setPosition(MathUtil.lerpPoints(startCheckpoint, endCheckpoint, this.currentProgress));
		return false;
	}
	
	public function HaveEnded():Bool 
	{
		return this.haveEnded;
	}
	
}