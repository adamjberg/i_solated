package views {
	import flash.display.Sprite;

	/**
	 * @author Adam
	 */
	public class TaggableMask extends Sprite 
	{
		public static const CENTER:int = 0;
		public static const TOP_LEFT:int = 1;
		public static const BOTTOM_LEFT:int = 2;
		public static const BOTTOM_CENTER:int = 3;
		public static const BOTTOM_RIGHT:int = 4;
		public static const TOP_CENTER:int = 5;
		public static const TOP_RIGHT:int = 6;
		public static const CENTER_RIGHT:int = 7;
		public static const CENTER_LEFT:int = 8;
		
		public var position:int;
		
		public function TaggableMask( position:int = CENTER ) 
		{
			this.position = position;
		}
	}
}
