package views {
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Adam
	 */
	public class FrontPreForegroundTwo extends Sprite 
	{
		public static const WATER_FALL:String = 'preWaterFall';
		public static const BRIDGE:String = 'PreBridge';
		public static const WATER_WHEEL:String = 'preWaterWheel';
		
		private var waterFall:MovieClip;
		private var waterFallAnimation:WaterFall;
		private var bridge:Sprite;
		private var waterWheel:MovieClip;
		private var waterWheelAnimation:WaterWheel;
		
		public function FrontPreForegroundTwo( foreground:Sprite, xOffset:Number ) 
		{
			bridge = foreground.getChildByName( BRIDGE ) as Sprite;
			waterFall = foreground.removeChild( foreground.getChildByName( WATER_FALL ) ) as MovieClip;
			waterFallAnimation = new WaterFall( waterFall );
			waterWheel = foreground.removeChild( foreground.getChildByName( WATER_WHEEL ) ) as MovieClip;
			waterWheelAnimation = new WaterWheel( waterWheel, true );
			waterWheelAnimation.loop();
			
			var objects:Array = [ bridge, waterFall, waterWheel ];
			objects.forEach( function( object:Sprite, i:int, a:Array ):void
			{
				object.x += foreground.x;
				object.y += foreground.y;
			});
						
			addChild( bridge );
			addChild( waterFallAnimation );
			addChild( waterWheelAnimation );
		}		
				
		public function removeWaterfall():void
		{
			removeChild( waterFallAnimation );
			waterFallAnimation.destroy();
			waterFallAnimation = null;
		}
		
		public function removeWaterWheel():void
		{
			if( contains( waterWheelAnimation ) )
			{
				waterWheelAnimation.destroy();
				removeChild( waterWheelAnimation );
			}
		}
		
		public function removeBridge():void
		{
			removeChild( bridge );
		}
	}
}
