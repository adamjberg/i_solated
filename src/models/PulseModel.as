package models {
	import org.osflash.signals.Signal;
	/**
	 * @author Adam
	 */
	public class PulseModel 
	{
		public static const SPACE_BETW:int = 200;
		public static const START_RADIUS:Number = 0;
		public static const SPEED:Number = 0.005;
		
		public var onPlay:Signal = new Signal();
		public var onComplete:Signal = new Signal();
		public var onRadiusChanged:Signal = new Signal();
		
		public var centerX:int = 0;
		public var centerY:int = 0;
		public var playing:Boolean = false;
				
		private var _radius:Number = 0;
		public function get radius():Number { return _radius; }
		public function set radius( r:Number ):void { _radius = r; this.onRadiusChanged.dispatch( _radius ); }
		
		public function PulseModel():void
		{
		}
	}
}
