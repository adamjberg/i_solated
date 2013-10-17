package models {
	import flash.geom.Point;

	/**
	 * @author Adam
	 */
	public class BranchPoint extends Point 
	{
		public var direction:int;
		public var pathDirection:int;
		public var points:Array;
		public var enabled:Boolean = true;
		public var requiredActions:Array;
		public var allowDisable:Boolean = false;
		public var forcePath:Boolean = false;
		
		/**
		 * @param direction: The direction to exit the branch
		 * @param pathDirection: Whether the branch is above( UP ) or below( DOWN ) the main path 
		 */
		public function BranchPoint(x : Number, y : Number,  points:Array, direction:int = Directions.LEFT, pathDirection:int = Directions.DOWN, forcePath:Boolean = false ) 
		{
			super(x, y);
			this.direction = direction;
			this.pathDirection = pathDirection;
			this.forcePath = forcePath;
			this.points = points;
		}
		
		public function attemptToDisable():void
		{
			if( allowDisable )
				this.enabled = false;
		}
	}
}
