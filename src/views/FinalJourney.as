package views {
	import controllers.LevelController;
	import controllers.SoundManager;

	import core.Sounds;

	import flash.display.MovieClip;

	/**
	 * @author Adam
	 */
	public class FinalJourney extends Animation implements IScreen 
	{
		[Embed(source='/../assets/Final Journey.swf', symbol = 'FinalJourney')]
		private static const FINAL_JOURNEY:Class;
	
		private const FPS:Number = 10;	
		
		private var controller:LevelController;
				
		public function FinalJourney() 
		{
			super( new FINAL_JOURNEY() as MovieClip );
		}

		public function update(dt : Number) : void 
		{
			
		}

		public function load(controller : *) : void 
		{
			this.controller = controller;
			SoundManager.getInstance().playSound( Sounds.TIME_LAPSE );
			this.y = stage.stageHeight * 0.75;
			this.x = this.stage.stageWidth * 0.5;
			this.stop();
			this.currentFrame = 1;
			this.setAnimationTimes( [ numFrames ], [ numFrames / FPS ], _onComplete );
		}

		public function unload() : void 
		{
			this.removeChildren();
			this.destroy();
			
			this.controller = null;
		}
		
		private function _onComplete():void
		{
			Sounds.transitionOutTimeLapse( 0, 0 );
			this.controller.destroy();
			onComplete.dispatch();
		}
	}
}
