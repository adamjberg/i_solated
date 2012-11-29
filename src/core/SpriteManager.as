package core {
	import flash.display.Sprite;
	/**
	 * @author Adam
	 */
	public class SpriteManager 
	{
		public static function disableMouse( sprite:Sprite ):void
		{
			sprite.mouseEnabled = sprite.mouseChildren = false;
		}
		
		public static function disableMouses( sprites:Array ):void
		{
			sprites.forEach( function( sprite:Sprite, i:int, a:Array ):void
			{
				disableMouse( sprite );
			});
		}
		
		public static function enableMouse( sprite:Sprite ):void
		{
			sprite.mouseEnabled = sprite.mouseChildren = true;
		}
	}
}
