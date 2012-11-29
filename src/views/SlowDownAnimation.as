package views {
	import controllers.SoundManager;

	import core.Sounds;

	/**
	 * @author Adam
	 */
	public class SlowDownAnimation extends Animation 
	{
		private static const FPS:Number = 10;
		
		[Embed(source ="/../assets/zoopch2.swf", symbol="SlowToRest")]
		private static const SLOW_TO_REST:Class;
		
		public function SlowDownAnimation( type:String ) 
		{
			super( new SLOW_TO_REST() );
			this.type = type;
		}
		
		override public function play( playTransition:Boolean = true ):void
		{
			SoundManager.getInstance().playSound( Sounds.REST_SCENE );
			this.stop();
			this.currentFrame = 1;
			this.setAnimationTimes( [ 80 ], [ ( 80 ) / FPS ], _loopEnd );
		}
		
		private function _loopEnd():void
		{
			onComplete.dispatch();
			this.loopFrames( [ numFrames ], [ ( numFrames - currentFrame ) / FPS ] );
		}
	}
}
