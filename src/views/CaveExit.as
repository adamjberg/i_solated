package views {
	import controllers.LevelController;
	import controllers.SoundManager;

	import core.SoundItem;
	import core.Sounds;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author Adam
	 */
	public class CaveExit extends Sprite implements IScreen 
	{
		[Embed(source="/../assets/zoopch3.swf", symbol="CAVEMOUTH")]
		private static const CAVE_EXIT:Class;
		
		public var onComplete:Signal = new Signal();
		
		public var caveExit:Sprite;
		public var rain1:Rain;
		public var rain2:Rain;
		public var rain3:Rain;
		public var rain4:Rain;
		public var splashes1:Splashes;
		public var splashes2:Splashes;
		public var splashes3:Splashes;
		public var splashes4:Splashes;
		private var mountains:Sprite;
		private var hills:Sprite;
		private var hills2:Sprite;
		private var player:Player;
		private var controller:LevelController;
		private var caveForeground:Sprite;
		private var foreground:Foreground;
		private var background:Background;
		private var pulse:Pulse;
		
		private var endTriggered:Boolean = false;
		
		public function CaveExit() 
		{
		}

		public function update(dt : Number) : void 
		{
			this.controller.update( dt );
			if( this.controller.playerModel.relativeXPos > 1450 && !endTriggered )
			{
				endTriggered = true;
				var si:SoundItem = SoundManager.getInstance().getSoundItem( Sounds.INTO_TIME_LAPSE );
				si.onComplete.addOnce( function( si:SoundItem ):void
				{
					_removeListeners();
					onComplete.dispatch(); 
				});
				si.play();
				this.controller.playerController.moveThroughPoints( [ new Point( 1850, 461 ) ] );
				this.controller.disableMovement();
			}
		}

		public function load(controller : *) : void 
		{
			this.controller = controller;
			player = new Player( this.controller.playerModel );
			
			pulse = new Pulse( this.controller.pulseModel, this.controller.playerModel );
			
			caveExit = new CAVE_EXIT();
			rain1 = new Rain( caveExit.removeChild( caveExit.getChildByName( 'rain1' ) ) as MovieClip );
			rain2 = new Rain( caveExit.removeChild( caveExit.getChildByName( 'rain2' ) ) as MovieClip );
			rain3 = new Rain( caveExit.removeChild( caveExit.getChildByName( 'rain3' ) ) as MovieClip );
			rain4 = new Rain( caveExit.removeChild( caveExit.getChildByName( 'rain4' ) ) as MovieClip );
			splashes1 = new Splashes( caveExit.removeChild( caveExit.getChildByName( 'splashes' ) ) as MovieClip );
			splashes2 = new Splashes( caveExit.removeChild( caveExit.getChildByName( 'splashes2' ) ) as MovieClip );
			splashes3 = new Splashes( caveExit.removeChild( caveExit.getChildByName( 'splashes3' ) ) as MovieClip );
			splashes4 = new Splashes( caveExit.removeChild( caveExit.getChildByName( 'splashes4' ) ) as MovieClip );
			
			caveForeground = new Sprite();
			caveForeground.addChild( caveExit.removeChild( caveExit.getChildByName( 'caveFore' ) ) as Sprite );
			caveForeground.addChild( rain1 );
			caveForeground.addChild( rain2 );
			caveForeground.addChild( rain3 );
			caveForeground.addChild( rain4 );
			caveForeground.addChild( splashes1 );
			caveForeground.addChild( splashes2 );
			caveForeground.addChild( splashes3 );
			caveForeground.addChild( splashes4 );
			
			foreground = new Foreground( caveForeground, new Sprite(), this.controller.foregroundModel );
			
			hills = new Sprite();
			hills2 = new Sprite();
			mountains = new Sprite();
			
			hills.addChild( caveExit.removeChild( caveExit.getChildByName( 'caveHills' ) ) as Sprite );
			hills2.addChild( caveExit.removeChild( caveExit.getChildByName( 'caveHills1' ) ) as Sprite );
			mountains.addChild( caveExit.removeChild( caveExit.getChildByName( 'caveMountains' ) ) as Sprite );
			background = new Background( [ mountains, hills, hills2 ], [ -.3, -0.35, -.4 ], this.controller.foregroundModel );
						
			this.addChild( caveExit );
			this.addChild( background );
			this.addChild( foreground );
			this.addChild( pulse );
			
			_playBGM();
			
			addChild( player );
			
			this.controller.playerModel.shouldBeRunning = true;
			this.controller.movePlayerTo( new Point( 400, 0 ) );
			this._addListeners();
		}

		private function _addListeners():void
		{
			this.player.onPulse.add( this.controller.pulse );
			player.onAnimationComplete.add( this.controller.playerController.changeAnimation );
		}

		private function _removeListeners():void
		{
			this.player.onPulse.remove( this.controller.pulse );
			player.onAnimationComplete.remove( this.controller.playerController.changeAnimation );
		}

		private function _playBGM():void
		{
			SoundManager.getInstance().createLoopCrossFade( Sounds.RAIN, 1, 1 );
			SoundManager.getInstance().createLoopCrossFade( Sounds.BGM_CH3, 2, 1 );
		}

		public function unload() : void 
		{
			this.removeChildren();
						
			caveExit = null;
			rain1 = null;
			rain2 = null;
			rain3 = null;
			rain4 = null;
			splashes1 = null;
			splashes2 = null;
			splashes3 = null;
			splashes4 = null;
			mountains = null;
			hills = null;
			hills2 = null;
			player = null;
			controller = null;
			caveForeground = null;
			foreground = null;
			background = null;
			
			Sounds.transitionOutCaveExit( 0.2, 0 );
			SoundManager.getInstance().stopSound( Sounds.CLIFF_WALKING );
		}
	}
}
