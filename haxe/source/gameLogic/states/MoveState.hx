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
		creatureToMove.currentCordinates = moveTo;
		
		var moveAnimation = new MoveBetweenPoints(
			creatureToMove,
			checkpoints
			,0.02*checkpoints.length,
			function() 
			{	
				stateMachine.setCurrentState(new SelectMoveState(this.stateMachine));				
			});
		Tweener.instance.addAnimation(moveAnimation);
	}
	
}