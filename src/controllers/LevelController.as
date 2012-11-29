package controllers {
	import core.Config;

	import models.ForegroundModel;
	import models.PlayerModel;
	import models.PulseModel;

	import views.PlayerAnimations;

	import org.osflash.signals.Signal;

	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	/**
	 * @author Adam
	 */
	public class LevelController 
	{
		private static const MIN_CLICK_DISTANCE:int = 30;
		
		public var onAcceptedClick:Signal = new Signal();
		public var onPulse:Signal = new Signal();
		
		private var stage:Stage;
		
		public var playerModel:PlayerModel;
		public var pulseModel:PulseModel;
		public var foregroundModel:ForegroundModel;
		
		public var cameraController:CameraController;
		public var foregroundController:ForegroundController;
		public var playerController:PlayerController;
		public var pulseController:PulseController;
		public var soundController:SoundEffectController;
		public var tutorialController:TutorialController;
		

		// Both of these are used for creating the maps collision points
		private var text:String = '';
		private var allowNewPoints:Boolean = false;
		private var pointType:String;
		private var animationRequired:String;
		private var allowBackwardsMovement:Boolean = true;
		
		public function set currentStage( c:int ):void
		{
			destroy();
			init( c );
		}
		
		public function LevelController( stage:Stage )
		{			
			this.stage = stage;
		}
		
		public function destroy():void
		{
			this.stage.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			this.stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDown );
			if( this.tutorialController )
				this.tutorialController.destroy();
			if( this.cameraController )
				this.cameraController.destroy();
			if( this.foregroundController )
				this.foregroundController.destroy();
			if( playerController )
				this.playerController.destroy();
			if( this.soundController )
				this.soundController.destroy();
			if( pulseController )
				pulseController.destroy();	
			
			if( onAcceptedClick )
				onAcceptedClick.removeAll();
			
			if( onPulse )
				onPulse.removeAll();
			
			this.cameraController = null;
			this.foregroundController = null;
			this.playerController = null;
			this.pulseController = null;
			this.soundController = null;
			this.tutorialController = null;
			this.playerModel = null;
			this.pulseModel = null;
			this.foregroundModel = null;
		}
		
		public function init( currentStage:int ):void
		{
			if( currentStage > 8 )
				return;
			if( currentStage == 6 || currentStage == 8 )
				return;
			this.pulseController = new PulseController();
			this.pulseModel = pulseController.pulseModel;
			
			foregroundController = new ForegroundController();
			foregroundController.currentStage = currentStage;
			this.foregroundModel = foregroundController.foregroundModel;
		
			if( foregroundModel )
			{
				this.stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
				this.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
				playerController = new PlayerController( foregroundModel.actionPoints[ 0 ] );
				playerModel = playerController.playerModel;
				cameraController = new CameraController( stage, playerController, foregroundController );
			
				playerController.onBranchPointReached.add( foregroundController.branchPointReached );
				
				// Only create this controller is tutorial points exist
				if( foregroundModel.tutorialPoints )
				{
					this.tutorialController = new TutorialController( foregroundModel.tutorialPoints );
					this.tutorialController.onShowTutorial.add( function( name:String ):void{ playerController.stop(); } );
				}
				
				if( this.foregroundModel.soundPoints )
				{
					soundController = new SoundEffectController( foregroundModel.soundPoints, foregroundModel.soundRects );
				}
			}
		}
		
		public function update( dt:Number ):void
		{
			playerController.update( dt );
			cameraController.update( dt );
			soundController.checkForSound( -foregroundModel.x, playerModel.relativeYPos );
			if( tutorialController )
				this.tutorialController.checkForTutorial( playerModel.relativeXPos );
		}
		
		public function movePlayerTo( point:Point, onComplete:Function = null ):void
		{
			this.playerController.moveThroughPoints( this.foregroundController.getPath( new Point( this.playerModel.relativeXPos, this.playerModel.relativeYPos ), point ), onComplete ) 
		}
		
		public function disableMovement():void
		{
			this.stage.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		}
		
		public function enableMovement():void
		{
			this.stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		}
		
		public function pulse():void
		{
			this.pulseController.pulse( this.playerModel.xPos, this.playerModel.yPos - 150, this.playerModel.relativeXPos, this.playerModel.relativeYPos - 150, Math.max( Math.abs( this.playerModel.xPos - this.stage.stageWidth ), this.playerModel.xPos ) );
		}
		
		public function disableBackwardsMovement():void
		{
			this.allowBackwardsMovement = false;
		}
		
		public function enableBackwardsMovement():void
		{
			this.allowBackwardsMovement = true;
		}
		
		private function mouseDown( e:MouseEvent ):void
		{
			if( Config.DEBUG_MODE && allowNewPoints )
			{
				if( pointType )
					text += ' new ' + pointType + '( ' + int( e.stageX - foregroundModel.x ) + ', ' + int( e.stageY - foregroundModel.y ) + ', ' + animationRequired + ' ),';
				else
					text += ' new Point( ' + int( e.stageX - foregroundModel.x ) + ', ' + int( e.stageY - foregroundModel.y )+ ' ),';
				trace( text );
			}
			if( playerModel.allowMovement && ( e.stageX - foregroundModel.x >= playerModel.relativeXPos + MIN_CLICK_DISTANCE || e.stageX - foregroundModel.x <= playerModel.relativeXPos - MIN_CLICK_DISTANCE ) )
			{
				if( allowBackwardsMovement )
				{
					onAcceptedClick.dispatch();
					playerController.moveThroughPoints( foregroundController.getPath( new Point( playerModel.relativeXPos, playerModel.relativeYPos ), new Point( e.stageX - foregroundModel.x, e.stageY - foregroundModel.y ) ) );
				}
				else if( e.stageX - foregroundModel.x >= playerModel.relativeXPos + MIN_CLICK_DISTANCE )
				{
					onAcceptedClick.dispatch();
					playerController.moveThroughPoints( foregroundController.getPath( new Point( playerModel.relativeXPos, playerModel.relativeYPos ), new Point( e.stageX - foregroundModel.x, e.stageY ) ) );
				}
			}
		}
		
		private function keyDown( e:KeyboardEvent ):void
		{
			var keyCode:uint = e.keyCode;
			
			// REAL KEYBOARD CONTROLS
			if( keyCode == Keyboard.SPACE && playerModel.allowPulse )
			{
				onPulse.dispatch();
				playerController.pulse();
			}
			
			// ONLY FOR DEBUGGING!!!
			if( keyCode == Keyboard.S )
			{
				pointType = 'JumpPoint';
				animationRequired = 'PlayerAnimations.SIDE_JUMP';
			}
			else if( keyCode == Keyboard.D )
			{
				pointType = 'JumpPoint';
				animationRequired = 'PlayerAnimations.JUMP_DOWN_SMALL';
			}
			else if( keyCode == Keyboard.J )
			{
				pointType = 'JumpPoint';
				animationRequired = 'PlayerAnimations.JUMP_UP';
			}
			else if( keyCode == Keyboard.SPACE )
			{
				pointType = 'StopPoint';
				animationRequired = 'PlayerAnimations.STANDING';
			}
			else if( keyCode == Keyboard.ESCAPE )
			{
				pointType = null;
				animationRequired = null;
			}
			else if( keyCode == Keyboard.B )
			{
				pointType = 'BranchPoint';
				animationRequired = '';
			}
			else if( keyCode == Keyboard.E )
				allowNewPoints = !allowNewPoints;
			else if( keyCode == Keyboard.P )
				playerModel.animation = PlayerAnimations.BUTTON_PRESS;
		}
	}
}