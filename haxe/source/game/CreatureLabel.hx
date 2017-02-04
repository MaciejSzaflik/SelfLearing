package game;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class CreatureLabel
{
	public var text:FlxText;
	public var background:FlxSprite;
	public function new(text:FlxText, background:FlxSprite)
	{
		this.text = text;
		this.background = background;
	}
	
	public function setPosition(x:Float, y:Float)
	{
		this.background.setPosition(x - background.width*0.5, y + background.height * 0.2);
		this.text.setPosition(x - text.width*0.5, y + text.height * 0.08);
	}
	
	public function setText(textValue:String)
	{
		this.text.text = textValue;
	}
	
	public function setLabelColor(color:FlxColor)
	{
		background.color = color;
	}
	
	public function enable(enable:Bool)
	{
		if (enable)
		{
			text.reset(text.getPosition().x,text.getPosition().y);
			background.reset(background.getPosition().x,background.getPosition().y);
		}
		else
		{
			text.kill();
			background.kill();
		}
	}
	
}