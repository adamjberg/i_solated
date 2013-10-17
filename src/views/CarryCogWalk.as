package views {

	/**
	 * @author Adam
	 */
	public class CarryCogWalk extends CarryWalk 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="CarryWalkCog")]
		private const WALKING:Class;
		
		public function CarryCogWalk( type : String ) 
		{
			super( new WALKING(), type );
		}
	}
}
