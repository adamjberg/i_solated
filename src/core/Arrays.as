package core {
	/**
	 * @author Adam
	 */
	public class Arrays 
	{
		/**
		 * Returns whether the first array contains everything in the second array
		 */
		public static function contains( array1:Array, array2:Array ):Boolean
		{
			if( array2.length > array1.length )
				return false;
			var numMatched:int = 0;
			for( var i:int = 0; i < array2.length; i++ )
			{
				for( var j:int = 0; j < array1.length; j++ )
				{
					if( array2[ i ] == array1[ j ] )
						numMatched++;
				}
			}
			return numMatched >= array2.length;
		}
		
		public static function remove( source:Array, toRemove:Array ):Array
		{
			var allow:Boolean;
			var result:Array = [];
			for( var i:int = 0; i < source.length; i++ )
			{
				allow = true;
				for( var j:int = 0; j < toRemove.length; j++ )
				{
					if( source[ i ] == toRemove[ j ] )
					{
						allow = false;
					}
				}
				if( allow )
					result.push( source[ i ] );
			}
			return result;
		}
	}
}
