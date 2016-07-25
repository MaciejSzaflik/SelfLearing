package animation;

/**
 * @author ...
 */
interface TweenAnimation 
{
	public function Update(deltaTime:Float):Bool;
	public function HaveEnded():Bool;
}