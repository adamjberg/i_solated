package views {
	import views.Animation;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class CityGaze extends Animation 
	{
		private static const FPS:Number = 10;
		
		private static const START_FACE_BACK:Number = 2;
		private static const END_FACE_BACK:Number = 3.99;
		
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
			setAnimationTimes( [ END_FACE_BACK ], [ ( END_FACE_BACK - this.currentFrame ) / FPS ], _startLoop );
		}
		
		override public function outTransition( playTransition:Boolean = false ):void
		{
			this.stop();
			this.currentFrame = END_FACE_BACK;
			setAnimationTimes( [ this.numFrames ], [ ( this.numFrames - this.currentFrame ) / FPS ], onOutTrantisionComplete.dispatch );
		}
		
		private function _startLoop():void
		{
			this.stop();
			this.currentFrame = START_FACE_BACK;
			this.loopFrames( [ END_FACE_BACK ], [ ( END_FACE_BACK - this.currentFrame ) / FPS ] );
		}
	}
}
