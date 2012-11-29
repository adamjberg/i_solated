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
		private const BRIDGE_HIT:Number = 18;
		private const START_LOOP:Number = 100;
		private const END_LOOP:Number = 107.99;
		
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
			this.currentFrame = 2;
			this.setAnimationTimes( [ BRIDGE_HIT ], [ ( BRIDGE_HIT - currentFrame ) / FPS ], _afterBridgeHit );
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
