package core {
	import events.SoundManagerEvent;

	import com.greensock.TweenLite;

	import org.osflash.signals.Signal;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getQualifiedClassName;
	
	/**
 	 * @author Matt Przybylski [http://www.reintroducing.com]
 	 * @version 1.2
 	 */
	public class SoundItem extends EventDispatcher
	{
//- PRIVATE & PROTECTED VARIABLES -------------------------------------------------------------------------

		private var _pan:Number = 0;
		private var _fadeTween:TweenLite;
		//- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------		
		public var onComplete:Signal = new Signal( SoundItem );
		public var onFadeComplete:Signal = new Signal( SoundItem );		public var name:String;
		public var sound:Sound;		public var channel:SoundChannel;		public var position:int;		public var paused:Boolean;		public var savedVolume:Number;		public var startTime:Number;		public var loops:int;		public var pausedByAll:Boolean;		public var muted:Boolean;
		public var crossFade:Boolean = false;
		
//- CONSTRUCTOR	-------------------------------------------------------------------------------------------
	
		public function SoundItem():void		{			super();			
			init();		}
		
//- PRIVATE & PROTECTED METHODS ---------------------------------------------------------------------------
		
		/**
		 *
		 */
		private function init():void
		{
			channel = new SoundChannel();
		}
		
		/**
		 * 
		 */
		private function fadeComplete($stopOnComplete:Boolean):void
		{
			if ($stopOnComplete) stop();
			
			onFadeComplete.dispatch( this );
			dispatchEvent(new SoundManagerEvent(SoundManagerEvent.SOUND_ITEM_FADE_COMPLETE, this));
		}
		
//- PUBLIC & INTERNAL METHODS -----------------------------------------------------------------------------
	
		/**
		 * Plays the sound item.
		 * 
		 * @param $startTime The time, in seconds, to start the sound at (default: 0)
		 * @param $loops The number of times to loop the sound (default: 0)
		 * @param $volume The volume to play the sound at (default: 1)
		 * @param $resumeTween If the sound volume is faded and while fading happens the sound is stopped, this will resume that fade tween (default: true)
		 * 
		 * @return void
		 */
		public function play($startTime:Number = 0, $loops:int = 0, $volume:Number = 1, $resumeTween:Boolean = false):void		{
			return;
			if (!paused) return;
			baseVolume = $volume;
			savedVolume = volume;
			startTime = $startTime;
			loops = $loops;
			paused = ($startTime == 0) ? true : false;
			
			if (!paused) position = startTime;
			
			channel = sound.play( position, loops, new SoundTransform( baseVolume * distanceMultiplier, this._pan ) );
			channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
			paused = false;
			
			if ($resumeTween && (fadeTween != null)) fadeTween.resume();		}
		
		/**
		 * Pauses the sound item.
		 * 
		 * @param $pauseTween If a fade tween is happening at the moment the sound is paused, the tween will be paused as well (default: true)
		 * 
		 * @return void
		 */
		public function pause($pauseTween:Boolean = true):void
		{
			paused = true;
			position = channel.position;
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
			
			if ($pauseTween && (fadeTween != null)) fadeTween.pause();
		}
		
		/**
		 * Stops the sound item.
		 * 
		 * @return void
		 */
		public function stop():void
		{
			paused = true;
			if( channel )
			{
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);			
				position = channel.position;
			}
			onFadeComplete.removeAll();
			fadeTween = null;
		}
		
		/**
		 * Fades the sound item.
		 * 
		 * @param $volume The volume to fade to (default: 0)
		 * @param $fadeLength The time, in seconds, to fade the sound (default: 1)
		 * @param $stopOnComplete Stops the sound once the fade is completed (default: false)
		 * 
		 * @return void
		 */
		public function fade($volume:Number = 0, $fadeLength:Number = 1, fadeDelay:Number = 0, $stopOnComplete:Boolean = false, ease:Function = null, removeListeners:Boolean = false ):void
		{
			if( fadeTween && removeListeners )
			{
				fadeTween.kill();
				this.onFadeComplete.removeAll();
			}
			fadeTween = TweenLite.to(this, $fadeLength, {baseVolume: $volume, ease: ease, delay: fadeDelay, onComplete: fadeComplete, onCompleteParams: [$stopOnComplete]});
		}
		
		public function pan( pan:Number ):void
		{
			if( !channel )
				return;
			this._pan = pan;
			var curTransform:SoundTransform = this.channel.soundTransform;
			curTransform.pan = pan;
			this.channel.soundTransform = curTransform;
		}
		
		/**
		 * Sets the volume of the sound item.
		 * 
		 * @param $volume The volume, from 0 to 1, to set
		 * 
		 * @return void
		 */
		public function setVolume($volume:Number):void
		{
			if( !channel )
				return;
			var curTransform:SoundTransform = channel.soundTransform;
			curTransform.volume = $volume;
			channel.soundTransform = curTransform;
		}
		
		/**
		 * Clears the sound item for garbage collection.
		 * 
		 * @return void
		 */
		public function destroy():void
		{
			if( channel )
				channel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
			channel = null;
			fadeTween = null;
			TweenLite.killTweensOf( this );
		}
	
		private function _updateVolume():void
		{
			if( !channel )
				return;
			var curTransform:SoundTransform = channel.soundTransform;
			curTransform.volume = _baseVolume * _distanceMultiplier;
			channel.soundTransform = curTransform;
		}
	
//- EVENT HANDLERS ----------------------------------------------------------------------------------------
	
		/**
		 *
		 */
		private function handleSoundComplete($evt:Event):void
		{
			stop();
			onComplete.dispatch( this );
			dispatchEvent(new SoundManagerEvent(SoundManagerEvent.SOUND_ITEM_PLAY_COMPLETE, this));
		}
	
//- GETTERS & SETTERS -------------------------------------------------------------------------------------
	
		private var _baseVolume:Number = 1;
		public function get baseVolume():Number
		{
			return _baseVolume;
		}
		public function set baseVolume( vol:Number ):void
		{
			_baseVolume = vol;
			_updateVolume();
		}
	
		private var _distanceMultiplier:Number = 1;
		public function get distanceMultiplier():Number { return _distanceMultiplier; }
		public function set distanceMultiplier( d:Number ):void { this._distanceMultiplier = d; this._updateVolume(); }
	
		/**
		 *
		 */
		public function get volume():Number
		{
			if( !channel )
				return 0;
		    return channel.soundTransform.volume;
		}
		
		/**
		 *
		 */
		public function set volume($val:Number):void
		{
			setVolume($val);
		}
		
		/**		 *		 */		public function get fadeTween():TweenLite		{		    return _fadeTween;		}				/**		 *		 */		public function set fadeTween($val:TweenLite):void		{			if ($val == null) TweenLite.killTweensOf(this);
						_fadeTween = $val;		}
	
//- HELPERS -----------------------------------------------------------------------------------------------
	
		override public function toString():String
		{
			return getQualifiedClassName(this);
		}
	
//- END CLASS ---------------------------------------------------------------------------------------------
	}
}