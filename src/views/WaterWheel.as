package views {
	import controllers.SoundManager;
	import core.Sounds;
	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class WaterWheel extends Animation 
	{
		private const FPS:Number = 10;
		private var prePulse:Boolean;
		
		public function WaterWheel( mc : MovieClip, pre:Boolean = false ) 
		{
			super( mc );
			prePulse = pre;
		}
		
		public function loop():void
		{
			this.stop();
			if( !prePulse )
				SoundManager.getInstance().createLoopCrossFade( Sounds.WATER_WHEEL, 0.1, 0.1 );
			this.currentFrame = 2;
			this.loopFrames( [ numFrames ], [ numFrames / FPS ] );
		}
	}
}
