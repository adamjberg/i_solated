package core {
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Adam
	 */
	public class AnimatedClip extends Sprite 
	{
		// the current frame number
		private var _currentFrame : Number = 1;
		private var lastFrame:int = -1;
		// So this can be tweened
		public function set currentFrame( cf:Number ):void {
			_currentFrame = cf;
			if( int( _currentFrame ) == lastFrame )
				return;
			lastFrame = int( _currentFrame );
			mc.gotoAndStop( int( cf ) );
		}
		public function get currentFrame():Number
		{
			return _currentFrame;
		}
		
		public var numFrames:Number;
		
		private var _mc:MovieClip;
		public function set mc( c:MovieClip ):void {
			if( c != _mc )
			{
				if( _mc )
					removeChild( _mc );
				_mc = c;
				addChild( _mc );
				currentFrame = 1;
				numFrames = _mc.totalFrames + 1;
				if( _manual )
				{
					_mc.stop();
				}
			}
		}
		public function get mc():MovieClip {
			return _mc;
		}
		
		protected var _manual:Boolean = false;
		 
	    /*
	    * Create an AnimatedSprite with the given image data, number of
	    * frames, and frames per second
	    */
	    public function AnimatedClip( mc:*, manual:Boolean )
		{
	        super();
			_manual = manual;
			this.mc = mc;
			if( _manual )
				mc.gotoAndStop( 1 );
	    }
		
		public function nextFrame():void
		{
			mc.nextFrame();	
		}
		
		public function prevFrame():void
		{
			mc.prevFrame();
		}
		
		public function gotoAndStop(frame:int):void
		{
			mc.gotoAndStop( frame );
		}
		
		public function gotoAndPlay( frame:int ):void
		{
			mc.gotoAndPlay( frame );
		}
	}
}