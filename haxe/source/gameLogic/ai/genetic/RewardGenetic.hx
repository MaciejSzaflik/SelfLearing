package gameLogic.ai.genetic;
import thx.Tuple.Tuple2;
import utilites.StorageHelper;

/**
 * ...
 * @author ...
 */
class RewardGenetic
{
	public var sizeOfPopulation = 50;
	public static var instance(get, null):RewardGenetic;
	private static function get_instance():RewardGenetic {
        if(instance == null) {
            instance = new RewardGenetic(50);
        }
        return instance;
    }
	
	public var currentPopulationNumber : Int;
	public var currentItemEvaluated : Int;
	
	public var evaluations : Array<Float>;
	public var currentPopulation : Array<Array<Float>>;
	
	public function new(populationSize : Int) 
	{
		this.sizeOfPopulation = populationSize;
		//currentPopulation = new Array<Array<Float>>();
		generateInitialPopulation();
	}
	
	public function getCurrentConfiguration() : Array<Float>
	{
		return currentPopulation[currentItemEvaluated];
	}
	
	public function reportEvaluation(value : Float)
	{
		evaluations[currentItemEvaluated] = value;
		currentItemEvaluated++;
		saveCurrent();
	}
	
	public function generateInitialPopulation()
	{
		currentPopulationNumber = 0;
		currentItemEvaluated = 0;
		evaluations = new Array<Float>();
		currentPopulation = new Array<Array<Float>>();
		for (i in 0...sizeOfPopulation)
		{
			currentPopulation.push(generateArray(100, 12));
		}
	}
	
	public function blxCrossover(x : Array<Float>, y : Array<Float>, a : Float) : Tuple2<Array<Float>,Array<Float>>
	{
		var children = new Tuple2(new Array<Float>(),new Array<Float>());

		for (i in 0...x.length)
		{
			var d = Math.abs(x[i] - y[i]);
			var u1 = Random.float(Math.min(x[i], y[i]) - a * d, Math.max(x[i], y[i]) + a * d);
			var u2 = Random.float(Math.min(x[i], y[i]) - a * d, Math.max(x[i], y[i]) + a * d);
			
			children._0.push(u1);
			children._1.push(u2);
		}
		return children;
	}
	
	public function saveCurrent()
	{
		StorageHelper.instance.saveItem("currentPopulationNumber", Std.string(currentPopulationNumber));
		StorageHelper.instance.saveItem("currentEval", valuesToString(evaluations));
		for (i in 0...sizeOfPopulation)
		{
			StorageHelper.instance.saveItem("p."+i,valuesToString(currentPopulation[i]));
		}
	}
	
	public function valuesToString(values : Array<Float>) : String
	{
		var sb : StringBuf = new StringBuf();
		for ( value in values)
		{
			sb.add(value);
			sb.addChar(59);
		}
		return sb.toString();
	}
	
	public function stringToValues(value : String) : Array<Float>
	{
		var toReturn : Array<Float> = new Array<Float>();
		for (number in value.split(";"))
		{
			if (number != "")
			{
				toReturn.push(Std.parseFloat(number));
			}
		}
		return toReturn;
	}
	
	
	public function generateArray(range:Int, size : Int = 12) : Array<Float>
	{
		var toReturn : Array<Float> = new Array<Float>();
		
		for (i in 0...size)
		{
			toReturn.push(Random.float( -range, range));
		}
		
		
		return toReturn;
	}
	
}