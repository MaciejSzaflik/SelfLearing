package data;

/**
 * ...
 * @author ...
 */
class FrameAnimationDef
{
	public var id:Int;
	public var name:String;
	public var framesPerSecond:Int;
	public var looped:Bool;
	public var frameOrder:Array<Int>;
	
	public static function createEmpty():FrameAnimationDef
	{
		return new FrameAnimationDef(-1,"", 0, false, null);
	}
	
	public function new(id:Int,name:String,framesPerSecond:Int,looped:Bool,frameOrder:Array<Int>) 
	{
		this.id = id;
		this.name = name;
		this.framesPerSecond = framesPerSecond;
		this.looped = looped;
		this.frameOrder = frameOrder;
	}
	
}