package hex;
import flixel.FlxSprite;
import flixel.FlxSprite;
import source.Drawer;
import flixel.util.FlxColor;
import hex.HexTopping;

class HexSprite extends FlxSprite
{
	var myDrawer:Drawer;
	public function new(size:Int)
	{
		super();
		makeGraphic(size, size, FlxColor.TRANSPARENT, true);
		myDrawer = new Drawer(this);
		myDrawer.drawHex(this.getPosition(), size, HexTopping.Pointy, FlxColor.RED);
	}
	
}