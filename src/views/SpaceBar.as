package views {

	/**
	 * @author Adam
	 */
	public class SpaceBar extends Animation 
	{
		private const FPS:Number = 10;
		
		[Embed( source='/../assets/Mouse + Space.swf', symbol='SpaceBar')]
		private static const SPACE_BAR:Class;
		
		public function SpaceBar()
		{
			super( new SPACE_BAR() );
			this.loopFrames( [ numFrames ], [ 1 ] );
		}
	}
}
