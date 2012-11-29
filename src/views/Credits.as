package views {
	import controllers.SoundManager;

	import core.SoundItem;
	import core.Sounds;

	import com.greensock.TweenLite;
	/**
	 * @author Adam
	 */
	public class Credits extends Animation implements IScreen
	{
		private const FPS:Number = 10;
		
		[Embed( source="/../assets/Credits.swf", symbol="EndCredits")]
		private static const CREDITS:Class;
		
		public function Credits() 
		{
			super( new CREDITS() );
		}
		
		public function update(dt : Number) : void 
		{
		}
		
		public function load( controller:* ) : void 
		{
			TweenLite.delayedCall( 3, _start );
		}
		
		
		public function unload() : void 
		{
			
		}
		
		
		private function _start():void
		{
			trace( numFrames );
			this.setAnimationTimes( [ numFrames - 10 ], [ ( numFrames - 10 ) / FPS ], _startBGM );
		}
		
		private function _startBGM():void
		{
			SoundManager.getInstance().playSound( Sounds.CREDITS );
		}
	}
}
