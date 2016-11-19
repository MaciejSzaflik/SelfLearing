package gameLogic.actions;
import gameLogic.abilites.AbilityFactory;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;
import haxe.Constraints.Function;

/**
 * ...
 * @author 
 */
class ActionFactory
{
	public static function actionFromMoveData(moveData:MoveData,callback:Function,animation:Bool = false):Action
	{
		var toReturn:Action = null;
		switch(moveData.type)
		{
			case MoveType.Move:
				toReturn = createMoveAction(moveData,callback,animation);
			case MoveType.Attack:
				toReturn = createAttackAction(moveData,callback,animation);
			case MoveType.Ability:
				toReturn = createAbilityAction(moveData);
			case MoveType.Defend:
				toReturn = createDefendAction(moveData,callback);
			case MoveType.Wait:
				toReturn = createWaitAction(moveData,callback);
			case MoveType.Pass:
				toReturn = createPassAction(moveData);
		}
		return toReturn;
	}
	private static function createMoveAction(moveData:MoveData,callback:Function,animation:Bool):MoveAction
	{
		return new MoveAction(moveData.performer, moveData.tileId, callback, animation);
	}
	private static function createAttackAction(moveData:MoveData,callback:Function,animation:Bool):AttackAction
	{
		return new AttackAction(moveData.performer, moveData.affected,callback,animation);
	}
	private static function createAbilityAction(moveData:MoveData):AbilityAction
	{
		return new AbilityAction(AbilityFactory.instance.getAbility(moveData.performer, moveData.abilityId));
	}
	private static function createDefendAction(moveData:MoveData,callback:Function):DefendAction
	{
		return new DefendAction(moveData.performer, callback);
	}
	private static function createWaitAction(moveData:MoveData,callback:Function):WaitAction
	{
		return new WaitAction(moveData.performer,callback);
	}
	private static function createPassAction(moveData:MoveData):Action
	{
		return null;
	}
	
}