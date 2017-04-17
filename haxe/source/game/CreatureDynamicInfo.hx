package game;
import hex.HexCoordinates;
/**
 * ...
 * @author ...
 */
class CreatureDynamicInfo 
{
	public var contrattackCounter:Int;
	public var currentActionPoints:Int;
	public var defending:Bool;
	public var waited:Bool;
	
	public var stackSize:Int;
	
	public var moved:Bool = false;
	public var lostHitPoints = 0;
	public var currentHealth:Int;
	
	public var currentCordinates:HexCoordinates;
	
	public var definitionId:Int;
	
	public function new() 
	{
		
	}
	
	public function applyInfo(info:CreatureDynamicInfo)
	{
		this.contrattackCounter = info.contrattackCounter;
		this.currentActionPoints = info.currentActionPoints;
		this.defending = info.defending;
		this.waited = info.waited;
		this.definitionId = info.definitionId;
		
		this.stackSize = info.stackSize;
		
		this.moved = info.moved;
		this.lostHitPoints = info.lostHitPoints;
		this.currentHealth = info.currentHealth;
		trace(this.currentCordinates + " " + info.currentCordinates);
		if(info.currentCordinates!=null)
			this.currentCordinates = info.currentCordinates.copy();  
	}
	
	public function copy() : CreatureDynamicInfo
	{
		var toReturn : CreatureDynamicInfo = new CreatureDynamicInfo();
		toReturn.contrattackCounter = this.contrattackCounter;
		toReturn.currentActionPoints = this.currentActionPoints;
		toReturn.defending = this.defending;
		toReturn.waited = this.waited;
		toReturn.definitionId = this.definitionId;
		
		toReturn.stackSize = this.stackSize;
		
		toReturn.moved = this.moved;
		toReturn.lostHitPoints = this.lostHitPoints;
		toReturn.currentHealth = this.currentHealth;
		
		if(this.currentCordinates!=null)
			toReturn.currentCordinates = this.currentCordinates.copy();  
			
		return toReturn;
	}
}