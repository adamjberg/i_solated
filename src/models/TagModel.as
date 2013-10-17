package models {
	import flash.geom.Rectangle;
	/**
	 * @author Adam
	 */
	public class TagModel 
	{
		public var hitRect:Rectangle;
		public var visibleRadius:int;
		
		public function TagModel( hitRect:Rectangle, radius:int )
		{
			this.hitRect = hitRect;
			visibleRadius = radius;
		}
	}
}
