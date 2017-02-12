package gameLogic.actions;
import animation.MoveBetweenPoints;
import animation.Tweener;
import game.Creature;
import haxe.Constraints.Function;
import hex.HexCoordinates;
import ui.ColorTable;

/**
 * ...
 * @author 
 */
class MoveAction extends Action
{
	private var moveTo:Int;
	private var moveFrom:Int;
	private var withAnimation:Bool;
	
	public function new(creatureToMove:Creature,moveTo:Int,onFinish:Function,withAnimation:Bool = false) 
	{
		super();
		this.performer = creatureToMove;
		this.moveTo = moveTo;
		this.moveFrom = creatureToMove.currentCordinates.toKey();
		this.onFinish = onFinish;
		this.withAnimation = withAnimation;
	}
	
	private function endWithoutAnimation()
	{
		performer.setCoodinates(GameContext.instance.map.getHexByIndex(moveTo).getCoor());
		if (onFinish!=null)
			onFinish();
	}
	
	override public function performAction() 
	{
		super.performAction();
		
		var from = performer.currentCordinates.toKey();
		if (!withAnimation)
		{
			endWithoutAnimation();
			return;
		}
		var checkpoints = GameContext.instance.map.getPathCenters(from, moveTo);
		if (checkpoints == null)
		{
			endWithoutAnimation();
			return;
		}
		performer.setCoodinates(GameContext.instance.map.getHexByIndex(moveTo).getCoor());

		MainState.getInstance().drawHexesRange(checkpoints, 1, ColorTable.MOVING_COLOR);
		
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