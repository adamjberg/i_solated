package views {
	import core.SpriteManager;

	import models.ForegroundModel;
	import models.PulseModel;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Adam
	 */
	public class FrontPostForegroundTwo extends PostForeground 
	{
		public static const WATER_FALL:String = 'postWaterFall';
		public static const BRIDGE:String = 'postBridge';
		public static const WATER_WHEEL:String = 'waterWheel';
		public static const STUCK_COG:String = 'stuckCog';
		public static const HILL_COG:String = 'hillCog';
		public static const DRIPPING:String = 'dripping';
		
		public var onBridgeHit:Signal = new Signal();
		public var onBridgeBreakComplete:Signal = new Signal();
		public var onBridgeClicked:Signal = new Signal();
		public var onHillCogClicked:Signal = new Signal();
		public var onStuckCogClicked:Signal = new Signal();
		public var onGateOpened:Signal = new Signal();
		public var onFinalLogCrack:Signal = new Signal();

		private var frontForeground:Sprite;

		private var dripping:MovieClip;
		private var drippingAnimation:Dripping;
		private var hillCog:Sprite;
		private var stuckCog:Sprite;
		private var waterFall:MovieClip;
		private var waterFallAnimation:WaterFall;
		public var waterWheel:MovieClip;
		public var waterWheelAnimation:WaterWheel;
		private var postBridge:MovieClip;
		private var postBridgeAnimation:PostBridge;
		private var logCrackPoints : Array = [new Point(2830, 454), new Point(2890, 449)];

		public function FrontPostForegroundTwo( foreground:Sprite, foregroundModel:ForegroundModel, pulseModel:PulseModel ) 
		{
			frontForeground = new Sprite();
			var waterFallMask:TaggableMask = new TaggableMask( TaggableMask.TOP_LEFT );
			waterFallMask.graphics.beginFill( 0 );
			waterFallMask.graphics.drawRect( 0, -70, 800, 600 );
			waterFallMask.graphics.drawRect( 800, 360, 700, 200 );
			waterFallMask.graphics.drawRect( 1500, 373, 170, 200 );
			waterFallMask.graphics.drawRect( 1670, 0, 200, 800 );
			waterFallMask.graphics.drawRect( 1870, 360, 1000, 200 );
			
			var postBridgeMask:TaggableMask = new TaggableMask( TaggableMask.TOP_LEFT );
			postBridgeMask.graphics.beginFill( 0 );
			postBridgeMask.graphics.drawRect( 0, 0, 310, 400 );
			
			stuckCog = foreground.removeChild( foreground.getChildByName( STUCK_COG ) )as Sprite;
			stuckCog.cacheAsBitmap = true;
			hillCog = foreground.removeChild( foreground.getChildByName( HILL_COG ) ) as Sprite;
			hillCog.cacheAsBitmap = true;
			
			postBridge = foreground.removeChild( foreground.getChildByName( BRIDGE ) ) as MovieClip;
			postBridge.cacheAsBitmap = true;			
			waterWheel = foreground.removeChild( foreground.getChildByName( WATER_WHEEL ) ) as MovieClip;
			waterWheel.cacheAsBitmap = true;
			waterFall = foreground.removeChild( foreground.getChildByName( WATER_FALL ) ) as MovieClip;
			waterFall.cacheAsBitmap = true;
			dripping = foreground.removeChild( foreground.getChildByName( DRIPPING ) ) as MovieClip;
			dripping.cacheAsBitmap = true;
			
			frontForeground.x = foreground.x;
			frontForeground.y = foreground.y;
			
			frontForeground.addChild( stuckCog );
			frontForeground.addChild( hillCog );	
			frontForeground.addChild( waterWheel );
			frontForeground.addChild( postBridge );
			frontForeground.addChild( waterFall );
			frontForeground.addChild( dripping );
			
			super( frontForeground, foregroundModel, [ WATER_FALL, BRIDGE, WATER_WHEEL, STUCK_COG, HILL_COG, DRIPPING ], pulseModel, [ waterFallMask, postBridgeMask ] );			
			
			postBridgeAnimation = new PostBridge( postBridge );
			waterWheelAnimation = new WaterWheel( waterWheel );
			waterFallAnimation = new WaterFall( waterFall, true );
			drippingAnimation = new Dripping( dripping );
			
			frontForeground.addChild( waterWheelAnimation );
			frontForeground.addChild( waterFallAnimation );
			frontForeground.addChild( drippingAnimation );
			frontForeground.addChild( postBridgeAnimation );
			
			this._addListeners();
		}

		private function _addListeners():void
		{
			postBridgeAnimation.addEventListener( MouseEvent.MOUSE_DOWN, _onBridgeClicked );
		}

		private function _removeListeners():void
		{
			postBridgeAnimation.removeEventListener( MouseEvent.MOUSE_DOWN, _onBridgeClicked );
		}

		override public function destroy():void
		{
			super.destroy();
			this._removeListeners();
			
			onBridgeHit.removeAll();
			onBridgeBreakComplete.removeAll();
			onBridgeClicked.removeAll();
			onHillCogClicked.removeAll();
			onStuckCogClicked.removeAll();
			onGateOpened.removeAll();
			
			this.waterFallAnimation.destroy();
			this.postBridgeAnimation.destroy();
			this.waterWheelAnimation.destroy();
			
			onBridgeHit = null;
			onBridgeBreakComplete = null;
			onBridgeClicked = null;
			onHillCogClicked = null;
			onStuckCogClicked = null;
			onGateOpened = null;
			
			this.waterFall = null;
			this.waterWheel = null;
			this.waterFallAnimation = null;
			this.waterWheelAnimation = null;
			this.stuckCog = null;
			this.hillCog = null;
			this.postBridge = null;
			this.postBridgeAnimation = null;
		}

		// This is to allow the dripping to be visible not during a pulse
		public function tagDripping():void
		{
			this.tagObjectByName( DRIPPING );
		}

		public function enableBridge():void
		{
			postBridgeAnimation.mouseChildren = false;
			postBridgeAnimation.mouseEnabled = true;
			postBridgeAnimation.buttonMode = true;
		}
		
		public function disableBridge():void
		{
			postBridgeAnimation.mouseChildren = false;
			postBridgeAnimation.mouseEnabled = false;
		}
		
		public function checkForLogCrack( playerX:Number ):void
		{
			if( logCrackPoints.length <=  0 || !waterFallAnimation )
				return;
			if( playerX >= logCrackPoints[ 0 ].x )
			{
				this.waterFallAnimation.nextCrack();
				logCrackPoints.shift();
			}
			if( this.logCrackPoints.length == 0 )
				this.onFinalLogCrack.dispatch();
		}
		
		public function playLogBreak():void
		{
			this.waterFallAnimation.startWaterFall();
			this.drippingAnimation.destroy();
			this.frontForeground.removeChild( drippingAnimation );
		}
		
		public function enableHillCogPickUp():void
		{
			SpriteManager.enableMouse( hillCog );
			hillCog.addEventListener( MouseEvent.MOUSE_DOWN, _hillCogClicked );
		}
		
		public function removeHillCog():void
		{
			if( contains( hillCog ) )
			{
				stuckCog.removeEventListener( MouseEvent.MOUSE_DOWN, _hillCogClicked );
				SpriteManager.disableMouse( hillCog );
				frontForeground.removeChild( hillCog );
			}
		}
		
		public function removeStuckCog():void
		{
			if( contains( stuckCog ) )
			{
				stuckCog.removeEventListener( MouseEvent.MOUSE_DOWN, _stuckCogClicked );
				SpriteManager.disableMouse( stuckCog );
				frontForeground.removeChild( stuckCog );
			}
			waterWheelAnimation.loop();
		}
		
		public function enableStuckCogPickUp():void
		{
			SpriteManager.enableMouse( stuckCog );
			stuckCog.addEventListener( MouseEvent.MOUSE_DOWN, _stuckCogClicked );
		}
		
		public function playBridgeBreak():void
		{
			var bounds:Rectangle = postBridgeAnimation.getBounds( this );
			const maskWidth:Number = 1500;
			const maskHeight:Number = 1000;
			const animationWidth:Number = 600;
			this.clearMask();
			this.foregroundMask.graphics.beginFill( 0 );
			this.foregroundMask.graphics.drawRect( bounds.x - ( maskWidth - animationWidth ) * 0.5, bounds.y - 200, maskWidth, maskHeight );
			postBridgeAnimation.onBridgeHit.addOnce( this.onBridgeHit.dispatch );
			postBridgeAnimation.onComplete.addOnce( this.onBridgeBreakComplete.dispatch );
			postBridgeAnimation.play();
		}
		
		public function openGate():void
		{
			this.waterFallAnimation.onGateOpened.addOnce( this.onGateOpened.dispatch );
			this.waterFallAnimation.openGate();
		}
		
		public function revealWaterWheelAndCog():void
		{
			tagObjectByName( STUCK_COG );
			tagObjectByName( WATER_WHEEL );
		}
		
				
		public function bridgeTagged():void
		{
			this.postBridgeAnimation.playFallingPiece();
		}
		
		private function _onBridgeClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onBridgeClicked.dispatch();
		}
		
		private function _hillCogClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onHillCogClicked.dispatch();
		}
		
		private function _stuckCogClicked( e:MouseEvent ):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.onStuckCogClicked.dispatch();
		}
	}
}