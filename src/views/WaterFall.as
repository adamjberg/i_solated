package views {
	import controllers.SoundManager;
	import core.SoundItem;
	import core.Sounds;
	import com.greensock.TweenLite;
	import org.osflash.signals.Signal;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author Adam
	 */
	public class WaterFall extends Animation 
	{
		private static const WATER_FALL_FADE_IN_TIME:Number = 0.5;
		private static const WATER_FALL_FADE_OUT_TIME:Number = 0.5;
		private static const LOG_BREAK_FADE_OUT_TIME:Number = 3;
		private static const WATER_VOLUME:Number = 0.1;
		private static const RIVER_VOLUME:Number = 0.1;
		
		public var onGateOpened:Signal = new Signal();
		
		private static const FPS:Number = 10;
		private const START_POST:Number = 4;
		private const END_POST:Number = 19.99;
		private const END_LOG_BREAK:Number = 7;
		private const END_WATERFALL_LOOP:Number = 3.99;
		private const START_POST_LOOP:Number = 22;
		private const END_POST_LOOP:Number = 24.99;
		private const START_OPEN_GATE:Number = 25;
		private const END_LOOP_START:Number = 43;
		
		public function WaterFall( waterFallClip:MovieClip, post:Boolean = false ) 
		{
			super( waterFallClip );
			if( post )
			{
				this.currentFrame = START_POST;
			}
			else
			{
				_loopWaterfallSound();
				loopWaterFall();
			}
			this.addEventListener( Event.REMOVED_FROM_STAGE, _removedFromStage );
		}
		
		public function loopWaterFall( firstLoop:Boolean = true ):void
		{
			if( firstLoop )
			{
				this.currentFrame = 1;
				this.loopFrames( [ END_WATERFALL_LOOP ], [ ( END_WATERFALL_LOOP - this.currentFrame ) / FPS ] );
			}
			else
			{
				this.currentFrame = START_POST_LOOP;
				this.loopFrames( [ END_POST_LOOP ], [ ( END_POST_LOOP - START_POST_LOOP ) / FPS ] );
			}
			SoundManager.getInstance().createLoopCrossFade( Sounds.RIVER, .4, .4, RIVER_VOLUME );
		}
		
		public function nextCrack():void
		{
			if( this.currentFrame == START_POST )
			{
				SoundManager.getInstance().playSound( Sounds.CRACK_ONE );
			}
			else if( this.currentFrame == START_POST + 1 )
			{
				SoundManager.getInstance().playSound( Sounds.CRACK_TWO );
			}
			this.currentFrame = this.currentFrame + 1;
		}
		
		public function startWaterFall():void
		{
			var si:SoundItem = SoundManager.getInstance().getSoundItem( Sounds.LOG_BREAK );
			si.play( 0, 0, 0.6 );
			si.fade( 0, LOG_BREAK_FADE_OUT_TIME, si.sound.length * 0.001 - LOG_BREAK_FADE_OUT_TIME );
			SoundManager.getInstance().playSound( Sounds.LOG_BREAK, 0.4 );
			TweenLite.delayedCall( ( si.sound.length * 0.001 ) - WATER_FALL_FADE_IN_TIME * 2, _loopWaterfallSound );
			this.setAnimationTimes( [ END_POST ], [ ( END_POST - this.currentFrame ) / FPS ], function():void
			{
				onComplete.dispatch();
				loopWaterFall( false );
			});
		}
		
		public function openGate():void
		{
			SoundManager.getInstance().playSound( Sounds.GATE_LIFTING );
			this.stop();
			this.currentFrame = START_OPEN_GATE;
			this.setAnimationTimes( [ END_LOOP_START ], [ ( END_LOOP_START - START_OPEN_GATE ) / FPS ], _startEndLoop );
		}
		
		private function _startEndLoop():void
		{
			SoundManager.getInstance().stopSound( Sounds.GATE_LIFTING );
			onGateOpened.dispatch();
			this.stop();
			this.currentFrame = END_LOOP_START;
			this.loopFrames( [ numFrames ], [ ( numFrames - END_LOOP_START ) / FPS ] );
		}
		
		private function _loopWaterfallSound( si:SoundItem = null ):void
		{
			SoundManager.getInstance().createLoopCrossFade( Sounds.WATER_FALL, WATER_FALL_FADE_IN_TIME, WATER_FALL_FADE_OUT_TIME, WATER_VOLUME );
		}
		
		private function _removedFromStage( e:Event ):void
		{
			SoundManager.getInstance().stopSound( Sounds.RIVER );
			SoundManager.getInstance().stopSound( Sounds.WATER_FALL );
		}
	}
}
