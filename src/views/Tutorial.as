package views {
	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Adam
	 */
	public class Tutorial extends Sprite 
	{		
		private static const PULSES_UNTIL_HINT:Number = 3;
		
		private var _mouse:TutorialMouse;
		private var _spaceBar:SpaceBar;
		private var _pulseCount:int = 0;
		private var _mouseClickPulse:MouseClickPulse;
		
		public function Tutorial() 
		{
			_mouse = new TutorialMouse();
			_spaceBar = new SpaceBar();
			this.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
		}
		
		private function _addedToStage( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, _addedToStage );
			this._spaceBar.x = stage.stageWidth * 0.5 - this._spaceBar.width * 0.5;
			this._spaceBar.y = stage.stageHeight - this._spaceBar.height * 1.5;
			this._mouse.x = ( stage.stageWidth - this._mouse.width ) * 0.5;
			this._mouse.y = stage.stageHeight - this._mouse.height * 1.5;
			this.showPulseControls();
		}
		
		public function showPulseControls():void
		{
			
			if( this._mouse && this.contains( this._mouse ) )
			{
				this.removeChild( this._mouse );
			}
			this.addChild( this._spaceBar );
		}
		
		public function showTagControls():void
		{
			this._pulseCount++;
			if( this._spaceBar && this.contains( _spaceBar ) )
			{
				this.removeChild( this._spaceBar );
			}
			if( this._pulseCount > PULSES_UNTIL_HINT )
			{
				_showHint();
			}
			this.addChild( _mouse );
		}
		
		private function _showHint():void
		{
			if( !this._mouseClickPulse )
			{
				this._mouseClickPulse = new MouseClickPulse();
				this._mouseClickPulse.x = this.stage.stageWidth * 0.8;
				this._mouseClickPulse.y = this.stage.stageHeight * 0.85;
				this.addChild( this._mouseClickPulse );
			}
			this._mouseClickPulse.pulse();
		}
	}
}
