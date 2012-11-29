package models {
	import models.ActionPoint;

	/**
	 * @author Adam
	 */
	public class AnimationPoint extends ActionPoint 
	{
		public var direction:int;
		public var params:Object;
		
		public function AnimationPoint( x:Number, y:Number, animationRequired:String, direction:int = Directions.RIGHT, params:Object = null ) 
		{
			super( x, y, animationRequired );
			this.direction = direction;
			this.params = params;
		}
	}
}
