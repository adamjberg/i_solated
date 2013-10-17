package views {

	/**
	 * @author Adam
	 */
	public class CarryValveWalk extends CarryWalk 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="CarryWalkValve")]
		private const WALKING:Class;
		
		public function CarryValveWalk( type : String) 
		{
			super( new WALKING(), type);
		}
	}
}
