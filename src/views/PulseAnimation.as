package views {
	import controllers.SoundManager;

	import core.Sounds;

	import org.osflash.signals.Signal;

	/**
	 * @author Adam
	 */
	public class PulseAnimation extends Animation 
	{
		private const FPS:int = 10;
		
		[Embed(source='/../assets/ZOOOP.swf', symbol= 'Pulse')]
		private static const PULSE:Class;
		
		private const START_PULSE:int = 4;
		
		public var onPulse:Signal = new Signal();
		
		public function PulseAnimation( type:String ) 
		{
			super( new PULSE() );
			this.type = type;
		}
		
		override public function play( transition:Boolean = false ):void
		{
			currentFrame = 1;
			setAnimationTimes( [ START_PULSE ], [ START_PULSE / FPS ], _startPulse );
		}
		
		private function _startPulse():void
		{
			onPulse.dispatch();
			SoundManager.getInstance().stopSound( Sounds.PULSE );
			SoundManager.getInstance().playSound( Sounds.PULSE );
			setAnimationTimes( [ numFrames ], [ ( numFrames - currentFrame ) / FPS ], onComplete.dispatch );
		}
	}
}
