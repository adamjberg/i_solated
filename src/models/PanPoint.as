package models {
	import flash.geom.Point;

	/**
	 * @author Adam
	 */
	public class PanPoint extends Point 
	{
		public static const BASE_PAN_SPEED:Number = 30;
		
		public var xOffset:Number;
		public var yOffset:Number;
		public var endX:Number;
		public var cameraSpeed:Number;
		public var requireMovement:Boolean;
		public var allowPanBack:Boolean;
		
		/**
		 * @param startX/startY point to start pan
		 */
		public function PanPoint( startX : Number, startY : Number, endX:Number, xOffset:Number, yOffset:Number, requireMovement:Boolean = true, cameraSpeed:Number = BASE_PAN_SPEED, allowPanBack:Boolean = true ) 
		{
			super( startX, startY );
			this.endX = endX;
			this.xOffset = xOffset;
			this.yOffset = yOffset;
			this.requireMovement = requireMovement;
			this.allowPanBack = allowPanBack;
			this.cameraSpeed = cameraSpeed;
		}
	}
}
