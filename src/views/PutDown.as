package views {
	import controllers.SoundManager;

	import core.Sounds;

	import org.osflash.signals.Signal;
	/**
	 * @author Adam
	 */
	public class PutDown extends Animation 
	{
		private const FPS:int = 10;
		
		private static const DROP_ROCK:Number = 5.99;
		private var soundManager:SoundManager;;
		
		public var onRockDropped:Signal = new Signal();
		
		[Embed(source='/../assets/ZOOOP.swf', symbol= 'PutDown')]
		private static const PICK_DOWN:Class;
				
		public function PutDown( type:String ) 
		{
			super( new PICK_DOWN() );
			this.type = type;
			soundManager = SoundManager.getInstance();
		}
		
		override public function play( transition:Boolean = false ):void
		{
			currentFrame = 1;
			setAnimationTimes( [ DROP_ROCK ], [ DROP_ROCK / FPS ], _completeAnimation );
		}
		
		private function _completeAnimation():void
		{
			soundManager.playSound( Sounds.PLACE_ROCK );
			this.onRockDropped.dispatch();
			setAnimationTimes( [ numFrames ], [ (numFrames / currentFrame) / FPS], onComplete.dispatch);
		}
	}
}
