package views {

	/**
	 * @author Adam
	 */
	public class SideJump extends JumpAnimation 
	{		
		[Embed(source="/../assets/ZOOOP.swf", symbol="Leap")]
		private static const LEAP:Class;
		
		private const START_JUMP:int = 4;
		private const START_FALL:int = 6;
		private const START_LAND:int = 7;
		
		public function SideJump( type:String ) 
		{
			super( new LEAP(), START_JUMP, START_FALL, START_LAND );
			this.type = type;
		}
	}
}
