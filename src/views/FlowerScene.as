package views {
	import controllers.LevelController;
	import controllers.SoundManager;

	import core.Sounds;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author Adam
	 */
	public class FlowerScene extends Animation implements IScreen 
	{
		[Embed(source='/../assets/Discovery.swf', symbol = 'FlowerScene')]
		private static const FLOWER_SCENE:Class;
		
		private static const PLANT:String = 'plant';
		private static const LIGHT:String = 'lightBeam';
		private static const MOUND:String = 'mound';
		
		private const FPS:Number = 10;	
		private const START_WAIT_LOOP:Number = 60;
		private const END_WAIT_LOOP:Number = 66.99;
		private const REMOVE_FLOWER:Number = 286;
		
		private var scene:Sprite;
		private var controller:LevelController;
		private var pulse:Pulse;
		private var plant:Sprite;
		private var light:Sprite;
		private var foreground:Sprite;
		private var postForeground:PostForeground;
		
		public function FlowerScene() 
		{
			scene = new FLOWER_SCENE();
			addChild( scene );
			var movieClip:MovieClip = scene.removeChild( scene.getChildByName( MOUND ) ) as MovieClip;
			super( movieClip );
			this.stop();
			this.currentFrame = 1;
		}

		public function update(dt : Number) : void 
		{
		}

		public function load(controller : *) : void 
		{
			this.controller = controller;
			this.controller.disableMovement();
			SoundManager.getInstance().playSound( Sounds.FLOWER_SCENE );
			this.stop();
			this.currentFrame = 1;
			this.setAnimationTimes( [ START_WAIT_LOOP ], [ START_WAIT_LOOP / FPS ], this._loopUntilPulse );
			pulse = new Pulse( this.controller.pulseModel );
			plant = scene.getChildByName( PLANT ) as Sprite;
			light = scene.getChildByName( LIGHT ) as Sprite;
			foreground = new Sprite();
			foreground.addChild( plant );
			foreground.addChild( light );

			postForeground = new PostForeground( foreground, this.controller.foregroundModel, [], this.controller.pulseModel );
			foreground.cacheAsBitmap = false;
			this.addChild( postForeground );
			
			addChild( pulse );
		}

		public function unload() : void 
		{
			this.removeChildren();
			
			this.destroy();
			
			controller = null;
			scene = null;
			pulse = null;
		}
		
		// TODO Put this back in with new sound
		private function _loopUntilPulse():void
		{
			_continueAnimation();
			this.controller.pulseController.pulse( 38, 360, 38, 360, 1000 );
			this.postForeground.keepMask();
			this.controller.pulseModel.onComplete.addOnce( this.postForeground.removeMask );
			return;
			//this.stage.addEventListener( KeyboardEvent.KEY_DOWN, _keyPressed );
			this.stop();
			this.currentFrame = START_WAIT_LOOP;
			this.loopFrames( [ END_WAIT_LOOP ], [ ( END_WAIT_LOOP - START_WAIT_LOOP ) / FPS ] );
		}
		
		private function _keyPressed( e:KeyboardEvent ):void
		{
			var keyCode:uint = e.keyCode;
			if( keyCode == Keyboard.SPACE )
			{
				this.stage.removeEventListener( KeyboardEvent.KEY_DOWN, _keyPressed );
				this._continueAnimation();	
			}
		}

		private function _continueAnimation():void
		{
			this.stop();
			this.currentFrame = START_WAIT_LOOP;
			this.setAnimationTimes( [ REMOVE_FLOWER ], [ ( REMOVE_FLOWER - currentFrame ) / FPS ], _finishAnimation );
		}

		private function _finishAnimation():void
		{
			this.stop();
			this.currentFrame = REMOVE_FLOWER;
			this.removeChild( postForeground );
			this.setAnimationTimes( [ numFrames ], [ ( numFrames - currentFrame ) / FPS ], _onComplete );
		}

		private function _onComplete():void
		{
			Sounds.transitionOutFlowerScene( 4, 0 );
			onComplete.dispatch();
		}

	}
}
