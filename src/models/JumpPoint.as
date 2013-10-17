package models {

	/**
	 * @author Adam
	 */
	public class JumpPoint extends ActionPoint 
	{
		public static const JUMP_SPEED:Number = -400;
		
		public var direction:int;
		public var jumpSpeed:int;
	
		public function JumpPoint(x : Number, y : Number, animationRequired : String, direction:int = Directions.RIGHT, jumpSpeed:int = JUMP_SPEED, requiredTag:String = ActionPoint.NO_OBJECT ) 
		{
			super( x, y, animationRequired, requiredTag );
			this.direction = direction;
			this.jumpSpeed = jumpSpeed;
		}
	}
}
