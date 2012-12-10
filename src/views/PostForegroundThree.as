package views {
	import controllers.SoundManager;

	import core.Sounds;
	import core.SpriteManager;

	import models.BucketConveyorModel;
	import models.ElevatorPuzzleModel;
	import models.ForegroundModel;
	import models.PulseModel;

	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Adam
	 */
	public class PostForegroundThree extends PostForeground 
	{
		public var onBucketButtonClicked:Signal = new Signal();
		public var onLiftControlsClicked:Signal = new Signal();
		public var onLeftButtonClicked:Signal = new Signal();
		public var onRightButtonClicked:Signal = new Signal();
		public var onFarLeftButtonClicked:Signal = new Signal();
		public var onElevatorMaxHeight:Signal = new Signal();
		public var onValveSceneComplete:Signal = new Signal();
		public var onValveSceneClicked:Signal = new Signal();
		public var onElevatorMoveComplete:Signal = new Signal();
		public var onElevatorPosChanged:Signal = new Signal();
		public var onLiftClicked:Signal = new Signal();
		public var onValveClicked:Signal = new Signal();
		
		public static const LIFT:String = 'postElevator';
		public static const LIFT_SUPPORT:String = 'postSupport';
		public static const SURF_INTRO:String = 'float';
		public static const LIFT_CONTROLS:String = 'postLiftControls';
		public static const FAR_LEFT_BUTTON:String = 'postFarLeftButton';
		public static const LIFT_BUTTON:String = 'postLiftButton';
		public static const LEFT_BUTTON:String = 'postLeftButton';
		public static const RIGHT_BUTTON:String = 'postRightButton';
		public static const SPARK:String = 'spark';
		public static const BUCKET_BUTTON:String = 'postBucketButton';
		public static const WATER_WEIGHT:String = 'postWaterWeight';
		public static const VALVE:String = 'postWheel';
		public static const VALVE_SCENE:String = 'valveScene';
		public static const MISSING_GROUND:String = 'missingGround';
		
		public function get sparkEnabled():Boolean { return spark.visible; }
		
		private var lift:Sprite;
		private var liftSupport:Sprite;
		private var liftControls:Sprite;
		private var farLeftButton:MovieClip;
		private var leftButton:MovieClip;
		private var rightButton:MovieClip;
		private var liftButton:MovieClip;
		private var bucketButton:MovieClip;
		private var spark:Spark;
		private var bucketConveyor:BucketConveyor;
		private var valve:Sprite;
		private var valveScene:ValveScene;
		private var waterWeight:WaterWeight;
		private var sparkMask:TaggableMask = new TaggableMask();
		
		private var bucketConveyorModel:BucketConveyorModel;
		private var elevatorPuzzleModel:ElevatorPuzzleModel;
		
		public function set liftHeight( l:Number ):void
		{
			liftSupport.scaleY = l;
			lift.y = liftSupport.y - liftSupport.height;
			var rect:Rectangle = lift.getBounds( stage );
			this.onElevatorPosChanged.dispatch( rect.y );
		}
		public function get liftHeight():Number { return liftSupport.scaleY; }
		
		public function PostForegroundThree( foreground:Sprite, foregroundModel:ForegroundModel, elevatorPuzzleModel:ElevatorPuzzleModel, pulseModel:PulseModel, bucketConveyorModel:BucketConveyorModel )
		{
			sparkMask.graphics.beginFill( 0 );
			sparkMask.graphics.drawCircle( 0, 0, 50 );
			super( foreground, foregroundModel, [ SPARK, LIFT, VALVE, MISSING_GROUND ], pulseModel, [ sparkMask ] );
			
			this.bucketConveyorModel = bucketConveyorModel;
			this.bucketConveyorModel.onEmptyBucket.add( _bucketRelease );
			
			bucketConveyor = new BucketConveyor( 55, bucketConveyorModel, true );
			bucketConveyor.y = -330;
			this.foreground.addChild( bucketConveyor );
			
			this.elevatorPuzzleModel = elevatorPuzzleModel;
			this.elevatorPuzzleModel.onHeightChanged.add( _heightChanged );
			spark = new Spark( this.foreground.removeChild( foreground.getChildByName( SPARK ) ) as MovieClip );
			hideSpark();
			
			farLeftButton = foreground.getChildByName( FAR_LEFT_BUTTON ) as MovieClip;
			farLeftButton.stop();
			farLeftButton.buttonMode = true;
			farLeftButton.mouseChildren = false;
			farLeftButton.addEventListener( MouseEvent.MOUSE_DOWN, _farLeftButtonClicked );
			
			leftButton = foreground.getChildByName( LEFT_BUTTON ) as MovieClip;
			leftButton.stop();
			leftButton.mouseChildren = false;
			leftButton.buttonMode = true;
			leftButton.addEventListener( MouseEvent.MOUSE_DOWN, _leftButtonClicked );
			
			rightButton = foreground.getChildByName( RIGHT_BUTTON ) as MovieClip;
			rightButton.stop();
			rightButton.mouseChildren = false;
			rightButton.buttonMode = true;
			rightButton.addEventListener( MouseEvent.MOUSE_DOWN, _rightButtonClicked );
			
			liftButton = foreground.getChildByName( LIFT_BUTTON ) as MovieClip;
			liftButton.buttonMode = true;
			liftButton.stop();
			liftButton.mouseChildren = false;
			liftButton.addEventListener( MouseEvent.MOUSE_DOWN, _liftControlsClicked );
			
			liftControls = foreground.getChildByName( LIFT_CONTROLS ) as Sprite;
			liftControls.buttonMode = true;
			liftControls.mouseChildren = false;
			disableLiftControls();
			liftControls.addEventListener( MouseEvent.MOUSE_DOWN, _liftControlsClicked );
			
			this.bucketButton = foreground.getChildByName( BUCKET_BUTTON ) as MovieClip;
			this.bucketButton.stop();
			this.bucketButton.buttonMode = true;
			this.bucketButton.addEventListener( MouseEvent.MOUSE_DOWN, this._onBucketButtonClicked );
			
			lift = foreground.getChildByName( LIFT ) as Sprite;
			liftSupport = foreground.getChildByName( LIFT_SUPPORT ) as Sprite;
			
			valve = foreground.getChildByName( VALVE ) as Sprite;
			
			valveScene = new ValveScene( foreground.removeChild( foreground.getChildByName( VALVE_SCENE ) ) as MovieClip );
			this.foreground.addChild( valveScene );
			this.valveScene.mouseChildren = false;
			
			this.foreground.addChild( spark );
			
			waterWeight = new WaterWeight( this.foreground.removeChild( this.foreground.getChildByName( WATER_WEIGHT ) ) as MovieClip );
			this.foreground.addChild( waterWeight );
			
			lowerLift();
			
			this.addChild( this.foreground );
		}
		
		override public function destroy():void
		{
			super.destroy();
			onBucketButtonClicked.removeAll();
			onLiftControlsClicked.removeAll();
			onLeftButtonClicked.removeAll();
			onRightButtonClicked.removeAll();
			onFarLeftButtonClicked.removeAll();
			onElevatorMaxHeight.removeAll();
			onValveSceneComplete.removeAll();
			onValveSceneClicked.removeAll();
			onElevatorMoveComplete.removeAll();
			onElevatorPosChanged.removeAll();
			onLiftClicked.removeAll();
			onValveClicked.removeAll();
			
			onBucketButtonClicked = null;
			onLiftControlsClicked = null;
			onLeftButtonClicked = null;
			onRightButtonClicked = null;
			onFarLeftButtonClicked = null;
			onElevatorMaxHeight = null;
			onValveSceneComplete = null;
			onValveSceneClicked = null;
			onElevatorMoveComplete = null;
			onElevatorPosChanged = null;
			onLiftClicked = null;
			onValveClicked = null;
		}
		
		private function _bucketRelease():void
		{
			waterWeight.emptyNextBucket();
		}
		
		public function enableLiftControls():void
		{
			_turnLiftButtonGreen();
			this.liftButton.visible = true;
			liftControls.mouseEnabled = true;
			liftButton.mouseEnabled = true;
		}
		
		public function disableLiftControls():void
		{
			this.liftButton.visible = false;
			liftControls.mouseEnabled = false;
			liftButton.mouseEnabled = false;
		}
		
		public function enableValveScene():void
		{
			this.valveScene.buttonMode = true;
			this.valveScene.addEventListener( MouseEvent.MOUSE_DOWN, _valveSceneClicked );
		}
		
		public function showSpark():void
		{
			spark.visible = true;
		}
		
		public function hideSpark():void
		{
			spark.visible = false;
		}
		public function sparkOn( playerOnLeft:Boolean ):void
		{
			this.rightButton.mouseEnabled = !playerOnLeft;
			this.leftButton.mouseEnabled = !playerOnLeft;
			this.lift.mouseEnabled = playerOnLeft;
		}
		
		public function sparkOff():void
		{
			this.rightButton.mouseEnabled = true;
			this.leftButton.mouseEnabled = true;
			this.lift.mouseEnabled = true;
		}
		
		public function playEndSequence():void
		{
			this.valveScene.play();
			this.valveScene.onComplete.addOnce( this.onValveSceneComplete.dispatch );
		}
		
		public function lowerLift():void
		{
			SoundManager.getInstance().playSound( Sounds.ELEVATOR );
			TweenLite.to( this, 3, { liftHeight: 0.1, ease:Linear.easeNone, onComplete:_elevatorMoveComplete } );
		}
		
		public function raiseLiftHalf():void
		{
			SoundManager.getInstance().playSound( Sounds.ELEVATOR );
			TweenLite.to( this, 3, { liftHeight: 7, ease:Linear.easeNone, onComplete:_elevatorMoveComplete } );
			lift.mouseEnabled = false;
		}
		
		private function _elevatorMoveComplete():void
		{
			SoundManager.getInstance().stopSound( Sounds.ELEVATOR );
			onElevatorMoveComplete.dispatch();
		}
		
		public function raiseLiftFull():void
		{
			SoundManager.getInstance().playSound( Sounds.ELEVATOR );
			TweenLite.to( this, 8, { liftHeight: 44.5, ease:Linear.easeNone, onComplete: function():void
				{
					onElevatorMaxHeight.dispatch();
					_elevatorMoveComplete();
				} } );
			lift.mouseEnabled = false;
			lift.buttonMode = false;
		}
		
		public function liftTagged():void
		{
			var rect:Rectangle = lift.getBounds( this );
			this.foregroundMask.graphics.beginFill( 0 );
			this.foregroundMask.graphics.drawRect( rect.x, rect.y - 700 + liftSupport.height, rect.width, 1200 );
			lift.mouseEnabled = true;
			lift.mouseChildren = false;
			lift.addEventListener( MouseEvent.MOUSE_DOWN, _liftClicked );
			lift.buttonMode = true;
		}
		
		public function enableValve():void
		{
			SpriteManager.enableMouse( valve );
			valve.addEventListener( MouseEvent.MOUSE_DOWN, _valveClicked );
			valve.buttonMode = true;
		}
		
		public function removeValve():void
		{
			if( foreground.contains( valve ) )
				foreground.removeChild( valve );
		}
		
		public function jumpedOnElevator():void
		{
			this.lift.mouseEnabled = false;
			this.farLeftButton.mouseEnabled = false;
			this.leftButton.mouseEnabled = false;
			this.rightButton.mouseEnabled = false;
		}
		
		public function enableLeftButton():void
		{
			this.farLeftButton.mouseEnabled = true;
		}
		
		public function enableLift():void
		{
			this.lift.mouseEnabled = true;
		}
		
		public function enableAllButtons():void
		{
			this.farLeftButton.mouseEnabled = true;
			this.leftButton.mouseEnabled = true;
			this.rightButton.mouseEnabled = true;
		}
		
		private function _heightChanged():void
		{
			if( elevatorPuzzleModel.elevatorHeight == ElevatorPuzzleModel.LOW )
			{
				_turnLiftButtonGreen();
				lowerLift();
			}
			else if( elevatorPuzzleModel.elevatorHeight == ElevatorPuzzleModel.MID )
			{
				_turnLiftButtonRed();
				raiseLiftHalf();
			}
			else if( elevatorPuzzleModel.elevatorHeight == ElevatorPuzzleModel.HIGH )
			{
				_turnLiftButtonRed();
				raiseLiftFull();
			}
		}
		
		private function _turnLiftButtonGreen():void
		{
			this.liftButton.gotoAndStop( 2 );
		}
		
		private function _turnLiftButtonRed():void
		{
			this.liftButton.gotoAndStop( 1 );
		}
		
		private function _valveSceneClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onValveSceneClicked.dispatch();
		}
		
		private function _valveClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onValveClicked.dispatch();
		}
		
		private function _liftClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			onLiftClicked.dispatch();
		}
		
		private function _farLeftButtonClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onFarLeftButtonClicked.dispatch();
		}
		
		private function _leftButtonClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onLeftButtonClicked.dispatch();
		}
		
		private function _rightButtonClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onRightButtonClicked.dispatch();
		}
		
		private function _liftControlsClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onLiftControlsClicked.dispatch();
		}
		
		private function _onBucketButtonClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onBucketButtonClicked.dispatch(); 
		}
		
		public function buttonPressed( name:String ):void
		{
			if( name == PreForegroundThree.FAR_LEFT_BUTTON )
			{
				if( farLeftButton.currentFrame == 1 )
					farLeftButton.nextFrame();
				else
					farLeftButton.prevFrame();
			}
			else if( name == PreForegroundThree.LEFT_BUTTON )
			{
				if( leftButton.currentFrame == 1 )
					leftButton.nextFrame();
				else
					leftButton.prevFrame();
			}
			else if( name == PreForegroundThree.RIGHT_BUTTON )
			{
				if( rightButton.currentFrame == 1 )
					rightButton.nextFrame();
				else
					rightButton.prevFrame();
			}
			else if( name == PreForegroundThree.LIFT_CONTROLS )
			{
				_turnLiftButtonRed();
			}
			else if( name == PreForegroundThree.BUCKET_BUTTON )
			{
				if( bucketButton.currentFrame == 1 )
					bucketButton.nextFrame();
				else
					bucketButton.prevFrame();
			}
		}
		
		public function revealAll():void
		{
			foreground.mask = null;
		}
	}
}