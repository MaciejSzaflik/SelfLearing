package data;

/**
 * ...
 * @author ...
 */
class FrameAnimationDef
{
	public var name:String;
	public var framesPerSecond:Int;
	public var looped:Bool;
	public var frameOrder:Array<Int>;
	
	public function new(name:String,framesPerSecond:Int,looped:Bool,frameOrder:Array<Int>) 
	{
		this.name = name;
		this.framesPerSecond = framesPerSecond;
		this.looped = looped;
		this.frameOrder = frameOrder;
	}
	
}