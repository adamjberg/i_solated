package views {
	import controllers.LevelController;
	import controllers.SoundManager;

	import core.Sounds;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	/**
	 * @author Adam
	 */
	public class BeachScene extends Sprite implements IScreen 
	{
		private static const FPS:Number = 10;
		[Embed(source="/../assets/Beacon of Life.swf", symbol="Beach")]
		private static const BEACH_SCENE:Class;
		
		public var onComplete:Signal = new Signal();
		private var endAnimation:Animation;
		private var finalWalk:Animation;
		private var beachScene:Sprite;
		
		private var controller:LevelController;
		
		public function BeachScene() 
		{
			beachScene = new BEACH_SCENE();
		}

		public function update(dt : Number) : void 
		{
		}

		public function load(controller : *) : void
		{
			this.controller = controller;
			_init();
		}
		
		private function _init():void
		{
			SoundManager.getInstance().playSound( Sounds.BEACH_SCENE );
			var end:MovieClip = beachScene.removeChild( beachScene.getChildByName( "end" ) ) as MovieClip;
			var beach:MovieClip = beachScene.removeChild( beachScene.getChildByName( "beachScene" ) ) as MovieClip;
			finalWalk = new Animation( beachScene.removeChild( beachScene.getChildByName( "finalWalk" ) ) as MovieClip );
			
			endAnimation = new Animation( beach );
			
			addChild( end );
			addChild( endAnimation );
			addChild( finalWalk );
			endAnimation.loopFrames( [ endAnimation.numFrames ], [ endAnimation.numFrames / FPS ] );
			finalWalk.stop();
			finalWalk.currentFrame = 1;
			finalWalk.setAnimationTimes( [ finalWalk.numFrames ], [ finalWalk.numFrames / FPS ], _onComplete );
		}

		public function unload() : void 
		{
			this.endAnimation.destroy();
			this.finalWalk.destroy();
			
			this.controller = null;
			this.endAnimation = null;
			this.finalWalk = null;
			this.beachScene = null;
			
		}
		
		private function _onComplete():void
		{
			onComplete.dispatch();
		}
	}
}
