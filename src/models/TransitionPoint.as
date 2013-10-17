package models {
	import flash.geom.Point;

	/**
	 * @author Adam
	 */
	public class TransitionPoint extends Point 
	{
		public static const FADE_OUT:String = 'Fade Out';
		
		public var type:String;
		
		public function TransitionPoint(x:Number, y:Number, type:String = FADE_OUT ) 
		{
			super(x, y);
			this.type = type;
		}
	}
}
