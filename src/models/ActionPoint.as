package models {
	import flash.geom.Point;
	/**
	 * @author Adam
	 */
	public class ActionPoint extends Point
	{
		public static const NO_OBJECT:String = 'No Object';
		/**
		 * This will be the string from PlayerAnimations
		 */
		// The animation to switch to once this point is reached.
		public var playerAnimationRequired:String;
		
		// The object that must be tagged before this point can be used.
		public var requiredTag:String;
		public var enabled:Boolean = false;
		
		public function ActionPoint( x:Number, y:Number, animationRequired:String, requiredTag:String = NO_OBJECT )
		{
			super( x, y );
			playerAnimationRequired = animationRequired;
			this.requiredTag = requiredTag;
			if( this.requiredTag == NO_OBJECT )
				enabled = true;
			else
				enabled = false;
		}
		
		public function enable():void
		{
			this.enabled = true;
		}
	}
}
