package views {
	import flash.display.MovieClip;
	/**
	 * @author Adam
	 */
	public class CarryWalk extends Animation 
	{	
		private static const FPS:Number = 10;
					
		public function CarryWalk( mc:MovieClip, type:String )
		{
			super( mc );
			this.type = type;
		}
		
		override public function play( playTransition:Boolean = true ):void
		{
			this.stop();
			this.currentFrame = 1;
			this.loopFrames( [ numFrames ], [ ( numFrames ) / FPS ] );
		}
		
		override public function outTransition( playTransition:Boolean = false ):void
		{
			onOutTrantisionComplete.dispatch();
		}
	}
}
