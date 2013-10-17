package views {
	import org.osflash.signals.Signal;

	/**
	 * @author Adam
	 */
	public class ButtonPress extends Animation 
	{
		public var onButtonPressed:Signal = new Signal();
		
		private const FPS:Number = 10;
		private const BUTTON_PRESS_FRAME:Number = 4.5;
		
		[Embed(source="/../assets/ZOOOP.swf", symbol="Press")]
		private static const BUTTON_PRESS:Class;
		
		public function ButtonPress( type:String ) 
		{
			super( new BUTTON_PRESS() );
			this.type = type;
		}
		
		override public function play( playTransition:Boolean = false ):void
		{
			this.stop();
			this.currentFrame = 1;
			this.setAnimationTimes( [ BUTTON_PRESS_FRAME ], [ ( BUTTON_PRESS_FRAME - 1 ) / FPS ], _finishAnimation );
		}
		
		private function _finishAnimation():void
		{
			this.onButtonPressed.dispatch();
			this.setAnimationTimes( [ numFrames ], [ ( numFrames - currentFrame ) / FPS ], onComplete.dispatch );
		}
		
	}
}
