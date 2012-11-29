package models {
	import flash.geom.Point;

	/**
	 * @author Adam
	 * Point that allows sounds to be panned and faded depending on the distance from
	 */
	public class SoundPoint extends Point 
	{
		public static const PLAY:int = 0;
		public static const STOP:int = 1;
		public static const LOOP_CROSS_FADE:int = 2;
		public static const PAN:int = 3;
		
		public var soundName:String;
		public var maxDistance:Number;
		public var leftX:Number;
		public var rightX:Number;
		public var width:Number;
		public var action:int;
		
		/**
		 * @soundName: name of the sound
		 * @maxDistance: Max distance the sound is audible from, in pixels
		 * @leftX: The leftmost point to start calculating the max distance from
		 * @rightX: opposite of leftX
		 */
		public function SoundPoint(x : Number, y : Number, soundName:String, maxDistance:Number, width:Number = 0, action:int = PAN ) 
		{
			super( x, y );
			this.soundName = soundName;
			this.maxDistance = maxDistance;
			this.leftX = x - width * 0.5;
			this.rightX = x + width * 0.5;
			this.width = width;
			this.action = action;
		}
	}
}
