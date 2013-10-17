package views {
	import views.Animation;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class PreControlBox extends Animation 
	{
		private const FPS:Number = 10;
		
		public function PreControlBox(mc : MovieClip ) 
		{
			super(mc );
			loop();
		}
		
		public function loop():void
		{
			this.currentFrame = 1;
			this.loopFrames( [ numFrames ], [ numFrames / FPS ] );
		}
	}
}
