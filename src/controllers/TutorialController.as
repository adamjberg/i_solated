package controllers {
	import org.osflash.signals.Signal;
	/**
	 * @author Adam
	 */
	public class TutorialController 
	{
		public var onShowTutorial:Signal = new Signal( String );
		
		private var tutorialPoints:Array;
		
		public function TutorialController( tutorialPoints:Array )
		{
			this.tutorialPoints = tutorialPoints;
		}
		
		public function destroy():void
		{
			this.onShowTutorial.removeAll();
		}
		
		public function checkForTutorial( playerXPos:Number ):void
		{
			if( tutorialPoints.length <= 0 )
				return;
			if( playerXPos > tutorialPoints[ 0 ].x )
			{
				onShowTutorial.dispatch( tutorialPoints.shift().name );
			}
		}
	}
}
