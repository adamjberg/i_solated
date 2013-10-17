package views {
	import controllers.SoundManager;

	import core.Sounds;

	/**
	 * @author Adam
	 */
	public class JumpDownSmall extends JumpAnimation 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="JumpDownSmall")]
		private static const JUMP_DOWN_SMALL:Class;
		
		private const START_JUMP:int = 2;
		private const START_FALL:int = 3;
		private const START_LAND:int = 4;		
				
		public function JumpDownSmall( type:String ) 
		{
			super( new JUMP_DOWN_SMALL(), START_JUMP, START_FALL, START_LAND );
			this.type = type;
		}
	}
}
