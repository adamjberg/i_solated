package views {
	import org.osflash.signals.Signal;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class PostControlBox extends Animation 
	{
		private static const NUM_COGS_TO_ADD:int = 2;
		private static const FRAMES_PER_COG:int = 5;
		
		public var onFunctional:Signal = new Signal();
		
		private const FPS:Number = 10;
		private var addedCogs:int = 0;

		private var started:Boolean = false;
	
		public function PostControlBox (mc : MovieClip ) 
		{
			super(mc);
		}
		
		public function startFirstCog():void
		{
			var nextStart:Number = ( ( int( this.currentFrame / ( FRAMES_PER_COG + 1 ) ) ) * FRAMES_PER_COG ) + 1;
			started = true;
			this.loop( nextStart, nextStart + FRAMES_PER_COG );
		}
		
		// crappy +1s are because the end frame is actually FRAMES_PER_COG + 1
		public function addNextCog():void
		{
			var nextStart:Number = ( ( int( this.currentFrame / ( FRAMES_PER_COG + 1 ) ) + 1 ) * FRAMES_PER_COG ) + 1;
			addedCogs++;
			if( addedCogs >= NUM_COGS_TO_ADD )
				onFunctional.dispatch();
			if( started )
			{
				this.loop( nextStart, nextStart + FRAMES_PER_COG );
			}
			else
			{
				this.currentFrame = nextStart;
			}
		}
		
		private function loop( start:Number, end:Number ):void
		{
			this.stop();
			this.currentFrame = start;
			this.loopFrames( [ end - 0.01 ], [ ( end - start ) / FPS ] );
		}
	}
}
