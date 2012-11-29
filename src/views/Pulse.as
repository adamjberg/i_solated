package views {
	import models.PulseModel;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	/**
	 * @author Adam
	 */
	public class Pulse extends Sprite
	{				
		private static const TIME_BETW_UPDATES:Number = 100;
		
		private static const PULSE_WIDTH:int = 5;
		
		private var model:PulseModel;
		
		private var lastUpdateTime:Number = 0;
		
		public function Pulse( pulseModel:PulseModel )
		{
			super();
			this.model = pulseModel;
			this.model.onComplete.add( _remove );
			this.model.onPlay.add( _add );
			this.model.onRadiusChanged.add( _redraw );
			this.visible = false;
			this.filters = [ new BlurFilter( 8, 8, 2 ) ];
			this.addEventListener( Event.ADDED_TO_STAGE, _addedToStage );
			this.mouseChildren = false;
			this.mouseEnabled = false;
		} 
		
		private function _addedToStage( e:Event ):void
		{
			this.scrollRect = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );
		}
		
		private function _remove():void
		{
			this.visible = false;
		}
		
		private function _add():void
		{
			this.visible = true;
		}
		
		private function _redraw( radius:Number ):void
		{			
			//if( getTimer() - lastUpdateTime < TIME_BETW_UPDATES )
				//return;
			
			lastUpdateTime = getTimer();
						
			var centerX:Number = model.centerX;
			var centerY:Number = model.centerY;
			
			this.graphics.clear();
			this.graphics.lineStyle( PULSE_WIDTH, 0x444444 );
			if( radius - PulseModel.SPACE_BETW > 0 )
				this.graphics.drawCircle( centerX, centerY, radius - PulseModel.SPACE_BETW ); 
			this.graphics.drawCircle( centerX, centerY, radius );
		}
	}
}
