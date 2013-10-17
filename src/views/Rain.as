package views {
	import views.Animation;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class Rain extends Animation 
	{
		private const FPS:Number = 10;
		
		public function Rain( mc : MovieClip ) 
		{
			super(mc);
			_loop();
		}
		
		private function _loop():void
		{
			this.stop();
			this.currentFrame = 1;
			this.loopFrames( [ numFrames ], [ numFrames / FPS ] );	
		}
	}
}
