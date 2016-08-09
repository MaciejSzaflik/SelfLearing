package utilites;
import game.CreatureDefinition;
import haxe.Constraints.Function;
import haxe.Http;
import haxe.Json;
import tjson.TJSON;
/**
 * ...
 * @author 
 */
class GameConfiguration
{
	public var creatures:Map<Int,CreatureDefinition>;
	
	@:isVar static public var instance(get,set) : GameConfiguration;
	static function get_instance() : GameConfiguration
	{
		return instance;
	}
	
	static function set_instance(conf:GameConfiguration)
	{
		return instance = conf;
	}
	
	private function new(callBack:Function) 
	{
		creatures = new Map<Int,CreatureDefinition>();
		
		var loadConfigurationRequest = new Http("https://api.github.com/gists/6477e19437bc24fc24ebc1879b6087a4");
		loadConfigurationRequest.request(false);
		loadConfigurationRequest.onData = function(data) 
		{ 
			parseRawData(data); 
			if (callBack != null)
				callBack();
		};
	}
	
	private function parseRawData(data:String)
	{
		var map = JsonSerializer.deserialize(data);
		var content = Reflect.getProperty(map.files, "configuration.json").content;
		var parsedContent:Array<Dynamic> = Json.parse(content);
		for (creature in parsedContent)
		{
			var creatureDef = CreatureDefinition.fromDynamic(creature);
			creatures.set(creatureDef.id, creatureDef);
		}
	}
	
	public static function init(callBack:Function)
	{
		GameConfiguration.instance = new GameConfiguration(callBack);
	}
	
}