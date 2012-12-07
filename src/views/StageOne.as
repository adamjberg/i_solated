package views {
	import controllers.LevelController;
	import controllers.SoundManager;

	import core.Arrays;
	import core.GameState;
	import core.SoundItem;
	import core.Sounds;

	import models.AnimationPoint;
	import models.PanPoint;
	import models.StageOneForeground;
	import models.Surfaces;
	import models.TutorialPoint;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	/**
	 * @author Adam
	 */
	public class StageOne extends Sprite implements IScreen 
	{				
		[Embed(source="/../assets/ZOOPCH1.swf", symbol="Chapter1")]
		private static const STAGE_ONE:Class;
		
		public var onComplete:Signal = new Signal();
		
		private const LEFT_MOUNTAIN_SPEED:Number = -0.29;
		private const RIGHT_MOUNTAIN_SPEED:Number = -0.4;
		private const CITY_SPEED:Number = -0.05;
		private const TREES1_SPEED:Number = -0.85;
		private const TREES2_SPEED:Number = -0.7;
		private const TREES3_SPEED:Number = -0.6;
		
		private var preForeground:Sprite;
		private var postForeground:PostForegroundOne;
		private var background:Background;
		
		private var foreground:Foreground;
		private var player:Player;
		
		private var _tutorial:Tutorial;
		private var controller : LevelController;
		private var city:Sprite;
		private var mountainsBack : Sprite;
		private var mountainsFrontLeft:Sprite;
		private var mountainsFrontRight:Sprite;
		private var trees:Sprite;
		private var trees2:Sprite;
		private var trees3:Sprite;
		private var transition:FadeTransition;
		private var endSlowDownTriggered:Boolean = false;
		private var pulse:Pulse;

		public function update( dt:Number ) : void
		{				
			if( !endSlowDownTriggered && controller.playerModel.relativeXPos > 6800 )
			{
				endSlowDownTriggered = true;
				this.controller.playerController.moveThroughPoints( [ new AnimationPoint( 7096, 463, PlayerAnimations.SLOW_TO_REST ) ] );
				this.controller.disableMovement();
				TweenLite.to( this.controller.playerModel, 5, { speedMultiplier : 0.5 } );
				this._fadeOutMusic();
			}
			if( this.controller.playerModel.relativeXPos > 6619 )
			{
				GameState.surface = Surfaces.GRASS;
			}
			else
			{
				GameState.surface = Surfaces.CLIFF;
			}
			if( this.controller.playerModel.relativeXPos > 5040 && this.controller.playerModel.relativeXPos < 6200 )
			{
				this.controller.playerModel.allowCityGaze = true;
			}
			else
			{
				this.controller.playerModel.allowCityGaze = false;
			}
			controller.update( dt );
		}

		public function load( controller:* ) : void 
		{			
			this.controller = controller;
			
			var stageOne:Sprite = new STAGE_ONE();
			var environment:Sprite = stageOne.removeChild( stageOne.getChildByName( 'prepulseforeground' )  ) as Sprite;
			preForeground = environment.removeChild( environment.getChildByName( 'Preforeground' ) ) as Sprite;
			postForeground = new PostForegroundOne( stageOne.removeChild( stageOne.getChildByName( 'PostForeground' )  ) as Sprite, this.controller.pulseModel );
			
			city = new Sprite();
			city.addChild( environment.removeChild( environment.getChildByName( 'city' ) ) );
			city.getChildAt( 0 ).x += Math.abs( 4200 * CITY_SPEED );
			
			mountainsBack = new Sprite();
			mountainsBack.addChild( environment.removeChild( environment.getChildByName( 'mountains' )  ) );
			
			mountainsFrontLeft = new Sprite();
			mountainsFrontLeft.addChild( environment.removeChild( environment.getChildByName( 'mountainsLeft' )  ) );
			
			mountainsFrontRight = new Sprite();
			mountainsFrontRight.addChild( environment.removeChild( environment.getChildByName( 'mountainsRight' )  ) );
			
			trees = new Sprite();
			trees.addChild( environment.removeChild( environment.getChildByName( 'trees' )  ) );
			
			trees2 = new Sprite();
			trees2.addChild( environment.removeChild( environment.getChildByName( 'trees2' )  ) );
			
			trees3 = new Sprite();
			trees3.addChild( environment.removeChild( environment.getChildByName( 'trees3' )  ) );

			trees.getChildAt( 0 ).x = Math.abs( TREES1_SPEED * ( trees.getChildAt( 0 ).x - 150 ) );
			trees2.getChildAt( 0 ).x = Math.abs( TREES2_SPEED * trees2.getChildAt( 0 ).x );
			trees3.getChildAt( 0 ).x = Math.abs( TREES3_SPEED * trees3.getChildAt( 0 ).x );

			background = new Background( [ mountainsBack, city, mountainsFrontLeft, mountainsFrontRight, trees3, trees2, trees ], [ 0, CITY_SPEED, LEFT_MOUNTAIN_SPEED, RIGHT_MOUNTAIN_SPEED, TREES3_SPEED, TREES2_SPEED, TREES1_SPEED ], this.controller.foregroundModel );
			addChild( background );

			foreground = new Foreground( preForeground, postForeground, this.controller.foregroundModel );
			player = new Player( this.controller.playerModel );
						
			pulse = new Pulse( this.controller.pulseController.pulseModel );
		
			addChild( foreground );
			addChild( player );
			addChild( pulse );
			
			this._startBGM();
			this._addListeners();
		}

		private function _addListeners():void
		{
			this.player.onAnimationComplete.add( this.controller.playerController.changeAnimation );
			this.player.onPulse.add( this.controller.pulse );
			this.player.onAnimationComplete.add( this._animationComplete );
			
			this.controller.playerController.onPlayerLanded.add( this.player.endJump );
			this.controller.playerController.onSlowToRest.addOnce( _startEndTransition );
			
			if( this.controller.tutorialController )
				this.controller.tutorialController.onShowTutorial.add( this._showTutorial );
			this.postForeground.onTag.add( this.controller.foregroundController.objectTagged );
			this.postForeground.onTag.add( this._objectTagged );
		}

		private function _removeListeners():void
		{
			this.player.onAnimationComplete.remove( this.controller.playerController.changeAnimation );
			this.player.onPulse.remove( this.controller.pulse );
			this.player.onAnimationComplete.remove( this._animationComplete );
			
			this.controller.playerController.onPlayerLanded.remove( this.player.endJump );
			this.controller.playerController.onSlowToRest.remove( _startEndTransition );
			
			if( this.controller.tutorialController )
				this.controller.tutorialController.onShowTutorial.remove( this._showTutorial );
			this.postForeground.onTag.remove( this.controller.foregroundController.objectTagged );
			this.postForeground.onTag.remove( this._objectTagged );
		}

		public function unload() : void
		{		
			this.removeChildren();
			
			this.postForeground.destroy();
			
			preForeground = null;
			postForeground = null;
			background = null;
			
			foreground = null;
			player = null;
			
			_tutorial = null;
			controller = null;
			city = null;
			mountainsBack = null;
			mountainsFrontLeft = null;
			mountainsFrontRight = null;
			trees = null;
			trees2 = null;
			trees3 = null;
			transition = null;
			
			// This is only for debugging purposes
			if( onComplete )
				onComplete.removeAll();
			onComplete = null;
		}
		
		private function _startEndTransition():void
		{
			this.controller.cameraController.panToPanPoint( new PanPoint( 7096, 463, 7296, 200, 0, false ) );
		}
		
		private function _transition():void
		{
			transition = new FadeTransition();
			addChild( transition );
			_fadeOut();	
		}
		
		private function _fadeOut():void
		{
			const fadeLength:Number = 6;
			TweenLite.killDelayedCallsTo( _startBGMLoop );
			Sounds.transitionOutChapter1( fadeLength, 0 );
			transition.fadeOut( fadeLength, 0, _endTransition );
		}
		
		private function _endTransition():void
		{
			if( this.controller.tutorialController )
				this.controller.tutorialController.onShowTutorial.remove( this._showTutorial );
			this.removeChild( transition );
			this._removeListeners();
			onComplete.dispatch();
		}
		
		private function _objectTagged( name:String ):void
		{
			if( name == PostForegroundOne.BOULDER )
			{
				( this.controller.foregroundModel as StageOneForeground ).enableBoulderPoints();
			}
			else if( name == PostForegroundOne.FALLEN_LOG )
			{
				( this.controller.foregroundModel as StageOneForeground ).enableFallenLogPoints();
			}
		}
		
		private function _showTutorial( name:String ):void
		{
			if( name == TutorialPoint.PULSE_TUT )
			{
				this.controller.disableMovement();
				this._tutorial = new Tutorial();
				this.player.onPulse.addOnce( function():void
				{
					( controller.foregroundModel as StageOneForeground ).enableFirstBranchPoint();
					controller.enableMovement();
					_removeTutorial();
				});
			}
			else if( name == TutorialPoint.TAG_TUT )
			{
				if( Arrays.contains( this.controller.foregroundModel.taggedObjects, [ PostForegroundOne.BOULDER ] ) )
					return;
				this.controller.disableMovement();
				this._tutorial = new Tutorial();
				this.player.onPulse.add( this._tutorial.showTagControls );
				this.player.onPulseComplete.add( this._tutorial.showPulseControls );
				this.postForeground.onTag.addOnce( function( name:String ):void
				{
					controller.enableMovement();
					_removeTutorial();
				});
			}
			addChild( this._tutorial );
		}
		
		private function _animationComplete( type:String ):void
		{
			if( type == PlayerAnimations.SLOW_TO_REST )
				_transition();
			else if( type == PlayerAnimations.JUMP_DOWN_LARGE )
			{
				( this.controller.foregroundModel as StageOneForeground ).enablePointsAfterCliff();
			}
		}
		
		private function _startBGM():void
		{
			const fadeOutTime:Number = 1.5;
			var si:SoundItem = SoundManager.getInstance().getSoundItem( Sounds.BGM_START_CH1 );
			SoundManager.getInstance().playSound( Sounds.BGM_START_CH1, 0.5 );
			TweenLite.delayedCall( ( si.sound.length * 0.001 ) - fadeOutTime, _startBGMLoop );
			si.fade( 0, fadeOutTime, ( si.sound.length * 0.001 ) - fadeOutTime, true );
		}
		
		private function _startBGMLoop():void
		{
			const fadeTime:Number = 1.5;
			var si:SoundItem = SoundManager.getInstance().getSoundItem( Sounds.BGM_LOOP_CH1 );
			
			SoundManager.getInstance().createLoopCrossFade( Sounds.BGM_LOOP_CH1, fadeTime, fadeTime, si.baseVolume );
		}
		
		private function _fadeOutMusic():void
		{
			const fadeLength:Number = 20;
			SoundManager.getInstance().fadeSound( Sounds.BGM_START_CH1, 0, fadeLength );
			SoundManager.getInstance().fadeSound( Sounds.BGM_LOOP_CH1, 0, fadeLength );
		}
		
		private function _removeTutorial():void
		{
			if( this._tutorial && this.contains( this._tutorial ) )
			{
				this.player.onPulse.remove( this._tutorial.showTagControls );
				removeChild( this._tutorial );
				this._tutorial = null;
			}
		}
	}
}