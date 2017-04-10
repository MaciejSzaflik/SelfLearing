package ui;
import flixel.addons.ui.FlxUIPopup;

/**
 * ...
 * @author ...
 */
class MainStatePopup extends FlxUIPopup
{
	public override function create():Void
	{
		_xml_id = "main_popup_state";
		super.create();
	}
	
	public override function getEvent(id:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void 
	{
		if (params != null)
		{
			if (id == "click_button"){
				switch (Std.int(params[0]))
				{
					case 0: close();
					case 1: save();
					case 2: load();
					case 3: restart();
				}
			}
		}
	}
	
	public function save()
	{
		
	}
	
	public function load()
	{
		
	}
	
	public function restart()
	{
		close();
		MainState.getInstance().TryToRestart();
	}
	
}