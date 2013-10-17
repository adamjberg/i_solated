package views {
	import views.CarryStand;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class CarryCogStand extends CarryStand 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="CarryStandCog")]
		private static const STANDING:Class;
		
		public function CarryCogStand( type : String ) 
		{
			super( new STANDING(), type );
		}
	}
}
