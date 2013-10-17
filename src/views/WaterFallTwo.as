package views {
	import controllers.SoundManager;

	import core.Sounds;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class WaterFallTwo extends Animation 
	{
		private static const WATER_FALL_FADE_IN_TIME:Number = 0.5;
		private static const WATER_FALL_FADE_OUT_TIME:Number = 0.5;
		private static const WATER_VOLUME:Number = 0.1;
			
		public static const FPS:Number = 10;
		
		public function WaterFallTwo( mc : MovieClip ) 
		{
			super( mc );
			startLoop();
		}
		
		public function startLoop():void
		{
			SoundManager.getInstance().createLoopCrossFade( Sounds.WATER_FALL2, WATER_FALL_FADE_IN_TIME, WATER_FALL_FADE_OUT_TIME, WATER_VOLUME );
			this.stop();
			this.currentFrame = 1;
			this.loopFrames( [ numFrames ], [ numFrames / FPS ] );
		}
	}
}
