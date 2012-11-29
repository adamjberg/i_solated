package views {
	import controllers.SoundManager;

	import core.Sounds;

	import models.JumpAnimationModel;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class JumpAnimation extends Animation 
	{
		private const FPS:int = 10;
		private static const OFFSET:Number = 0.01;
		
		
		public var model:JumpAnimationModel;
		
		public function JumpAnimation( mc:MovieClip, startJump:int, startFall:int, startLand:int ) 
		{
			model = new JumpAnimationModel( startJump, startFall, startLand );
			super( mc );
 		}
		
		override public function play( inTransition:Boolean = false ):void
		{
			this.currentFrame = 1;
			this.setAnimationTimes( [ model.startJump - OFFSET ], [ model.timeTilStart ], startJump );
		}
		
		private function startJump():void
		{
			SoundManager.getInstance().playSound( Sounds.START_JUMP );
			this.setAnimationTimes( [ model.startFall - OFFSET ], [ model.timeTilPeak ], startFall );
		}
		
		private function startFall():void
		{
			this.stop();
			this.currentFrame = model.startFall;
			this.loopFrames( [ model.startLand - 0.01 ], [ ( model.startLand - this.currentFrame ) / FPS ])
		}
		
		public function startLand():void
		{
			this.stop();
			this.currentFrame = this.model.startLand;
			SoundManager.getInstance().playSound( Sounds.SMALL_LANDING );
			this.setAnimationTimes( [ numFrames ], [ ( numFrames - currentFrame ) / FPS  ], onComplete.dispatch );
		}
	}
}
