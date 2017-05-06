package utilites;

/**
 * ...
 * @author ...
 */
class RandomUtil 
{

	public static function boxMullerGaussian(mu : Float, sigma : Float) : Float
	{
		var radiusSquared = Math.POSITIVE_INFINITY;
		
		var u, v = 0.0;
		
		while(radiusSquared >= 1)
		{
			u = 2*Math.random() - 1;
			v = 2*Math.random() - 1;
			
			radiusSquared = Math.pow(u, 2) +  Math.pow(v, 2);
		}
		
		var scaleFactor = Math.sqrt(( -2 * Math.log(radiusSquared)) / radiusSquared);
		return v * scaleFactor * sigma + mu;
	}
	
}