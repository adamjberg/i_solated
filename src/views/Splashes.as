package views {
	import views.Animation;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class Splashes extends Animation 
	{
		public function Splashes(mc : MovieClip ) 
		{
			super(mc);
			this._loop();
		}
		
		private function _loop():void
		{
			this.stop();
			this.currentFrame = 1;
			this.loopFrames( [ numFrames ], [ numFrames / 10 ] );
		}
	}
}
