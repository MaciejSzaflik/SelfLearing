package animation;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * ...
 * @author ...
 */
class MoveBetweenPoints implements TweenAnimation
{
	private var movingSprite:FlxSprite;
	private var checkpoints:Array<FlxPoint>;
	private var timeOfAnimation:Float;
	private var currentProgress:Float;
	
	public function new() 
	{
		
	
	}
	
	
	/* INTERFACE animation.TweenAnimation */
	
	public function Update(deltaTime:Float):Bool 
	{
		
	}
	
	public function HaveEnded():Bool 
	{
		
	}
	
}