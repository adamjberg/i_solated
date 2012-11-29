package views {
	import views.CarryStand;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class CarryValveStand extends CarryStand 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="CarryStandValve")]
		private static const STANDING:Class;
		
		public function CarryValveStand( type : String ) 
		{
			super( new STANDING(), type );
		}
	}
}
