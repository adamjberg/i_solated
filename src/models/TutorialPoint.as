package models {
	import flash.geom.Point;

	/**
	 * @author Adam
	 */
	public class TutorialPoint extends Point 
	{
		public static const PULSE_TUT:String = 'pulseTutorial';
		public static const TAG_TUT:String = 'tagTutorial';
		
		public var name:String;
		
		public function TutorialPoint(x : Number, y : Number, name:String ) 
		{
			super(x, y);
			this.name = name;
		}
	}
}
