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
	private var creatureToMove:Creature;
	private var moveTo:Int;
	private var onFinish:Function;
	
	public function new(creatureToMove:Creature,moveTo:Int,onFinish:Function) 
	{
		super();
		this.creatureToMove = creatureToMove;
		this.moveTo = moveTo;
		this.onFinish = onFinish;
	}
	
	override public function performAction() 
	{
		super.performAction();
		var checkpoints = GameContext.instance.map.getPathCenters(creatureToMove.currentCordinates.toKey(), moveTo);
		creatureToMove.setCoodinates(GameContext.instance.map.getHexByIndex(moveTo).getCoor());
		
		MainState.getInstance().drawHexesRange(checkpoints, 1,0x55ffff44);
		
		var moveAnimation = new MoveBetweenPoints(
			creatureToMove,
			checkpoints
			,0.018 * checkpoints.length,
			onFinish);
			
		Tweener.instance.addAnimation(moveAnimation);
	}
	
}