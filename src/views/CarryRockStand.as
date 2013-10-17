package views {
	import views.CarryStand;

	/**
	 * @author Adam
	 */
	public class CarryRockStand extends CarryStand 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="CarryStand")]
		private static const STANDING:Class;
		
		public function CarryRockStand( type:String ) 
		{
			super( new STANDING(), type );
		}
	}
}
