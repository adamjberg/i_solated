package views {
	import controllers.SoundManager;
	import core.Sounds;
	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class PickUp extends Animation 
	{
		private const FPS:int = 10;
		private var soundManager:SoundManager;
				
		public function PickUp( mc:MovieClip, type:String ) 
		{
			super( mc );
			this.type = type;
			soundManager = SoundManager.getInstance();
		}
		
		override public function play( transition:Boolean = false ):void
		{
			if( type == PlayerAnimations.PICK_ROCK_UP )
			{
				soundManager.playSound( Sounds.PICK_UP_ROCK );
			}
			else if( type == PlayerAnimations.PICK_COG_UP )
			{
				soundManager.playSound( Sounds.PICK_UP_COG );
			}
			else if( type == PlayerAnimations.PICK_VALVE_UP )
			{
				soundManager.playSound( Sounds.VALVE_PICKUP );
			}
				
			currentFrame = 1;
			setAnimationTimes( [ numFrames ], [ numFrames / FPS ], onComplete.dispatch );
		}
	}
}
