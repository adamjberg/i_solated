package views {
	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class Walking extends Animation 
	{	
		private static const FPS:Number = 13;
		
		[Embed(source="/../assets/ZOOOP.swf", symbol="Walk")]
		private const WALKING:Class;
		
		[Embed(source="/../assets/ZOOOP.swf", symbol="Stop")]
		private const STOP:Class;
		
		private var walkingClip:MovieClip;
		private var stopClip:MovieClip;
			
		public function Walking( type:String )
		{
			walkingClip = new WALKING();
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
