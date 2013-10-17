package core {
	/**
	 * @author Adam
	 */
	public class Gravity 
	{
		public static function getTimeTilPeak( gravity:Number, startVelocity:Number ):Number
		{
			if( startVelocity > 0 )
				return 0;
			return Math.abs( startVelocity / gravity );
		}
		
		public static function getTotalAirTime( gravity:Number, velocity:Number, displacement:Number ):Number
		{
			var results:Array = getQuadraticRoots( gravity / 2, velocity, displacement );
			var ans:Number = Math.max( Math.abs( results[ 0 ] ), Math.abs( results[ 1 ] ) );
			if( isNaN( ans ) )
				return 0.01;
			return ans;
		}
		
		private static function getQuadraticRoots(a:Number, b:Number, c:Number):Array 
		{
			var results:Array = new Array();
			var sqt:Number = Math.sqrt(Math.pow(b, 2) - 4*a*c);
			var root1:Number = (b+sqt)/(2*a);
			var root2:Number = (b-sqt)/(2*a);
			if (!isNaN(root1))
			{
				results.push(root1);
			}
			if (!isNaN(root2)) 
			{
				results.push(root2);
			}
			return results;
		}
	}
}
