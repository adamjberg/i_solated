package views {
	import controllers.SoundManager;

	import core.Sounds;

	import models.PlayerModel;
	/**
	 * @author Adam
	 */
	public class FinalWalk extends Animation
	{
		private static const FPS:Number = 10;
		
		private static const START_LOOP:Number = 23;
		
		[Embed(source="/../assets/ZOOOP.swf", symbol="FinalWalk")]
		private static const FINAL_WALK:Class;
		
		private var model:PlayerModel;
		
		public function FinalWalk( model:PlayerModel ) 
		{
			super( new FINAL_WALK() );
			this.model = model;
			this.model.onPosChanged.add( updatePosition );
			_loopEnd();
			updatePosition();
		}
		
		override public function play( playTransition:Boolean = false ):void
		{
			SoundManager.getInstance().playSound( Sounds.SAND_FOOTSTEPS, 0.5 );
			this.currentFrame = 0;
			this.setAnimationTimes( [ START_LOOP ], [ START_LOOP/ FPS ], _loopEnd );
		}
		
		public function startLoopWalk():void
		{
			this.stop();
			if( currentFrame < START_LOOP )
				this.setAnimationTimes( [ START_LOOP ], [ ( START_LOOP - currentFrame ) / FPS ], loopWalk );
			else
				loopWalk();
		}
		
		public function loopWalk():void
		{
			SoundManager.getInstance().stopSound( Sounds.SAND_FOOTSTEPS );
			SoundManager.getInstance().playSound( Sounds.SAND_FOOTSTEPS );
			this.stop();
			this.currentFrame = 1;
			this.setAnimationTimes( [ START_LOOP ], [ START_LOOP/ FPS ], loopWalk );
		}
		
		private function _loopEnd():void
		{
			SoundManager.getInstance().stopSound( Sounds.SAND_FOOTSTEPS );
			onComplete.dispatch();
			this.currentFrame = START_LOOP;
			this.loopFrames( [ numFrames ], [ ( numFrames - START_LOOP ) / FPS ] );
		}
			
		private function updatePosition():void
		{
			x = this.model.xPos;
			y = this.model.yPos;
			this.scaleX = this.model.facingRight ? 1 : -1;
		}
	}
}
