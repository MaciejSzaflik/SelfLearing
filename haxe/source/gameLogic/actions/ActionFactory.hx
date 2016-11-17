package gameLogic.actions;
import gameLogic.abilites.AbilityFactory;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;

/**
 * ...
 * @author 
 */
class ActionFactory
{

	public static function actionFromMoveData(moveData:MoveData):Action
	{
		switch(moveData.type)
		{
			case MoveType.Move:
				return createMoveAction(moveData);
			case MoveType.Attack:
				return createAttackAction(moveData);
			case MoveType.Ability:
				return createAbilityAction(moveData);
			case MoveType.Defend:
				return createDefendAbility(moveData);
			case MoveType.Wait:
				return createWaitAction(moveData);
			case MoveType.Pass:
				return createPassAction(moveData);
		}
		return null;
	}
	private static function createMoveAction(moveData:MoveData):MoveAction
	{
		return new MoveAction(moveData.performer, moveData.tileId, null);
	}
	private static function createAttackAction(moveData:MoveData):AttackAction
	{
		return new AttackAction(moveData.performer, moveData.affected);
	}
	private static function createAbilityAction(moveData:MoveData):AbilityAction
	{
		return new AbilityAction(AbilityFactory.instance.getAbility(moveData.abilityId, moveData.abilityId));
	}
	private static function createDefendAction(moveData:MoveData):DefendAction
	{
		return new DefendAction(moveData.performer, null);
	}
	private static function createWaitAction(moveData:MoveData):DefendAction
	{
		return new WaitAction(moveData.performer, null);
	}
	private static function createPassAction(moveData:MoveData):Action
	{
		return null;
	}
	
}