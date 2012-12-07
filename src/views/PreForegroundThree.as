package views {
	import models.BucketConveyorModel;
	import models.ElevatorPuzzleModel;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Adam
	 */
	public class PreForegroundThree extends Sprite 
	{
		public var onBucketEmptyComplete:Signal = new Signal();
		public var onWaterWeightComplete:Signal = new Signal();
		public var onIntroComplete:Signal = new Signal();
		public var onLiftControlsClicked:Signal = new Signal();
		public var onLeftButtonClicked:Signal = new Signal();
		public var onRightButtonClicked:Signal = new Signal();
		public var onFarLeftButtonClicked:Signal = new Signal();
		public var onBucketButtonClicked:Signal = new Signal();
		
		public static const LIFT:String = 'preElevator';
		public static const LIFT_SUPPORT:String = 'preSupport';
		public static const SURF_INTRO:String = 'float';
		public static const LIFT_CONTROLS:String = 'preliftControls';
		public static const LIFT_BUTTON:String = 'preLiftButton';
		public static const LEFT_BUTTON:String = 'preLeftButton';
		public static const FAR_LEFT_BUTTON:String = 'preFarLeftButton';
		public static const RIGHT_BUTTON:String = 'preRightButton';
		public static const BUCKET_BUTTON:String = 'preBucketButton';
		public static const WATER_WEIGHT:String = 'preWaterWeight';
		public static const CHUTE:String = 'preChute';
		public static const VALVE:String = 'preWheel';
		
		public var chute:Sprite;
		private var foreground:Sprite;
		private var surfIntro:SurfIntro;
		private var lift:Sprite;
		private var liftSupport:Sprite;
		private var leftButton:MovieClip;
		public var rightButton:MovieClip;
		private var liftControls:Sprite;
		private var liftButton:MovieClip;
		private var bucketButton:MovieClip;
		private var waterWeight:WaterWeight;
		private var bucketConveyor:BucketConveyor;
		private var bucketConveyorModel:BucketConveyorModel;
		
		private var valve : Sprite;
		private var farLeftButton:MovieClip;
		private var elevatorPuzzleModel:ElevatorPuzzleModel;
		
		public function set liftHeight( l:Number ):void
		{
			liftSupport.scaleY = l;
			lift.y = liftSupport.y - liftSupport.height;
		}
			
		public function PreForegroundThree( foreground:Sprite, xOffset:Number, yOffset:Number, elevatorPuzzleModel:ElevatorPuzzleModel, bucketConveyorModel:BucketConveyorModel )
		{
			this.foreground = foreground;
			this.foreground.x += xOffset;
			this.foreground.y += yOffset;
		
			this.bucketConveyorModel = bucketConveyorModel;
			
			this.elevatorPuzzleModel = elevatorPuzzleModel;
			
			chute = this.foreground.getChildByName( CHUTE ) as Sprite;
			
			bucketConveyor = new BucketConveyor( 55, bucketConveyorModel );
			bucketConveyor.y = -330;
			foreground.addChildAt( bucketConveyor, foreground.getChildIndex( chute ) - 1 );
			
			farLeftButton = foreground.getChildByName( FAR_LEFT_BUTTON ) as MovieClip;
			farLeftButton.stop();
			farLeftButton.buttonMode = true;
			farLeftButton.mouseChildren = false;
			
			leftButton = foreground.getChildByName( LEFT_BUTTON ) as MovieClip;
			leftButton.stop();
			leftButton.buttonMode = true;
			leftButton.mouseChildren = false;
			
			rightButton = foreground.getChildByName( RIGHT_BUTTON ) as MovieClip;
			rightButton.stop();
			rightButton.buttonMode = true;
			rightButton.mouseChildren = false;
			
			liftButton = foreground.getChildByName( LIFT_BUTTON ) as MovieClip;
			liftButton.stop();
			hideLiftButton();
			liftButton.mouseChildren = false;
			liftButton.buttonMode = true;
			
			lift = foreground.getChildByName( LIFT ) as Sprite;
			liftSupport = foreground.getChildByName( LIFT_SUPPORT ) as Sprite;
			
			liftHeight = 42.5; 
			
			liftControls = foreground.getChildByName( LIFT_CONTROLS ) as Sprite;
			liftControls.buttonMode = true;
			liftControls.mouseChildren = false;
			disableLiftControls();
			
			valve = foreground.getChildByName( VALVE ) as Sprite;
			
			surfIntro = new SurfIntro( this.foreground.removeChild( foreground.getChildByName( SURF_INTRO ) ) as MovieClip );
			this.foreground.addChild( surfIntro );
			
			this.bucketButton = this.foreground.getChildByName( BUCKET_BUTTON ) as MovieClip;
			this.bucketButton.stop();
			this.bucketButton.buttonMode = true;
			
			waterWeight = new WaterWeight( this.foreground.removeChild( this.foreground.getChildByName( WATER_WEIGHT ) ) as MovieClip );
			
			this.foreground.addChild( waterWeight );
			
			this.addChild( this.foreground );
			this._addListeners();
		}
		
		public function destroy():void
		{
			this._removeListeners();
			
			onBucketEmptyComplete.removeAll();
			onWaterWeightComplete.removeAll();
			onIntroComplete.removeAll();
			onLiftControlsClicked.removeAll();
			onLeftButtonClicked.removeAll();
			onRightButtonClicked.removeAll();
			onFarLeftButtonClicked.removeAll();
			onBucketButtonClicked.removeAll();
			
			onBucketEmptyComplete = null;
			onWaterWeightComplete = null;
			onIntroComplete = null;
			onLiftControlsClicked = null;
			onLeftButtonClicked = null;
			onRightButtonClicked = null;
			onFarLeftButtonClicked = null;
			onBucketButtonClicked = null;
		}
		
		public function sparkOn( playerOnLeft:Boolean ):void
		{
			this.rightButton.mouseEnabled = !playerOnLeft;
			this.leftButton.mouseEnabled = !playerOnLeft;
			this.farLeftButton.mouseEnabled = playerOnLeft;
		}
		
		public function sparkOff():void
		{
			this.rightButton.mouseEnabled = true;
			this.leftButton.mouseEnabled = true;
			this.farLeftButton.mouseEnabled = true;
		}
		
		public function enableLiftControls():void
		{
			this._turnLiftButtonGreen();
			this.liftButton.visible = true;
			liftControls.mouseEnabled = true;
			liftButton.mouseEnabled = true;
		}
		
		public function disableLiftControls():void
		{
			liftButton.visible = false;
			liftControls.mouseEnabled = false;
			liftButton.mouseEnabled = false;
		}
		
		public function removeLift():void
		{
			this.foreground.removeChild( lift );
			this.foreground.removeChild( liftSupport );
		}
		
		public function removeValve():void
		{
			foreground.removeChild( valve );
		}
		
		public function showLiftButton():void
		{
			this.liftButton.visible = true;
		}
		
		public function hideLiftButton():void
		{
			this.liftButton.visible = false;
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
				this._turnLiftButtonRed();
			}
			else if( name == PreForegroundThree.BUCKET_BUTTON )
			{
				if( bucketButton.currentFrame == 1 )
					bucketButton.nextFrame();
				else
					bucketButton.prevFrame();
			}
		}
		
		public function enableLeftButton():void
		{
			this.farLeftButton.mouseEnabled = true;
		}
		
		public function jumpedOnElevator():void
		{
			this.farLeftButton.mouseEnabled = false;
			this.leftButton.mouseEnabled = false;
			this.rightButton.mouseEnabled = false;
		}

		public function enableAllButtons():void
		{
			this.farLeftButton.mouseEnabled = true;
			this.leftButton.mouseEnabled = true;
			this.rightButton.mouseEnabled = true;
		}
		
		private function _bucketRelease():void
		{
			waterWeight.emptyNextBucket( this.onBucketEmptyComplete.dispatch );
		}
		
		private function _heightChanged():void
		{
			if( elevatorPuzzleModel.elevatorHeight == ElevatorPuzzleModel.LOW )
			{
				_turnLiftButtonGreen();
			}
			else if( elevatorPuzzleModel.elevatorHeight == ElevatorPuzzleModel.MID )
			{
				_turnLiftButtonRed();
			}
			else if( elevatorPuzzleModel.elevatorHeight == ElevatorPuzzleModel.HIGH )
			{
				_turnLiftButtonRed();
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
		
		private function _addListeners():void
		{
			this.bucketConveyorModel.onEmptyBucket.add( this._bucketRelease );
			this.elevatorPuzzleModel.onHeightChanged.add( this._heightChanged );
			this.farLeftButton.addEventListener( MouseEvent.MOUSE_DOWN, this._farLeftButtonClicked );
			this.leftButton.addEventListener( MouseEvent.MOUSE_DOWN, this._leftButtonClicked );
			this.rightButton.addEventListener( MouseEvent.MOUSE_DOWN, this._rightButtonClicked );
			this.liftButton.addEventListener( MouseEvent.MOUSE_DOWN, this._liftControlsClicked );
			this.liftControls.addEventListener( MouseEvent.MOUSE_DOWN, this._liftControlsClicked );
			this.bucketButton.addEventListener( MouseEvent.MOUSE_DOWN, this._onBucketButtonClicked );
			this.waterWeight.onComplete.addOnce( this.onWaterWeightComplete.dispatch );
			this.surfIntro.onComplete.addOnce( this.onIntroComplete.dispatch );
		}
		
		private function _removeListeners():void
		{
			this.bucketConveyorModel.onEmptyBucket.remove( this._bucketRelease );
			this.elevatorPuzzleModel.onHeightChanged.remove( this._heightChanged );
			this.waterWeight.onComplete.remove( this.onWaterWeightComplete.dispatch );
			this.surfIntro.onComplete.remove( this.onIntroComplete.dispatch );
			this.farLeftButton.removeEventListener( MouseEvent.MOUSE_DOWN, this._farLeftButtonClicked );
			this.leftButton.removeEventListener( MouseEvent.MOUSE_DOWN, this._leftButtonClicked );
			this.rightButton.removeEventListener( MouseEvent.MOUSE_DOWN, this._rightButtonClicked );
			this.liftButton.removeEventListener( MouseEvent.MOUSE_DOWN, this._liftControlsClicked );
			this.liftControls.removeEventListener( MouseEvent.MOUSE_DOWN, this._liftControlsClicked );
			this.bucketButton.removeEventListener( MouseEvent.MOUSE_DOWN, this._onBucketButtonClicked );
		}
	}
}
