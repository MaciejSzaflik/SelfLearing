package gameLogic.states;
import animation.MoveBetweenPoints;
import animation.Tweener;
import game.Creature;
import hex.HexCoordinates;

/**
 * ...
 * @author 
 */
class MoveState extends State
{
	public function new(stateMachine:StateMachine,creatureToMove:Creature,moveTo:HexCoordinates)
	{
		this.stateName = "Moving";
		super(stateMachine);
		var checkpoints = GameContext.instance.map.getPathCenters(creatureToMove.currentCordinates.toKey(), moveTo.toKey());
		creatureToMove.setCoodinates(moveTo);
		
		MainState.getInstance().drawHexesRange(checkpoints, 1,0x55ffff44);
		
		var moveAnimation = new MoveBetweenPoints(
			creatureToMove,
			checkpoints
			,0.02*checkpoints.length,
			function() 
			{	
				MainState.getInstance().getDrawer().clear(1);
				stateMachine.setCurrentState(new SelectMoveState(this.stateMachine));				
			});
		Tweener.instance.addAnimation(moveAnimation);
	}
	
}