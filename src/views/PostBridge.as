package views {
	import controllers.SoundManager;

	import core.Sounds;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class PostBridge extends Animation 
	{
		public var onBridgeHit:Signal = new Signal();
		
		private const FPS:Number = 10;
		private const BRIDGE_PIECE_FALL_END:Number = 23;
		private const BRIDGE_BREAK_START:Number = 24;
		private const BRIDGE_HIT:Number = 40;
		private const START_LOOP:Number = 128;
		private const END_LOOP:Number = 131;
		
		public function PostBridge( mc : MovieClip ) 
		{
			super(mc);
		}
		
		override public function play( playTransition:Boolean = false ):void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			SoundManager.getInstance().playSound( Sounds.BRIDGE_BREAK );
			this.stop();
			this.currentFrame = BRIDGE_BREAK_START;
			this.setAnimationTimes( [ BRIDGE_HIT ], [ ( BRIDGE_HIT - currentFrame ) / FPS ], _afterBridgeHit );
		}
		
		public function playFallingPiece():void
		{
			this.currentFrame = 1;
			this.setAnimationTimes( [ BRIDGE_PIECE_FALL_END ], [ ( BRIDGE_PIECE_FALL_END - currentFrame ) / FPS ] );
		}
		
		private function _afterBridgeHit():void
		{
			onBridgeHit.dispatch();
			this.stop();
			this.currentFrame = BRIDGE_HIT;
			this.setAnimationTimes( [ START_LOOP ], [ ( START_LOOP - BRIDGE_HIT ) / FPS ], _loop );
		}
		
		private function _loop():void
		{
			this.stop();
			this.currentFrame = START_LOOP;
			this.loopFrames( [ END_LOOP ], [ ( END_LOOP - START_LOOP ) / FPS ] );
			onComplete.dispatch();
		}
	}
}
