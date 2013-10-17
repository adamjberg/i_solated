package models {
	import org.osflash.signals.Signal;
	/**
	 * @author Adam
	 */
	public class ElevatorPuzzleModel 
	{
		public static const FAR_LEFT:int = 0;
		public static const LEFT:int = 1;
		public static const RIGHT:int = 2;
		
		public var onElevatorChanged:Signal = new Signal();	
		public var onHeightChanged:Signal = new Signal();
		
		public static const LOW:int = 0;
		public static const MID:int = 1;
		public static const HIGH:int = 2;
		
		public var buttons:Array = [ false, false, false ];
		
		private var _elevatatorHeight:Number = LOW;
		public function set elevatorHeight( h:int ):void
		{
			if( h == _elevatatorHeight )
				return;
			this._elevatatorHeight = h;
			this.onHeightChanged.dispatch();
		}
		public function get elevatorHeight():int{ return this._elevatatorHeight; }
		
		public function get allowFullLift():Boolean { return buttons[ LEFT ] && buttons[ RIGHT ] && buttons[ FAR_LEFT ]; }
		public function get allowHalfLift():Boolean { return buttons[ LEFT ] && buttons[ FAR_LEFT ]; }
		public function get allowSpark():Boolean { return buttons[ RIGHT ] != buttons[ FAR_LEFT ]; } 
		
		private var _onElevator:Boolean = false;
		public function set onElevator( o:Boolean ):void { this._onElevator = o; this.onElevatorChanged.dispatch(); }
		public function get onElevator():Boolean { return _onElevator; }
		
		public function ElevatorPuzzleModel()
		{
			
		}
	}
}
