package views {
	import controllers.SoundManager;

	import core.SoundItem;
	import core.Sounds;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * @author Adam
	 */
	public class Dripping extends Animation
	{
		private const FPS:int = 10;
		
		public function Dripping( mc:MovieClip ) 
		{
			super( mc );
			this.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
		}
		
		private function _addedToStage( e:Event ):void
		{
			this.stop();
			_loop();
			this.removeEventListener( Event.ADDED_TO_STAGE, _addedToStage );
			this.addEventListener( Event.REMOVED_FROM_STAGE, _removedFromStage );
		}
		
		private function _loop():void
		{
			setTimeout( _playDripSound, 500 );
			this.currentFrame = 1;
			this.setAnimationTimes( [ numFrames ], [ numFrames / FPS ], _loop );
		}
		
		private function _playDripSound():void
		{
			var si:SoundItem = SoundManager.getInstance().getSoundItem( Sounds.DRIPPING );
			SoundManager.getInstance().stopSound( Sounds.DRIPPING );
			SoundManager.getInstance().playSound( Sounds.DRIPPING, si.baseVolume );
		}
		
		private function _removedFromStage( e:Event ):void
		{
			this.removeEventListener( Event.REMOVED_FROM_STAGE, _removedFromStage );
			this.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
			this.stop();
			SoundManager.getInstance().stopSound( Sounds.DRIPPING );	
		}
	}
}
