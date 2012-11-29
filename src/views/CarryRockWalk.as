package views {
	import views.CarryWalk;

	/**
	 * @author Adam
	 */
	public class CarryRockWalk extends CarryWalk 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="CarryWalk")]
		private const WALKING:Class;
		
		public function CarryRockWalk(type : String) 
		{
			super( new WALKING(), type);
		}
	}
}
