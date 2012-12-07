package views {
	import controllers.BucketConveyorController;
	import controllers.ElevatorPuzzleController;
	import controllers.LevelController;
	import controllers.SoundManager;

	import core.Sounds;

	import models.AnimationPoint;
	import models.Directions;
	import models.Items;
	import models.JumpPoint;
	import models.StageThreeForeground;

	import com.greensock.TweenLite;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * @author Adam
	 */
	public class StageThree extends Sprite implements IScreen 
	{				
		[Embed(source="/../assets/zoopch2p2.swf", symbol="Chapter2P2")]
		private static const STAGE_THREE:Class;
		
		private const Y_OFFSET:Number = 0;
		private const X_OFFSET:Number = 0;
		
		private const FIRST_FLOOR_RIGHT_WALL:Number = -250;
		private const BUCKET_ROOM_RIGHT_WALL:Number = -200;
		private const REVEAL_ROOM_RIGHT_WALL:Number = -950;
		
		public var onComplete:Signal = new Signal();
		
		private var bucketConveyorController:BucketConveyorController;
		private var elevatorPuzzleController:ElevatorPuzzleController;
		
		private var preForeground:PreForegroundThree;
		private var postForeground:PostForegroundThree;
		
		private var foreground:Foreground;
		private var player:Player;
		
		private var controller:LevelController;
		private var transition:FadeTransition;
		
		private var lastButtonClicked:String = '';
		private var pulse:Pulse;
		
		private var revealMusicTriggered:Boolean = false;

		public function update( dt:Number ) : void
		{
			controller.update( dt );
		}

		public function load( controller:* ) : void
		{
			this.controller = controller;
			
			bucketConveyorController = new BucketConveyorController();
			elevatorPuzzleController = new ElevatorPuzzleController( ( ( this.controller.foregroundModel ) as StageThreeForeground ).elevatorPuzzleModel );
			
			var stageThree:Sprite = new STAGE_THREE();
			preForeground = new PreForegroundThree( stageThree.removeChild( stageThree.getChildByName( 'preForeground' ) ) as Sprite, X_OFFSET, Y_OFFSET, elevatorPuzzleController.elevatorPuzzleModel, this.bucketConveyorController.bucketConveyorModel );
			postForeground = new PostForegroundThree( stageThree.removeChild( stageThree.getChildByName( 'postForeground' )  ) as Sprite, elevatorPuzzleController.elevatorPuzzleModel, this.controller.pulseModel, this.bucketConveyorController.bucketConveyorModel );
			
			foreground = new Foreground( preForeground, postForeground, this.controller.foregroundModel );
			player = new Player( this.controller.playerModel );

			elevatorPuzzleController.onEnableLiftControls.add( 
				function():void
				{
					postForeground.enableLiftControls();
					preForeground.enableLiftControls();
				});
			elevatorPuzzleController.onDisableLiftControls.add( 
				function():void
				{
					postForeground.disableLiftControls();
					preForeground.disableLiftControls();
				});
			
			this.controller.pulseModel.onPlay.add( _checkForRevealRoom );
			
			this.controller.disableMovement();
			
			preForeground.onIntroComplete.addOnce( this._start );
			
			addChild( foreground );
			
			pulse = new Pulse( this.controller.pulseModel );
			addChild( pulse );
			
			this.controller.cameraController.rightWall = FIRST_FLOOR_RIGHT_WALL;
			
			_transitionIn();
			_startBGM();
		}

		private function _addListeners():void
		{
			this.preForeground.onLiftControlsClicked.add( this._liftControlsClicked );
			this.preForeground.onRightButtonClicked.add( this._rightButtonClicked );
			this.preForeground.onLeftButtonClicked.add( this._leftButtonClicked );
			this.preForeground.onFarLeftButtonClicked.add( this._farLeftButtonClicked );
			this.preForeground.onBucketButtonClicked.add( this._bucketButtonClicked );
			this.preForeground.onWaterWeightComplete.addOnce( this._waterWeightComplete );
			this.preForeground.onBucketEmptyComplete.add( this.bucketConveyorController.bucketEmptied );
			
			this.postForeground.onBucketButtonClicked.add( this._bucketButtonClicked );
			this.postForeground.onLiftClicked.add( this._attemptJumpUpElevator );
			this.postForeground.onElevatorPosChanged.add( this._movePlayerWithElevator );
			this.postForeground.onElevatorMoveComplete.add( this._elevatorMovementComplete );
			this.postForeground.onLiftControlsClicked.add( this._liftControlsClicked );
			this.postForeground.onRightButtonClicked.add( this._rightButtonClicked );
			this.postForeground.onLeftButtonClicked.add( this._leftButtonClicked );
			this.postForeground.onFarLeftButtonClicked.add( this._farLeftButtonClicked );
			this.postForeground.onFarLeftButtonClicked.add( this._farLeftButtonClicked );
			this.postForeground.onElevatorMaxHeight.addOnce( this._reachedSecondFloor );
					
			this.elevatorPuzzleController.onShowSpark.add( this._enableSpark );
			this.elevatorPuzzleController.onHideSpark.add( this._disableSpark );
			this.elevatorPuzzleController.onPuzzleComplete.addOnce( this._elevatorPuzzleComplete );

			// Add once because there's only one valve
			this.controller.playerController.onPickUpValve.add( this._pickUpValve );
			this.controller.playerController.onPlayerLanded.add( this.player.endJump );
			this.controller.playerController.onStartLeap.add( this._jumpedOffElevator );
			this.controller.playerController.onStartJumpDownSmall.add( this._jumpedOffElevator );
			this.controller.playerController.onPickUpValve.addOnce( this.postForeground.removeValve );
			this.controller.playerController.onStartJumpUp.add( this._startjumpOntoElevator );
			
			this.player.onAnimationComplete.add( this.controller.playerController.changeAnimation );
			this.player.onButtonPressed.add( this._zoopPressedButton );
			this.player.onPulse.add( this.controller.pulse );
			this.player.onAnimationComplete.add( this._animationComplete );

			this.postForeground.onTag.add( this.controller.foregroundController.objectTagged );
			this.postForeground.onTag.add( this._objectTagged );
		}

		private function _removeListeners():void
		{
			this.preForeground.onLiftControlsClicked.remove( this._liftControlsClicked );
			this.preForeground.onRightButtonClicked.remove( this._rightButtonClicked );
			this.preForeground.onLeftButtonClicked.remove( this._leftButtonClicked );
			this.preForeground.onFarLeftButtonClicked.remove( this._farLeftButtonClicked );
			this.preForeground.onBucketButtonClicked.remove( this._bucketButtonClicked );
			this.preForeground.onWaterWeightComplete.remove( this._waterWeightComplete );
			this.preForeground.onBucketEmptyComplete.remove( this.bucketConveyorController.bucketEmptied );
			
			this.postForeground.onLiftClicked.remove( this._attemptJumpUpElevator );
			this.postForeground.onElevatorPosChanged.remove( this._movePlayerWithElevator );
			this.postForeground.onElevatorMoveComplete.remove( this._elevatorMovementComplete );
			this.postForeground.onLiftControlsClicked.remove( this._liftControlsClicked );
			this.postForeground.onRightButtonClicked.remove( this._rightButtonClicked );
			this.postForeground.onLeftButtonClicked.remove( this._leftButtonClicked );
			this.postForeground.onFarLeftButtonClicked.remove( this._farLeftButtonClicked );
			this.postForeground.onFarLeftButtonClicked.remove( this._farLeftButtonClicked );
			this.postForeground.onElevatorMaxHeight.remove( this._reachedSecondFloor );
					
			this.elevatorPuzzleController.onShowSpark.remove( this._enableSpark );
			this.elevatorPuzzleController.onHideSpark.remove( this._disableSpark );
			this.elevatorPuzzleController.onPuzzleComplete.remove( this._elevatorPuzzleComplete );

			this.controller.playerController.onPickUpValve.remove( this._pickUpValve );
			this.controller.playerController.onPlayerLanded.remove( this.player.endJump );
			this.controller.playerController.onStartLeap.remove( this._jumpedOffElevator );
			this.controller.playerController.onStartJumpDownSmall.remove( this._jumpedOffElevator );
			this.controller.playerController.onPickUpValve.remove( this.postForeground.removeValve );
			this.controller.playerController.onStartJumpUp.remove( this._startjumpOntoElevator );
			
			this.player.onAnimationComplete.remove( this.controller.playerController.changeAnimation );
			this.player.onButtonPressed.remove( this._zoopPressedButton );
			this.player.onPulse.remove( this.controller.pulse );
			this.player.onAnimationComplete.remove( this._animationComplete );

			this.postForeground.onTag.remove( this.controller.foregroundController.objectTagged );
			this.postForeground.onTag.remove( this._objectTagged );
		}

		private function _start():void
		{
			this.addChild( player );
			this.controller.enableMovement();
			this._addListeners();
		}

		public function unload() : void
		{
			
			this.preForeground.destroy();
			this.postForeground.destroy();
			
			this.removeChildren();
			
			this.bucketConveyorController.destroy();
			
			this.preForeground = null;
			this.postForeground = null;
			
			this.foreground = null;
			this.player = null;
			
			this.controller = null;
			this.transition = null;
			
			if( onComplete )
				onComplete.removeAll();
			onComplete = null;
		}
		
		private function _startBGM():void
		{
		}
		
		
		private function _attemptBucketRelease():void
		{
			this.bucketConveyorController.attemptBucketRelease();
		}
		
		private function _objectTagged( name:String ):void
		{
			if( name == PostForegroundThree.LIFT )
			{
				this.preForeground.removeLift();
				this.postForeground.liftTagged();
			}
			else if( name == PostForegroundThree.VALVE )
			{
				this.preForeground.removeValve();
				this.postForeground.enableValve();
				this.postForeground.onValveClicked.add( _valveClicked );
			}
		}
		
		private function _movePlayerWithElevator( yPos:Number ):void
		{
			if( elevatorPuzzleController.elevatorPuzzleModel.onElevator )
			{
				this.controller.playerController.playerModel.yPos = yPos + 2;
				this.controller.disableMovement();
			}
		}
		
		private function _elevatorMovementComplete():void
		{
			this.controller.enableMovement();
		}
		
		private function _liftControlsClicked():void
		{
			if( elevatorPuzzleController.elevatorPuzzleModel.onElevator )
			{
				lastButtonClicked = PreForegroundThree.LIFT_CONTROLS;
				this.controller.playerController.moveThroughPoints( [ new AnimationPoint( 400, 497, PlayerAnimations.BUTTON_PRESS, Directions.LEFT ) ] );
			}
		}
		
		private function _leftButtonClicked():void
		{
			lastButtonClicked = PreForegroundThree.LEFT_BUTTON;
			this.controller.playerController.moveThroughPoints( [ new AnimationPoint( 652, 550, PlayerAnimations.BUTTON_PRESS ) ] );
		}
		
		private function _rightButtonClicked():void
		{
			lastButtonClicked = PreForegroundThree.RIGHT_BUTTON;
			this.controller.playerController.moveThroughPoints( [ new AnimationPoint( 726, 550, PlayerAnimations.BUTTON_PRESS ) ] );
		}
		
		private function _farLeftButtonClicked():void
		{
			lastButtonClicked = PreForegroundThree.FAR_LEFT_BUTTON;
			this.controller.playerController.moveThroughPoints( [ new AnimationPoint( 220, 549, PlayerAnimations.BUTTON_PRESS ) ] );
		}
		
		private function _bucketButtonClicked():void
		{
			lastButtonClicked = PreForegroundThree.BUCKET_BUTTON;
			this.controller.playerController.moveThroughPoints( [ new AnimationPoint( 577, -43, PlayerAnimations.BUTTON_PRESS ) ] );
		}
		
		private function _valveClicked():void
		{
			this.controller.playerController.moveThroughPoints( [ new AnimationPoint( 1389, -44, PlayerAnimations.PICK_UP, Directions.RIGHT, { item: Items.VALVE } ) ] );
		}
		
		private function _zoopPressedButton():void
		{
			var random:Number = Math.random();
			if( random < 0.33 )
				SoundManager.getInstance().playSound( Sounds.BUTTON_1 );
			else if( random < 0.66 )
				SoundManager.getInstance().playSound( Sounds.BUTTON_2 );
			else
				SoundManager.getInstance().playSound( Sounds.BUTTON_3 );
			preForeground.buttonPressed( lastButtonClicked );
			postForeground.buttonPressed( lastButtonClicked );
			if( lastButtonClicked == PreForegroundThree.FAR_LEFT_BUTTON )
				this.elevatorPuzzleController.toggleFarLeft();
			else if( lastButtonClicked == PreForegroundThree.LEFT_BUTTON )
				this.elevatorPuzzleController.toggleLeft();
			else if( lastButtonClicked == PreForegroundThree.RIGHT_BUTTON )
				this.elevatorPuzzleController.toggleRight();
			else if( lastButtonClicked == PreForegroundThree.LIFT_CONTROLS )
				this.elevatorPuzzleController.liftButtonPressed();
			else if( lastButtonClicked == PreForegroundThree.BUCKET_BUTTON )
				this._attemptBucketRelease();
		}
		
		private function _attemptJumpUpElevator():void
		{
			var points:Array;
			var leftPoints:Array = [ new JumpPoint( 328, 550, PlayerAnimations.JUMP_UP, Directions.RIGHT ), new Point( 359, 496 ) ];
			var rightPoints:Array = [ new JumpPoint( 487, 549, PlayerAnimations.JUMP_UP, Directions.LEFT ), new Point( 461, 497 ) ];
			if( controller.playerModel.relativeXPos > rightPoints[ 0 ].x )
				points = rightPoints;
			else if( controller.playerModel.relativeXPos < leftPoints[ 0 ].x )
				points = leftPoints;
			else
			{
				controller.playerController.moveThroughPoints( [ new Point( leftPoints[ 0 ].x - 20, leftPoints[ 0 ].y ) ], function():void
				{
					controller.playerController.moveThroughPoints( leftPoints );
				});
				return;
			}
			controller.playerController.moveThroughPoints( points );
		}
		
		/**
		 * This is where we should tell the controller to move the player
		 */
		private function _pickUpValve():void
		{
			this.postForeground.enableValveScene();
			this.postForeground.onValveSceneClicked.add( _attemptPlaceValve );
		}
		
		private function _attemptPlaceValve():void
		{
			var point:Point = new Point( 1495, -42 );
			controller.playerController.moveThroughPoints( [ point ], _startEndSequence );
		}
		
		private function _enableSpark():void
		{
			const sparkX:Number = 600;
			const playerOnLeftOfSpark:Boolean = this.controller.playerModel.relativeXPos < sparkX;
			postForeground.showSpark();
			preForeground.sparkOn( playerOnLeftOfSpark );
			postForeground.sparkOn( playerOnLeftOfSpark );
			( this.controller.foregroundModel as StageThreeForeground ).sparkEnabled( this.controller.playerModel.relativeXPos );
		}
		
		private function _disableSpark():void
		{
			preForeground.sparkOff();
			postForeground.sparkOff();
			postForeground.hideSpark();
			( this.controller.foregroundModel as StageThreeForeground ).sparkDisabled();
		}
		
		private function _startEndSequence():void
		{
			this.controller.disableMovement();
			this.controller.playerModel.item = Items.NO_ITEM;
			this.postForeground.onValveSceneComplete.addOnce( _transitionOut );
			this.postForeground.playEndSequence();
			if( contains( player ) )
				this.removeChild( player );
		}
		
		private function _startjumpOntoElevator():void
		{
			this.controller.cameraController.panTo( 0, -150, false, 0, 0, false );
			this.postForeground.jumpedOnElevator();
			this.preForeground.jumpedOnElevator();
		}
		
		private function _jumpedOffElevator():void
		{
			this.elevatorPuzzleController.jumpedOffElevator();
		}
		
		private function _elevatorPuzzleComplete():void
		{
			this.postForeground.disableLiftControls();
			this.controller.cameraController.enable();
			this.controller.disableMovement();
			this.controller.cameraController.panTo( 0, -700, false, 60, 60 );
		}
		
		private function _reachedSecondFloor():void
		{
			this.controller.cameraController.panTo( 0, -150, false, 80 );
			this.controller.cameraController.rightWall = BUCKET_ROOM_RIGHT_WALL;
			this.controller.cameraController.setDefaultOffsets( 0,  -150 );
			this.elevatorPuzzleController.elevatorPuzzleModel.onElevator = false;
			( this.controller.foregroundModel as StageThreeForeground ).enableSecondFloor();
		}
		
		private function _waterWeightComplete():void
		{
			this.controller.cameraController.rightWall = REVEAL_ROOM_RIGHT_WALL;
			( this.controller.foregroundModel as StageThreeForeground ).enableRevealRoom();
		}
		
		private function _checkForRevealRoom():void
		{
			if( this.controller.playerModel.relativeXPos > 1100 && !revealMusicTriggered )
			{
				revealMusicTriggered = true;
				TweenLite.delayedCall( 1.5, function():void
				{
					SoundManager.getInstance().playSound( Sounds.REVEAL_ROOM_MUSIC );
				});
				this.postForeground.keepMask();
				this.controller.pulseModel.onComplete.addOnce( this.postForeground.removeMask );
			}
		}
		
		private function _animationComplete( type:String ):void
		{
			const sparkX:Number = 600;
			const playerOnLeftOfSpark:Boolean = this.controller.playerModel.relativeXPos < sparkX;
			if( type == PlayerAnimations.JUMP_UP )
			{
				this.elevatorPuzzleController.jumpedOnElevator();
			}
			else if ( type == PlayerAnimations.SIDE_JUMP )
			{
				preForeground.sparkOn( playerOnLeftOfSpark );
				postForeground.sparkOn( playerOnLeftOfSpark );
				( this.controller.foregroundModel as StageThreeForeground ).sparkEnabled( this.controller.playerModel.relativeXPos );
			}
			else if( type == PlayerAnimations.JUMP_DOWN_SMALL )
			{
				if( postForeground.sparkEnabled )
				{
					preForeground.sparkOn( playerOnLeftOfSpark );
					postForeground.sparkOn( playerOnLeftOfSpark );
				}
				else
				{
					postForeground.enableAllButtons();
					preForeground.enableAllButtons();
				}
				postForeground.enableLift();
			}
		}
		
		private function _transitionIn():void
		{
			transition = new FadeTransition();
			addChild( transition );
			transition.fadeIn( 3, 0, _endTransitionIn );
			this.controller.cameraController.panTo( 0, -150, true, 0, 20, false );
		}
		
		private function _endTransitionIn():void
		{
			removeChild( transition );
		}
		
		private function _transitionOut():void
		{
			Sounds.transitionOutFactory( 1, 0 )
			this._removeListeners();;
			this.onComplete.dispatch();
		}
	}
}