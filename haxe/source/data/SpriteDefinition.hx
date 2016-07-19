package data;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class SpriteDefinition
{
	public var graphicName:String;
	public var animated:Bool;
	public var height:Int;
	public var widght:Int;
	
	public var animationList:List<FrameAnimationDef>;
	
	
	public function new(graphicName:String,animated:Bool = false,height:Int = 10,widght:Int = 10,animationList:List<FrameAnimationDef> = null) 
	{
		this.graphicName = graphicName;
		this.animated = animated;
		this.height = height;
		this.widght = widght;
		
		this.animationList = animationList;
	}
	
}