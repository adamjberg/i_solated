package views {
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Adam
	 */
	public class Animation extends Sprite 
	{
		public var onOutTrantisionComplete:Signal = new Signal();
		public var onComplete:Signal = new Signal();
		protected var sequenceComplete:Signal = new Signal();
		
		public var type:String;
		private var timeline:TimelineMax;
		
		public function get numFrames():int { return _movieClip.totalFrames + 1; }
		public function set currentFrame( c:int ):void { _movieClip.gotoAndStop( c ); }
		public function get currentFrame():int { return _movieClip.currentFrame; }
		
		private var _movieClip:MovieClip;
		public function get movieClip():MovieClip { return _movieClip; }
		public function set movieClip( m:MovieClip ):void 
		{ 
			if( _movieClip )
			{
				removeChild( _movieClip );
				_movieClip = null;
			}
			_movieClip = m;
			this._movieClip.gotoAndStop( 0 );
			addChild( _movieClip );
		}
		
		/**
		 * Add as child is set to false used when the animation is just manipulating an existing movie clip
		 */
		public function Animation( mc:MovieClip = null ) 
		{
			if( mc )
			{
				movieClip = mc;
				addChild( _movieClip );
			}
		}
		
		/*
		 * Override to create an in transition
		 */
		public function play( playTransition:Boolean = true ):void
		{
		}
		
		public function destroy():void
		{
			if( timeline )
			{
				timeline.kill();
				timeline = null;
			}
			if( _movieClip && contains( _movieClip ) )
			{
				removeChild( _movieClip );
			}
			_movieClip = null;
		}
		
		/*
		 * Override to create an out transition
		 */
		public function outTransition( playTransition:Boolean = false ):void
		{
			onOutTrantisionComplete.dispatch();
		}
		
		public function setAnimationTimes( frames:Array, times:Array, onComplete:Function = null ):void
		{
			stop();
			timeline = new TimelineMax( { onComplete:onComplete } );
			frames.forEach( function( frame:Number, i:int, a:Array ):void
			{
				timeline.append( TweenLite.to( _movieClip, times[ i ], { frame: frame - 0.5, ease:Linear.easeNone } ) );
			} );
		}
		
		public function loopFrames( frames:Array, times:Array ):void
		{
			stop();
			timeline = new TimelineMax( { onComplete:_loop, repeats:-1 } );
			
			frames.forEach( function( frame:Number, i:int, a:Array ):void
			{
				timeline.append( TweenLite.to( _movieClip, times[ i ], { frame: frame - 0.5, ease:Linear.easeNone } ) );
			} );
		}
		
		private function _loop():void
		{
			timeline.restart();
		}
		
		public function stop():void
		{
			if( timeline )
			{
				timeline.kill();
				timeline = null;
			}
		}
	}
}
