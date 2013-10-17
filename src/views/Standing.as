package views {
	/**
	 * @author Adam
	 */
	public class Standing extends Animation 
	{
		[Embed(source="/../assets/ZOOOP.swf", symbol="Stand")]
		private static const STANDING:Class;
		
		public function Standing( type:String ) 
		{
			super( new STANDING() );
			this.type = type;
		}
		
		override public function play( playTransition:Boolean = true ):void
		{
			if( playTransition )
			{
				this.stop();			
				this.currentFrame = 5;
				setAnimationTimes( [ 3 ], [ 0.17 ], _startLoop );
			}
			else
				_startLoop();
		}
		
		override public function outTransition( playTransition:Boolean = false ):void
		{
			this.stop();
			if( playTransition )
			{
				this.currentFrame = 3;
				setAnimationTimes( [ 5 ], [ .17 ], onOutTrantisionComplete.dispatch );
			}
			else
				onOutTrantisionComplete.dispatch();
		}
		
		private function _startLoop():void
		{
			this.stop();
			this.currentFrame = 2;
			this.loopFrames( [ 3.99 ], [ .2 ] );
		}
	}
}
