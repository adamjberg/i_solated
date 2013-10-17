package views {
	import flash.display.MovieClip;
	/**
	 * @author Adam
	 */
	public class CarryStand extends Animation 
	{
		private static const FPS:Number = 10;
		
		private var endTransition:Number;
		private var startLoop:Number;
		private var endLoop:Number = 7.99;
		
		public function CarryStand( mc:MovieClip, type:String, startLoop:Number = 6, endLoop:Number = 7.99 ) 
		{
			super( mc );
			this.type = type;
			this.startLoop = startLoop;
			this.endLoop = endLoop;
			this.endTransition = startLoop - 0.01;
		}
		
		override public function play( playTransition:Boolean = true ):void
		{
			if( playTransition )
			{	
				this.stop();			
				this.currentFrame = 1;
				setAnimationTimes( [ endTransition ], [ endTransition / numFrames ], _startLoop );
			}
			else
				_startLoop();
		}
		
		override public function outTransition( playTransition:Boolean = false ):void
		{
			if( playTransition )
			{
				setAnimationTimes( [ numFrames ], [ numFrames - currentFrame ], onOutTrantisionComplete.dispatch );
			}
			else
				onOutTrantisionComplete.dispatch();
		}
		
		private function _startLoop():void
		{
			this.currentFrame = startLoop;
			this.loopFrames( [ endLoop ], [ ( endLoop - startLoop ) / FPS ] );
		}
	}
}
