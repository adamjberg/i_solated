package views {
	import views.Animation;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class CityGaze extends Animation 
	{
		private static const FPS:Number = 10;
		
		[Embed( source ="/../assets/ZOOOP.swf", symbol="CityGaze")]
		private static const CITY_GAZE:Class;
		
		public function CityGaze( type:String ) 
		{
			super( new CITY_GAZE() );
			this.type = type;
		}
		
		override public function play( playTransition:Boolean = true ):void
		{
			this.stop();			
			this.currentFrame = 1;
			setAnimationTimes( [ 3 ], [ 0.2 ], _startLoop );
		}
		
		override public function outTransition( playTransition:Boolean = false ):void
		{
			this.stop();
			this.currentFrame = 3;
			setAnimationTimes( [ 5 ], [ .2 ], onOutTrantisionComplete.dispatch );
		}
		
		private function _startLoop():void
		{
			this.stop();
			this.currentFrame = 2;
			this.loopFrames( [ 3.99 ], [ .2 ] );
		}
	}
}
