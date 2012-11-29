package views {

	/**
	 * @author Adam
	 */
	public class JumpDownLarge extends JumpAnimation 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="JumpDownBig")]
		private static const JUMP_DOWN_LARGE:Class;
		
		private const START_JUMP:int = 2;
		private const START_FALL:int = 3;
		private const START_LAND:int = 5;		
				
		public function JumpDownLarge( type:String ) 
		{
			super( new JUMP_DOWN_LARGE(), START_JUMP, START_FALL, START_LAND );
			this.type = type;
		}
	}
}
