package views {
	import controllers.LevelController;
	import controllers.SoundManager;

	import core.Arrays;
	import core.SoundItem;
	import core.Sounds;

	import models.AnimationPoint;
	import models.Directions;
	import models.Items;
	import models.StageTwoForeground;

	import com.greensock.TweenLite;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	/**
	 * @author Adam
	 */
	public class StageTwo extends Sprite implements IScreen 
	{				
		[Embed(source="/../assets/zoopch2.swf", symbol="Chapter2P1")]
		private static const STAGE_TWO:Class;
		
		private const TREES1_SPEED:Number = -0.8;
		private const TREES2_SPEED:Number = -0.7;
		private const TREES3_SPEED:Number = -0.6;
		
		private const RIGHT_WALL:Number = -4650;
		
		private const X_OFFSET:Number = -2500;
		
		public var onComplete:Signal = new Signal();
				
		private var frontPreForeground:FrontPreForegroundTwo;
		private var frontPostForeground:FrontPostForegroundTwo;
		private var preForeground:PreForegroundTwo;
		private var postForeground:PostForegroundTwo;
		private var background:Background;
		
		private var frontForeground:Foreground;
		private var foreground:Foreground;
		private var player:Player;
		
		private var treeLayerOne:Sprite;
		private var treeLayerTwo:Sprite;
		private var treeLayerThree:Sprite;
		private var trees:Sprite;
		private var trees2:Sprite;
		private var trees3 : Sprite;
		private var trees4:Sprite;
		private var trees5:Sprite;
		private var trees6 : Sprite;
		private var trees7:Sprite;
		private var trees8:Sprite;
		private var trees9:Sprite;
		private var trees10:Sprite;
		private var trees11:Sprite;
		private var trees12:Sprite;
				
		private var _tutorial:Tutorial;
		private var controller : LevelController;
		private var transition : FadeTransition;
		private var pulse : Pulse;
		
		private var musicPlaying:Boolean = true;
		private var numCogsPlaced:Number = 0;
		private var allowBridgeEnableCheck:Boolean = true;
		
		public function update( dt:Number ) : void
		{
			controller.update( dt );
			if( this.controller.playerModel.relativeXPos > 1300 && this.controller.playerModel.relativeYPos < 190 )
			{
				this.postForeground.enableTreeBreak();
			}
			else if( this.controller.playerModel.relativeXPos < 1400 && this.controller.playerModel.relativeYPos > 190 )
			{
				this.postForeground.disableTreeBreak();
			}
			if( this.controller.playerModel.relativeXPos > 5000 && musicPlaying )
			{
				this._endMusic();	
			}
			_checkForBridgeEnable();
			_checkForSpringBoardEnable();
			_checkForControlBoxEnable();
		}

		public function load( controller:* ) : void 
		{
			this.controller = controller;
			
			var stageTwo:Sprite = new STAGE_TWO();
			
			var rawPreForeground:Sprite = stageTwo.removeChild( stageTwo.getChildByName( 'preForeground' ) ) as Sprite;
			var rawPostForeground:Sprite = stageTwo.removeChild( stageTwo.getChildByName( 'postForeground' )  ) as Sprite;
			
			preForeground = new PreForegroundTwo( rawPreForeground );
			postForeground = new PostForegroundTwo( rawPostForeground, this.controller.pulseModel );
			
			treeLayerOne = new Sprite();
			trees = stageTwo.removeChild( stageTwo.getChildByName( 'trees1' ) ) as Sprite;
			treeLayerTwo = new Sprite();
			trees2 = stageTwo.removeChild( stageTwo.getChildByName( 'trees2' )  ) as Sprite;
			treeLayerThree = new Sprite();
			trees3 = stageTwo.removeChild( stageTwo.getChildByName( 'trees3' )  ) as Sprite;
			
			trees4 = new TreeLayerOne();
			trees5 = new TreeLayerTwo();
			trees6 = new TreeLayerThree();
			trees7 = new TreeLayerOne();
			trees8 = new TreeLayerTwo();
			trees9 = new TreeLayerThree();
			trees10 = new TreeLayerOne();
			trees11 = new TreeLayerTwo();
			trees12 = new TreeLayerThree();
			
			treeLayerOne.addChild( trees );
			treeLayerOne.addChild( trees4 );
			treeLayerOne.addChild( trees7 );
			treeLayerOne.addChild( trees10 );
			
			treeLayerTwo.addChild( trees2 );
			treeLayerTwo.addChild( trees5 );
			treeLayerTwo.addChild( trees8 );
			treeLayerTwo.addChild( trees10 );
			
			treeLayerThree.addChild( trees3 );
			treeLayerThree.addChild( trees6 );
			treeLayerThree.addChild( trees9 );
			treeLayerThree.addChild( trees11 );
			
			trees4.x = trees.x + trees.width;
			trees5.x = trees2.x + trees2.width;
			trees6.x = trees3.x + trees3.width;
			trees4.y = trees.y;
			trees5.y = trees2.y;
			trees6.y = trees3.y;
			trees7.x = trees.x + trees.width * 2;
			trees8.x = trees2.x + trees2.width * 2;
			trees9.x = trees3.x + trees3.width * 2;
			trees7.y = trees.y;
			trees8.y = trees2.y;
			trees9.y = trees3.y;
			trees10.x = trees.x + trees.width * 2.75;
			trees11.x = trees2.x + trees2.width * 3;
			trees12.x = trees3.x + trees3.width * 3;
			trees10.y = trees.y;
			trees11.y = trees2.y;
			trees12.y = trees3.y;
						
			background = new Background( 
				[ treeLayerThree, treeLayerTwo, treeLayerOne ],
				[ TREES3_SPEED, TREES2_SPEED, TREES1_SPEED ],
				this.controller.foregroundModel
			);
			addChild( background );

			frontPreForeground = new FrontPreForegroundTwo( rawPreForeground, 0 );
			frontPostForeground = new FrontPostForegroundTwo( rawPostForeground, 0, this.controller.pulseModel );
			frontForeground = new Foreground( frontPreForeground, frontPostForeground, this.controller.foregroundModel );

			foreground = new Foreground( preForeground, postForeground, this.controller.foregroundModel );
			player = new Player( this.controller.playerModel );

			this.controller.playerController.onPlayerLanded.add( this.player.endJump );
				
			pulse = new Pulse( this.controller.pulseModel, this.controller.playerModel );			
			
			addChild( foreground );
			addChild( player );	
			addChild( frontForeground );
			addChild( pulse );
			
			this.controller.cameraController.rightWall = RIGHT_WALL;
			
			_transitionIn();
			TweenLite.delayedCall( 3, _startBGM );
			_addListeners();
		}

		private function _addListeners():void
		{
			this.player.onAnimationComplete.add( this.controller.playerController.changeAnimation );
			this.player.onRockDropped.add( this.postForeground.placeRock );
			this.player.onPulse.add( this.controller.pulse );
			this.player.onAnimationComplete.add( this._animationComplete );
			
			this.postForeground.onTag.add( this.controller.foregroundController.objectTagged );
			this.postForeground.onTag.add( this._objectTagged );
			
			this.frontPostForeground.onTag.add( this._objectTagged );
			this.frontPostForeground.onTag.add( this.controller.foregroundController.objectTagged );
			this.frontPostForeground.onGateOpened.addOnce( ( this.controller.foregroundModel as StageTwoForeground ).enableWalkPastGate );
			
			this.postForeground.onOpenGate.addOnce( this.frontPostForeground.openGate );
			this.postForeground.onControlBoxClicked.add( _attemptPlaceCog );
			
			// Only add once because it should only be picked up once
			this.controller.playerController.onPickUpRock.addOnce( _removeRock );
			
			// Add more than once because there are two cogs
			this.controller.playerController.onPickUpCog.add( _pickUpCog );
			
			// DANGER DANGER! THE FIRST LEAP IS THE ONE I NEED!!!!! If one comes before it....BOOM
			this.controller.playerController.onStartLeap.addOnce( _onFirstLeap );
			
		}

		private function _removeListeners():void
		{
			this.player.onAnimationComplete.remove( this.controller.playerController.changeAnimation );
			this.player.onRockDropped.remove( this.postForeground.placeRock );
			this.player.onPulse.remove( this.controller.pulse );
			this.player.onAnimationComplete.remove( this._animationComplete );
			
			this.postForeground.onTag.remove( this.controller.foregroundController.objectTagged );
			this.postForeground.onTag.remove( this._objectTagged );
			
			this.frontPostForeground.onTag.remove( this._objectTagged );
			this.frontPostForeground.onTag.remove( this.controller.foregroundController.objectTagged );
			
			this.frontPostForeground.onGateOpened.remove( ( this.controller.foregroundModel as StageTwoForeground ).enableWalkPastGate );
			
			this.postForeground.onOpenGate.remove( this.frontPostForeground.openGate );
			this.postForeground.onControlBoxClicked.remove( this._attemptPlaceCog );
			
			this.controller.playerController.onPickUpRock.remove( this._removeRock );
			this.controller.playerController.onPickUpCog.remove( this._pickUpCog );
			this.controller.playerController.onStartLeap.remove( this._onFirstLeap );
		}

		public function unload() : void
		{
			this.preForeground.destroy();
			this.frontPostForeground.destroy();
			this.postForeground.destroy();
			
			this.removeChildren();
			
			treeLayerOne = null;
			treeLayerTwo = null;
			treeLayerThree = null;
			
			trees = null;
			trees2 = null;
			trees3 = null;
			trees4 = null;
			trees5 = null;
			trees6 = null;
			trees7 = null;
			trees8 = null;
			trees9 = null;
			trees10 = null;
			trees11 = null;
			trees12 = null;
			
			preForeground = null;
			postForeground = null;
			background = null;
			
			foreground = null;
			player = null;
			
			_tutorial = null;
			controller = null;
			transition = null;
			
			if( onComplete )
				onComplete.removeAll();
			onComplete = null;
		}
		
		private function _startBGM():void
		{
			const fadeLength:Number = 1.428;
			var si:SoundItem = SoundManager.getInstance().getSoundItem( Sounds.BGM_START_CH2 );
			SoundManager.getInstance().playSound( Sounds.BGM_START_CH2, 1 );
			si.onFadeComplete.addOnce( _startBGMLoop );
			si.fade( 1, ( si.sound.length * 0.001 ) - fadeLength, 0 );
		}
		
		private function _startBGMLoop( si:SoundItem ):void
		{
			const fadeLength:Number = 1.428;
			si.fade( 0, fadeLength, 0, true );
			SoundManager.getInstance().createLoopCrossFade( Sounds.BGM_LOOP_CH2, fadeLength, fadeLength );
		}
		
		private function _endMusic():void
		{
			this.musicPlaying = false;
			const fadeLength:Number = 1.5;
			const fadeDelay:Number = 1.338;
			SoundManager.getInstance().fadeSound( Sounds.BGM_START_CH2, 0, fadeLength, fadeDelay );
			SoundManager.getInstance().fadeSound( Sounds.BGM_LOOP_CH2, 0, fadeLength, fadeDelay );
			SoundManager.getInstance().playSound( Sounds.BGM_END_CH2 );
		}
		
		private function _objectTagged( name:String ):void
		{
			if( name == PostForegroundTwo.ROCK )
			{
				postForeground.enableRockPickUp();
				postForeground.onRockClicked.add( _pickUpRock );
			}
			else if( name == PostForegroundTwo.SPRING_BOARD )
			{
				postForeground.onSpringBoardClicked.add( _placeRockOnSpringBoard );
				this._checkForTreeReplace();
			}
			else if( name == PostForegroundTwo.POST_TREE )
			{
				preForeground.removeTree();
				this._checkForTreeReplace();
			}
			else if( name == FrontPostForegroundTwo.BRIDGE )
			{
				frontPreForeground.removeBridge();
				frontPostForeground.enableBridge();
				frontPostForeground.onBridgeClicked.add( _attemptBridgeBreak );
			}
			else if( name == FrontPostForegroundTwo.WATER_FALL )
			{
				( this.controller.foregroundModel as StageTwoForeground ).enableWaterFallPoints();
				frontPreForeground.removeWaterfall();
				frontPostForeground.tagDripping();
				this._startLogBreakCheck();
			}
			else if( name == FrontPostForegroundTwo.HILL_COG )
			{
				frontPostForeground.enableHillCogPickUp();
				frontPostForeground.onHillCogClicked.add( _pickUpHillCog );
			}
			else if( name == FrontPostForegroundTwo.STUCK_COG )
			{
				frontPostForeground.enableStuckCogPickUp();
				frontPostForeground.onStuckCogClicked.add( _pickUpStuckCog );
			}
			if( name == FrontPostForegroundTwo.WATER_WHEEL || name == FrontPostForegroundTwo.STUCK_COG )
			{
				frontPostForeground.revealWaterWheelAndCog();
				frontPreForeground.removeWaterWheel();
			}
		}
		
		 // TODO: Change these to move player tos
		private function _pickUpRock():void
		{
			var leftPoint:AnimationPoint = new AnimationPoint( 823, 459, PlayerAnimations.PICK_UP, Directions.RIGHT, { item: Items.ROCK } );
			var rightPoint:AnimationPoint = new AnimationPoint( 918, 459, PlayerAnimations.PICK_UP, Directions.LEFT, { item: Items.ROCK } );
			if( controller.playerModel.relativeXPos > rightPoint.x )
				controller.playerController.moveThroughPoints( [ rightPoint ] );
			else if( controller.playerModel.relativeXPos < leftPoint.x )
				controller.playerController.moveThroughPoints( [ leftPoint ] );
			else
			{
				controller.playerController.moveThroughPoints( [ new Point( leftPoint.x - 16, leftPoint.y ), leftPoint ] );
			}
		}
		
		// TODO: Change these to move player tos
		private function _placeRockOnSpringBoard():void
		{
			var point:AnimationPoint = new AnimationPoint( 1428, 454, PlayerAnimations.PUT_DOWN );
			if( controller.playerModel.relativeXPos > point.x )
				controller.playerController.moveThroughPoints( [ new Point( point.x - 10, point.y ), point ] );
			else
				controller.playerController.moveThroughPoints( [ point ] );
		}
		
		private function _pickUpCog():void
		{
			_removeCog();
		}
		
		private function _attemptPlaceCog():void
		{
			if( this.controller.playerModel.item != Items.COG )
				return;
			if( this.numCogsPlaced <= 0 )
				this.controller.movePlayerTo( new AnimationPoint( 3801, 779, PlayerAnimations.PLACE_COG, Directions.RIGHT, { item: Items.COG } ) );
			else
				this.controller.movePlayerTo(  new AnimationPoint( 3763, 781, PlayerAnimations.PLACE_COG, Directions.RIGHT, { item: Items.COG } ) );
		}
		
		// Remove the cogs using the one that is closest to the player.... kind crappy
		private function _removeCog():void
		{
			var distanceToHillCog:Number = Math.abs( 4460 - player.model.relativeXPos );
			var distanceToStuckCog:Number = Math.abs( 4050 - player.model.relativeXPos );
						
			if( distanceToHillCog < distanceToStuckCog )
				frontPostForeground.removeHillCog();
			else
			{
				postForeground.removeStuckCog();
				frontPostForeground.removeStuckCog();
			}
		}
		
		private function _pickUpHillCog():void
		{
			if( this.controller.playerModel.item != Items.NO_ITEM )
				return;
			const distanceToMidCog:Number = 51.5;
			const distanceToBottomCog:Number = 2;
			const midCogX:Number = 4470;
			const bottomCogY:Number = 404;
			
			var leftPoint:AnimationPoint = new AnimationPoint(  midCogX - distanceToMidCog, bottomCogY - distanceToBottomCog, PlayerAnimations.PICK_UP, Directions.RIGHT, { item: Items.COG } );
			var rightPoint:AnimationPoint = new AnimationPoint( midCogX + distanceToMidCog,  bottomCogY - distanceToBottomCog, PlayerAnimations.PICK_UP, Directions.LEFT, { item: Items.COG } );
			if( controller.playerModel.relativeXPos > rightPoint.x )
				controller.playerController.moveThroughPoints( [ rightPoint ] );
			else if( controller.playerModel.relativeXPos < leftPoint.x )
				controller.playerController.moveThroughPoints( [ leftPoint ] );
			else
			{
				controller.playerController.moveThroughPoints( [ new Point( leftPoint.x - 16, leftPoint.y ), leftPoint ] );
			}
		}
		
		private function _pickUpStuckCog():void
		{
			if( this.controller.playerModel.item != Items.NO_ITEM )
				return;
			const distanceToMidCog:Number = 51.5;
			const distanceToBottomCog:Number = 2;
			const midCogX:Number = 4011;
			const bottomCogY:Number = 785;
			
			var leftPoint:AnimationPoint = new AnimationPoint( midCogX - distanceToMidCog, bottomCogY - distanceToBottomCog, PlayerAnimations.PICK_UP, Directions.RIGHT, { item: Items.COG } );
			var rightPoint:AnimationPoint = new AnimationPoint( midCogX + distanceToMidCog,  bottomCogY - distanceToBottomCog, PlayerAnimations.PICK_UP, Directions.LEFT, { item: Items.COG } );
			
			if( controller.playerModel.relativeXPos > rightPoint.x )
				controller.playerController.moveThroughPoints( [ rightPoint ] );
			else if( controller.playerModel.relativeXPos < leftPoint.x )
				controller.playerController.moveThroughPoints( [ leftPoint ] );
			else
			{
				controller.playerController.moveThroughPoints( [ new Point( leftPoint.x - 16, leftPoint.y ), leftPoint ] );
			}
		}
		
		private function _attemptBridgeBreak():void
		{
			this.controller.movePlayerTo( new Point( 4920, 747 ), function():void
			{
				controller.disableMovement();
				allowBridgeEnableCheck = false;
				setTimeout( _startEndSequence, 800 );
			});
		}
		
		private function _startEndSequence():void
		{
			this.frontPostForeground.onBridgeHit.addOnce( _endCameraPan );
			this.frontPostForeground.onBridgeBreakComplete.addOnce( _transitionOut );
			this.frontPostForeground.playBridgeBreak();
			if( contains( player ) )
				this.removeChild( player );
		}
		
		private function _endCameraPan():void
		{
			this.controller.cameraController.panTo( 0, 500, false, 250, 250 );
		}
		
		private function _checkForTreeReplace():void
		{
			if( this.controller.foregroundController.areObjectsTagged( [ PostForegroundTwo.SPRING_BOARD, PostForegroundTwo.POST_TREE ] ) && this.controller.foregroundController.areActionsComplete( [ PlayerAnimations.PUT_DOWN ] ) )
			{
				this.postForeground.replaceTreeBreak();
			}
		}
		
		private function _animationComplete( type:String ):void
		{
			if( type == PlayerAnimations.PUT_DOWN )
			{
				this.controller.foregroundController.actionCompleted( type );
				this.postForeground.placeRock();
				this._checkForTreeReplace();
				this.postForeground.onTreeBreakClicked.addOnce( _playTreeBreak );
			}
			else if( type == PlayerAnimations.PICK_ROCK_UP )
			{
				this.controller.foregroundController.actionCompleted( type );
			}
			else if( type == PlayerAnimations.PLACE_COG )
			{
				this.controller.foregroundController.actionCompleted( type );
				_placeCogInControlBox();
			}
			else if( type == PlayerAnimations.JUMP_DOWN_LARGE )
			{
				( this.controller.foregroundModel as StageTwoForeground ).removeTreePoints();
			}
			else if( type == PlayerAnimations.SIDE_JUMP )
			{
				( this.controller.foregroundModel as StageTwoForeground ).enablePointsAfterWaterFall();
			}
		}
		
		private function _playTreeBreak():void
		{
			this.controller.playerController.moveThroughPoints( [ new Point( 1472, 175 ) ], _actuallyPlayTreeBreak );
			this.controller.disableMovement();
		}
		
		// Rock hits tree after 2 seconds
		private function _actuallyPlayTreeBreak():void
		{
			player.visible = false;
			this.controller.playerModel.allowWalkingSound = false;
			postForeground.onTreeBreakComplete.addOnce( _treeBreakComplete );
			postForeground.playTreeBreak();
			this.controller.cameraController.panTo( 250, 150, false, 80 );
			TweenLite.delayedCall( 2, this.controller.cameraController.panTo, [ -100, 110, false, 10, 3 ] );
			this.controller.playerController.moveThroughPoints( [ new Point( 1950, 317 ) ] );
		}

		private function _treeBreakComplete():void
		{
			this.controller.playerModel.allowWalkingSound = true;
			( this.controller.foregroundModel as StageTwoForeground ).removePointsBeforeTree();
			this.controller.cameraController.panTo( 0, 170, true );
			this.player.visible = true;
			this.controller.enableMovement();
		}
		
		private function _checkForSpringBoardEnable():void
		{
			const distanceFrom:Number = 250;
			const springBoardPos:Point = new Point( 1583, 438 );
			var playerPos:Point = new Point( controller.playerModel.relativeXPos, controller.playerModel.relativeYPos );
			if( this.controller.foregroundController.areObjectsTagged( [ PostForegroundTwo.SPRING_BOARD ] ) 
				&& this.controller.playerModel.item == Items.ROCK 
					&& Point.distance( springBoardPos, playerPos ) < distanceFrom )
			{
				
				this.postForeground.enableSpringBoard();
			}
			else if( Arrays.contains( this.controller.foregroundModel.taggedObjects, [ PostForegroundTwo.SPRING_BOARD ] ) )
			{
				this.postForeground.disableSpringBoard();
			}
		}
		
		private function _checkForControlBoxEnable():void
		{
			const distanceFrom:Number = 200;
			const controlBoxPos:Point = new Point( 3800, 780 );
			var playerPos:Point = new Point( controller.playerModel.relativeXPos, controller.playerModel.relativeYPos );
			if( this.controller.playerModel.item == Items.COG && Point.distance( controlBoxPos, playerPos ) < distanceFrom && ( this.controller.foregroundController.areObjectsTagged( [ PostForegroundTwo.CONTROL_BOX ] ) ) )
			{
				this.postForeground.enableCogPlacement();
			}
			else if( this.controller.foregroundController.areObjectsTagged( [ PostForegroundTwo.CONTROL_BOX ] ) )
			{
				this.postForeground.disableCogPlacement();
			}
		}
		
		private function _checkForBridgeEnable():void
		{
			const distanceFrom:Number = 200;
			const controlBoxPos:Point = new Point( 4925, 780 );
			var playerPos:Point = new Point( controller.playerModel.relativeXPos, controller.playerModel.relativeYPos );
			if( Arrays.contains( this.controller.foregroundModel.taggedObjects, [ FrontPostForegroundTwo.BRIDGE ] ) && allowBridgeEnableCheck )
			{
				if( Point.distance( controlBoxPos, playerPos ) < distanceFrom )
				{
					this.frontPostForeground.enableBridge();
				}
				else
				{
					this.frontPostForeground.disableBridge();
				}
			}
		}
		
		private function _removeRock():void
		{
			postForeground.removeRock();
		}
		
		private function _placeCogInControlBox():void
		{
			numCogsPlaced++;
			postForeground.addCogToControlBox();
		}
		
		private function _startLogBreakCheck():void
		{
			this.controller.playerModel.onPosChanged.add( function():void
			{
				frontPostForeground.checkForLogCrack( controller.playerModel.relativeXPos );
			});
		}
		
		private function _onFirstLeap():void
		{
			this.frontPostForeground.playLogBreak();
		}
		
		private function _transitionIn():void
		{
			const fadeLength:Number = 6;
			transition = new FadeTransition();
			addChild( transition );
			transition.fadeIn( fadeLength, 0, _endTransitionIn );
		}
		
		private function _endTransitionIn():void
		{
			if( transition && contains( transition ) )
			{
				 removeChild( transition );	
			}
		}
		
		private function _transitionOut():void
		{
			const fadeLength:Number = 6;
			transition = new FadeTransition();
			addChild( transition );
			Sounds.transitionOutChapter2( fadeLength, 0 );
			transition.fadeOut( fadeLength, 0, _transitionOutComplete );
		}
		
		private function _transitionOutComplete():void
		{
			this.removeChild( transition );
			this._removeListeners();
			this.onComplete.dispatch();
		}
	}
}