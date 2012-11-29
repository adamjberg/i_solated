package models {
	import flash.geom.Point;

	/**
	 * @author Adam
	 */
	public class BeachForeground extends ForegroundModel 
	{
		public function BeachForeground() 
		{
			super( [ 
 				new Point( 402, 412 ), new Point( 447, 414 ), new Point( 533, 415 ), new Point( 643, 431 ), new Point( 750, 452 ),
				new Point( 778, 460 ), new Point( 820, 480 )
			] );
		}
	}
}
