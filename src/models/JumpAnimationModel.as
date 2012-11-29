package models {
	/**
	 * @author Adam
	 */
	public class JumpAnimationModel 
	{
		public var name:String;
		
		public var timeTilStart:Number;
		public var timeTilPeak:Number;
		public var timeTilLand:Number;
		
		public var startJump:int;
		public var startFall:int;
		public var startLand:int;
		
		public function JumpAnimationModel( startJump:int, startFall:int, startLand:int )
		{
			this.startJump = startJump;
			this.startFall = startFall;
			this.startLand = startLand;
		}
	}
}
