package utilites;
import data.FrameAnimationDef;
import data.SpriteDefinition;
import data.CreatureDefinition;
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
	public var frameAnimations:Map<Int,FrameAnimationDef>;
	public var spriteDefinitions:Map<Int,SpriteDefinition>;
	
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
		frameAnimations = new Map<Int,FrameAnimationDef>();
		spriteDefinitions= new Map<Int,SpriteDefinition>();
		
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
		var parsedContent = Json.parse(content);
		parseCreatures(parsedContent[0].creatures);
		parseFrameAnimations(parsedContent[0].creatureAnimations);
		parseSpriteDefinitions(parsedContent[0].creatureSprites);
		
	}
	
	private function parseCreatures(data:Array<Dynamic>)
	{
		for (creature in data)
		{
			var creatureDef = CreatureDefinition.createEmpty();
			JsonSerializer.fillObjectWithDynamic(creatureDef, creature);
			creatures.set(creatureDef.id, creatureDef);
		}
	}
	
	private function parseFrameAnimations(data:Array<Dynamic>)
	{
		for (frameAnimation in data)
		{
			var frameAnimationDef = FrameAnimationDef.createEmpty();
			JsonSerializer.fillObjectWithDynamic(frameAnimationDef, frameAnimation);
			frameAnimations.set(frameAnimationDef.id, frameAnimationDef);
		}
	}
	
	private function parseSpriteDefinitions(data:Array<Dynamic>)
	{
		for (sprite in data)
		{
			var spriteDef = SpriteDefinition.createEmpty();
			JsonSerializer.fillObjectWithDynamic(spriteDef, sprite);
			spriteDefinitions.set(spriteDef.id, spriteDef);
		}
	}
	
	
	public static function init(callBack:Function)
	{
		GameConfiguration.instance = new GameConfiguration(callBack);
	}
	
}