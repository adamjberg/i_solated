package views {

	/**
	 * @author Adam
	 */
	public class JumpUp extends JumpAnimation 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="JumpUp")]
		private static const JUMP_UP:Class;
		
		private const START_JUMP:int = 3;
		private const START_FALL:int = 6;
		private const START_LAND:int = 7;
		
		public function JumpUp( type:String ) 
		{
			super( new JUMP_UP(), START_JUMP, START_FALL, START_LAND );
			this.type = type;
		}
	}
}
