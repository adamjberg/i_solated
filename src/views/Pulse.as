package views {
	import models.PulseModel;

	import utils.display.BitmapRenderer;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.utils.getTimer;

	/**
	 * @author Adam
	 */
	public class Pulse extends Bitmap
	{		
		private static const PULSE_WIDTH:int = 10;
		
		private var model:PulseModel;
		
		private var lastUpdateTime:Number = 0;
		
		public function Pulse( pulseModel:PulseModel )
		{
			var pulseGraphic:Shape = new Shape();
			pulseGraphic.graphics.lineStyle( PULSE_WIDTH, 0x444444 );
			pulseGraphic.graphics.drawCircle( 800, 800, 800 );
			pulseGraphic.graphics.drawCircle( 800, 800, 400 );
			pulseGraphic.filters = [ new BlurFilter( 8, 8, 2 ) ];
			
			super( BitmapRenderer.renderSingleBitmap( pulseGraphic ).bitmapData );

			this.model = pulseModel;
			this.model.onComplete.add( _remove );
			this.model.onPlay.add( _add );
			this.model.onRadiusChanged.add( _redraw );
			this.visible = false;
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
			lastUpdateTime = getTimer();
						
			var centerX:Number = model.centerX;
			var centerY:Number = model.centerY;
			
			this.width = this.height = radius * 2;
			this.x = centerX - this.width * 0.5;
			this.y = centerY - this.height * 0.5; 
		}
	}
}
