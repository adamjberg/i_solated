package views {
	import flash.display.MovieClip;
	import core.AnimatedClip;

	/**
	 * @author Adam
	 */
	public class Running extends Animation 
	{	
		private static const FPS:Number = 10;
		
		[Embed(source="/../assets/ZOOOP.swf", symbol="Run")]
		private const RUNNING:Class;
		
		[Embed(source="/../assets/ZOOOP.swf", symbol="Stop")]
		private const STOP:Class;
		
		private var walkingClip:MovieClip;
		private var stopClip:MovieClip;
			
		public function Running( type:String )
		{
			walkingClip = new RUNNING();
			stopClip = new STOP();
			super();
			this.type = type;
		}
		
		override public function play( playTransition:Boolean = true ):void
		{
			this.stop();
			this.movieClip = walkingClip;	
			this.currentFrame = 1;
			this.loopFrames( [ numFrames ], [ ( numFrames ) / FPS ] );
		}
		
		override public function outTransition( playTransition:Boolean = false ):void
		{
			this.stop();
			if( playTransition )
			{
				this.movieClip = stopClip;
				this.currentFrame = 1;
				this.setAnimationTimes( [ numFrames ], [ numFrames / FPS ], onOutTrantisionComplete.dispatch );
			}
			else
			{
				onOutTrantisionComplete.dispatch();
			}
		}
	}
}
