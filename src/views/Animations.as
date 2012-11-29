package views {
	/**
	 * @author Adam
	 */
	public class Animations
	{
		public static function init():void
		{
			getAnimation( JUMP_UP );
		}
		
		public static const JUMP_UP:String = "JumpUp";
		public static const SIDE_JUMP:String = "SideJump";
		
		private static var animations:Object = {};
		
		/**
		 * Create the proper animated and return it.
		 */
		public static function getAnimation( type:String ):*
		{
			if( !animations[ type ] )
			{
				var animation:Animation;
				switch( type )
				{
					case NORMAL_STAND:
						animation = new Standing( type );
						break;
				}
				if( animation )
					animations[ type ] = animation;
			}
			return animations[ type ];
		}		
	}
}
