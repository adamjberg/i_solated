package views {

	/**
	 * @author Adam
	 */
	
	public class TutorialMouse extends Animation 
	{		
		[Embed( source='/../assets/Mouse + Space.swf', symbol='Mouse')]
		private static const MOUSE:Class;
		
		public function TutorialMouse()
		{
			this.scaleX = this.scaleY = 0.5;
			super( new MOUSE() );
			this.loopFrames( [ numFrames ], [ 1 ] );
		}
	}
}
