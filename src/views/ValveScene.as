package views {
	import controllers.SoundManager;
	import core.Sounds;
	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class ValveScene extends Animation 
	{		
		private const FPS:Number = 10;
		
		public function ValveScene(mc : MovieClip ) 
		{
			super(mc);
		}
		
		override public function play( playTransition:Boolean = false ):void
		{
			SoundManager.getInstance().playSound( Sounds.VALVE_SCENE );
			this.currentFrame = 2;
			this.setAnimationTimes( [ numFrames ], [ ( numFrames - currentFrame - 4 ) / FPS ], onComplete.dispatch );
		}
	}
}
