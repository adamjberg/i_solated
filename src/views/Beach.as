package views {
	import controllers.LevelController;
	import controllers.SoundManager;

	import core.Sounds;

	import com.greensock.TweenLite;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author Adam
	 */
	public class Beach extends Sprite implements IScreen 
	{
		[Embed(source="/../assets/zoopch3.swf", symbol="FRAME5")]
		private const BEACH:Class;
		
		public var onComplete:Signal = new Signal();
		
		private var beach:Sprite;
		private var controller:LevelController;
		private var foreground:Foreground;
		private var background:Background;
		
		private var finalWalk:FinalWalk;
		
		private var beachHill1:Sprite;
		private var beachHill2:Sprite;
		private var clouds : Sprite;
		private var beachFore : Sprite;
		private var endTriggered:Boolean = false;
		
		public function Beach() 
		{
		}

		public function update(dt : Number) : void
		{
			this.controller.update( dt );
			if( this.controller.playerModel.relativeXPos >= 740 && !endTriggered )
			{
				endTriggered = true;
				this.controller.movePlayerTo( new Point( 850, 470 ) );
				TweenLite.delayedCall( 7, _endScene );
				this.finalWalk.startLoopWalk();
				this.controller.disableMovement();
			}
		}

		private function _endScene():void
		{
			this.finalWalk.destroy();
			Sounds.transitionOutFinalJourney( 1, 0 );
			this.onComplete.dispatch();
		}

		public function load(controller : *) : void 
		{
			this.controller = controller;
			this.beach = new BEACH();
			var hillContainer:Sprite = new Sprite;
			
			beachHill1 = beach.removeChild( beach.getChildByName( 'beachHill1' ) ) as Sprite;
			beachHill2 = beach.removeChild( beach.getChildByName( 'beachHill2' ) ) as Sprite;
			
			hillContainer.addChild( beachHill2 );
			hillContainer.addChild( beachHill1 );
			
			beachHill2.x = -5;
			beachHill1.x = -5;
			
			clouds = beach.removeChild( beach.getChildByName( 'clouds' ) ) as Sprite;
			clouds.y = 50;
			clouds.x = 0;
			
			beachFore = beach.removeChild( beach.getChildByName( 'beachFore' ) ) as Sprite;
			beachFore.x = -500;
			beachFore.y += 20;
			
			this.foreground = new Foreground( beachFore, new Sprite(), this.controller.foregroundModel );
			this.background = new Background( [ clouds, hillContainer ], [ -0.3, -0.4 ], this.controller.foregroundModel );
			
			this.controller.playerModel.speedMultiplier = 0.15;
			this.controller.playerModel.allowWalkingSound = false;
			// This is sort of a hack because the playerModel isn't actually being used to change animations
			this.controller.playerModel.animation = PlayerAnimations.WALKING;
			this.controller.disableBackwardsMovement();
			this.controller.onAcceptedClick.add( _takeStep );
			this.finalWalk = new FinalWalk( this.controller.playerModel );
			
			this.controller.enableMovement();
			
			this.addChild( background );
			this.addChild( foreground );
			this.addChild( finalWalk );
			
			_listenForClick();
			this.controller.cameraController.rightWall = 50;
		}

		private function _takeStep():void
		{
			
			this.controller.disableMovement();
			this.finalWalk.onComplete.addOnce( _listenForClick );
			this.finalWalk.play();
		}

		private function _listenForClick():void
		{
			this.controller.enableMovement();
			this.controller.playerController.stopMovement();
		}

		public function unload() : void 
		{
			Sounds.transitionOutFinalJourney( 0.1, 0 );
			SoundManager.getInstance().stopSound( Sounds.SAND_FOOTSTEPS );
		}
	}
}
