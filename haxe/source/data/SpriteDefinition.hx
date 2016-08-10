package data;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class SpriteDefinition
{
	public var id:Int;
	public var graphicName:String;
	public var animated:Bool;
	public var height:Int;
	public var widght:Int;
	
	public var animationList:List<Int>;
	
	public static function createEmpty():SpriteDefinition
	{
		return new SpriteDefinition(-1,"");
	}
	
	public function new(id:Int,graphicName:String,animated:Bool = false,height:Int = 10,widght:Int = 10,animationList:List<Int> = null) 
	{
		this.id = id;
		this.graphicName = graphicName;
		this.animated = animated;
		this.height = height;
		this.widght = widght;
		
		this.animationList = animationList;
	}
	
}