package models {

	/**
	 * @author Adam
	 */
	public class StopPoint extends ActionPoint 
	{
		public var direction:int;
		
		public function StopPoint(x : Number, y : Number, animationRequired : String, direction:int = Directions.LEFT ) 
		{
			super(x, y, animationRequired);
			this.direction = direction;
		}
	}
}
