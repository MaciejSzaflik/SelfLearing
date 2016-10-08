package gameLogic.actions;
import animation.MoveBetweenPoints;
import animation.Tweener;
import game.Creature;
import haxe.Constraints.Function;
import hex.HexCoordinates;

/**
 * ...
 * @author 
 */
class MoveAction extends Action
{
	private var moveTo:Int;
	private var moveFrom:Int;
	
	public function new(creatureToMove:Creature,moveTo:Int,onFinish:Function) 
	{
		super();
		this.performer = creatureToMove;
		this.moveTo = moveTo;
		this.moveFrom = creatureToMove.currentCordinates.toKey();
		this.onFinish = onFinish;
	}
	
	override public function performAction() 
	{
		super.performAction();
		var checkpoints = GameContext.instance.map.getPathCenters(performer.currentCordinates.toKey(), moveTo);
		performer.setCoodinates(GameContext.instance.map.getHexByIndex(moveTo).getCoor());
		
		MainState.getInstance().drawHexesRange(checkpoints, 1,0x55ffff44);
		
		var moveAnimation = new MoveBetweenPoints(
			performer,
			checkpoints
			,0.01 * checkpoints.length,
			onFinish);
			
		Tweener.instance.addAnimation(moveAnimation);
	}
	
	override public function resetAction()
	{
		this.performer.setCoodinates(GameContext.instance.map.getHexByIndex(moveFrom).getCoor());
	}
}