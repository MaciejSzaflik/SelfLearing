package utilites;
import gameLogic.GameContext;
import gameLogic.GamePlayer;
import gameLogic.ai.CurrentStateData.MoveDiagnose;
import gameLogic.ai.genetic.RewardGenetic;
import gameLogic.moves.MoveType;
#if neko
import sys.io.File;
import sys.io.FileOutput;
#end
import gameLogic.states.SelectMoveState;
import thx.Tuple.Tuple3;

/**
 * ...
 * @author ...
 */
class StatsGatherer 
{
	#if neko
	private var output : FileOutput;
	#end
	private var outputString : String;
	
	private var movePerformedValue : Array<Float>;
	private var movesPerfomedType : Map<MoveDiagnose,Int>;
	private var movesEvaluatedType : Map<MoveDiagnose,Int>;
	
	private var startHealth : Array<Int>;
	private var finished : Bool;
	
	static var gameCounter : Int;
	static var wins : Array<Int>;
	static var turns : Array<Int>;
	static var time : Array<Float>;
	static var winsValue : Array<Float>;
	
	static public var instance(get, never) : StatsGatherer;
	static private var _instance : StatsGatherer;
	
	
	public function AddToTime(value : Float, playerId : Int)
	{
		if (time == null)
		{
			time = new Array<Float>();
			time.push(0);
			time.push(0);
		}
		time[playerId] += value;
	}
	
	static function get_instance() : StatsGatherer
	{
		if (_instance == null)
		{
			StatsGatherer.gameCounter = 0;
			StatsGatherer.wins = new Array<Int>();
			StatsGatherer.wins.push(0);
			StatsGatherer.wins.push(0);
			
			StatsGatherer.turns = new Array<Int>();
			StatsGatherer.turns.push(0);
			StatsGatherer.turns.push(0);
			
			StatsGatherer.winsValue = new Array<Float>();
			StatsGatherer.winsValue.push(0.0);
			StatsGatherer.winsValue.push(0.0);
			
			_instance = new StatsGatherer();
		}
		return _instance;
	}
	
	private function new() 
	{
		openOutput();
	}
	
	public function initialize(startHealth : Array<Int>)
	{
		finished = false;
		this.startHealth = startHealth;
		movesPerfomedType = new Map<MoveDiagnose,Int>();
		movesEvaluatedType = new Map<MoveDiagnose,Int>();
		movePerformedValue = new Array <Float>();
		
		trace(this.startHealth);
	}
	
	private function openOutput()
	{
		#if neko
		output = File.write("test.csv", false);
		#end
		outputString = "";
	}
	
	private function prepareToTrace() : Array<String>
	{
		var toTrace : Array<String> = new Array<String>();
		
		var movesPreformedOut : String = "";
		for (key in movesPerfomedType.keys())
		{
			movesPreformedOut += key + "," + movesPerfomedType.get(key) + "\n";
		}
		toTrace.push(movesPreformedOut);
		
		var movesEvaluatedOut : String = "";
		for (key in movesEvaluatedType.keys())
		{
			movesEvaluatedOut += key + "," + movesEvaluatedType.get(key) + "\n";
		}
		toTrace.push(movesEvaluatedOut);
		
		var movesValues : String = "";
		for (i in 0...movePerformedValue.length)
		{
			movesValues += i + "," + movePerformedValue[i] + "\n";
		}
		
		toTrace.push(movesValues);
		return toTrace;
	}
	
	public function finish(endHealth : Array<Int>)
	{
		if (finished)
			return;
		
		#if neko
		output.close();
		output = null;
		#end
		//trace(outputString);
		//outputString = "";
		
		var healthLost = new Array<Float>();
		for (i in 0...startHealth.length)
		{
			healthLost.push((startHealth[i] - endHealth[i]) / startHealth[i]);
			trace("Player " + i + " health lost: " + ((startHealth[i] - endHealth[i]) / startHealth[i]));
		}
		
		RewardGenetic.instance.reportEvaluation(healthLost[0] / (healthLost[1] == 0 ? 1 : healthLost[1]));
		
		if (healthLost[0] < healthLost[1])
		{
			trace( GameContext.instance.mapOfPlayers.get(0).artificialInt + " " + 0 + " won");
			wins[0]++;
			winsValue[0] += healthLost[0];
			turns[0] += SelectMoveState.moveCounterPerPlayer[0];
		}
		else
		{
			trace( GameContext.instance.mapOfPlayers.get(1).artificialInt + " " + 1 + " won");
			wins[1]++;
			winsValue[1] += healthLost[1];
			turns[1] += SelectMoveState.moveCounterPerPlayer[1];
		}

		SelectMoveState.moveCounterPerPlayer = null;
		startHealth = null;
		
		
		finished = true;
		
		gameCounter++;
		
		if (gameCounter < 50)
			MainState.getInstance().restartFlag = true;
		else
		{
			trace(wins);
			if (wins[0] > 0)
			{
				trace("0 health factor: " + winsValue[0] / wins[0]);
				trace("turns 0: " + turns[0] / wins[0]);
				trace("time 0: " + time[0] / turns[0]);
			}
			
			if (wins[1] > 0)
			{
				trace("1 health factor: " + winsValue[1] / wins[1]);
				trace("turns 1: " + turns[1] / wins[1]);
				trace("time 1: " + time[1] / turns[1]);
			}
				
			for (value in prepareToTrace())
			{
				trace(value);
			}
			
			
			movesPerfomedType = new Map<MoveDiagnose,Int>();
			movesEvaluatedType = new Map<MoveDiagnose,Int>();
			movePerformedValue = new Array <Float>();
		}
		/*
		if (RewardGenetic.instance.currentItemEvaluated < RewardGenetic.instance.sizeOfPopulation)
			MainState.getInstance().restartFlag = true;
		else
		{
			trace(wins);
			
			if(wins[0] > 0)
				trace("0 health factor" + winsValue[0] / wins[0]);
			
			if(wins[1] > 0)
				trace("1 health factor" + winsValue[1] / wins[1]);
				
			for (value in prepareToTrace())
			{
				trace(value);
			}
			
			trace(RewardGenetic.instance.generationMean);
		}*/
	}
	
	public function onMovePerformed(value : Tuple3<Float,MoveDiagnose,MoveDiagnose>)
	{
		movePerformedValue.push(value._0);
		UtilUtil.IncremanteIfPossible(movesPerfomedType, value._1);
		UtilUtil.IncremanteIfPossible(movesPerfomedType, value._2);
	}
	
	public function onMoveEvaluated(value : Tuple3<Float,MoveDiagnose,MoveDiagnose>)
	{
		UtilUtil.IncremanteIfPossible(movesEvaluatedType, value._1);
		UtilUtil.IncremanteIfPossible(movesEvaluatedType, value._2);
	}
	
	public function write(print : Bool, moveCounter : Int, totalTime: Float, moveTime : Float, evaluationTime : Float, nodes : Int, childeren : Int)
	{
		var toWrite = moveCounter + "," + totalTime+"," + moveTime+"," + evaluationTime+"," + nodes + "," + childeren + "\n";
		#if neko
		if (output == null)
			openOutput();
		output.writeString(toWrite);
		#end
		outputString += toWrite;
		
		if (print)
			trace(toWrite);
	}
}