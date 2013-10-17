package views {
	import controllers.SoundManager;

	import core.Sounds;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class TreeBreak extends Animation 
	{
		private const FPS:int = 10;
		
		
		public function TreeBreak( animation:MovieClip ) 
		{
			super( animation );
		}
		
		override public function play( playTransition:Boolean = false ):void
		{
			SoundManager.getInstance().playSound( Sounds.TREE_BREAK );
			this.currentFrame = 2;
			
			// MINUS ONE BECAUSE LAST FRAME has not zoop!!!
			this.setAnimationTimes( [ this.numFrames - 1.01 ], [ ( numFrames - 1.01 ) / FPS ], _onComplete );
		}
		
		private function _onComplete():void
		{
			this.currentFrame = this.numFrames;
			onComplete.dispatch();
		}
	}
}
