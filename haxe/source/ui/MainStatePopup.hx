package ui;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIPopup;
import gameLogic.GameContext;
import gameLogic.PlayerType;

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
		setStateOfCheckboxes();
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
			
			if (id == "click_check_box")
			{
				onCheckBox();
			}
		}
	}
	
	private function onCheckBox()
	{
		var uiCheckBox1:FlxUICheckBox = cast _ui.getAsset("ai_check1");
		var uiCheckBox2:FlxUICheckBox = cast _ui.getAsset("ai_check2");
		
		GameContext.instance.setPlayerType(0, uiCheckBox1.checked ? PlayerType.Human : PlayerType.AI);
		GameContext.instance.setPlayerType(1, uiCheckBox2.checked ? PlayerType.Human : PlayerType.AI);
	}
	
	private function setStateOfCheckboxes()
	{
		var uiCheckBox1:FlxUICheckBox = cast _ui.getAsset("ai_check1");
		var uiCheckBox2:FlxUICheckBox = cast _ui.getAsset("ai_check2");
		
		uiCheckBox1.checked = GameContext.instance.getPlayerType(0) == PlayerType.Human;
		uiCheckBox2.checked = GameContext.instance.getPlayerType(1) == PlayerType.Human;
	}
	
	public function save()
	{
		MainState.getInstance().SaveMomento();
		close();
	}
	
	public function load()
	{
		MainState.getInstance().RestoreMomento();
		close();
	}
	
	public function restart()
	{
		close();
		MainState.getInstance().TryToRestart();
	}
	
	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
}