package views {
	import controllers.SoundManager;

	import core.SoundItem;
	import core.Sounds;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class SurfIntro extends Animation 
	{
		private const FPS:Number = 10;
		private const START_LOOP:Number = 39;
		
		public function SurfIntro( mc : MovieClip ) 
		{
			super( mc );
			play();
		}
		
		override public function play( fadeTransition:Boolean = false ):void
		{
			SoundManager.getInstance().createLoopCrossFade( Sounds.FACTORY_RIVER, 2, 2 );
			this.stop();
			this.currentFrame = 1;
			this.setAnimationTimes( [ START_LOOP ], [ START_LOOP / FPS ], this._loop );
		}
		
		private function _loop():void
		{
			this.onComplete.dispatch();
			this.currentFrame = START_LOOP;
			this.loopFrames( [ numFrames ], [ ( numFrames - currentFrame ) / FPS ] );
		}
	}
}
